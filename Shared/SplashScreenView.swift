//
//  SplashScreenView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 08.01.22.
//

import SwiftUI

@MainActor
struct SplashScreenView: View {
    @State private var hasTimeElapsed = false
    
    @StateObject private var store = DeckStore()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some View {
        if(hasTimeElapsed){
            DeckListView(decks: $store.decks){
                Task {
                    do {
                        try await DeckStore.save(scrums: store.decks)
                    } catch {
                        errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                    }
                }
            }
        }else{
            ZStack{
                Rectangle()
                VStack{
                    Text("汉字").foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                    Text(String(localized: "app_name")).foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                    
                        .task(loadDecks)
                }
                .statusBar(hidden: true)
            }
        }
    
        
    }
    
    @Sendable private func loadDecks() async{
        do {
            store.decks = try await DeckStore.load()
            if(IsFirstLaunch()){
                for deck in Deck.sampleData{
                    store.decks.append(deck)
                }
            }
            await oneshotTimer()
        } catch {
            errorWrapper = ErrorWrapper(error: error, guidance: "Scrumdinger will load sample data and continue.")
        }
    }
    
    func IsFirstLaunch() -> Bool{
        if !UserDefaults.standard.bool(forKey: "HasLaunched") {
                  UserDefaults.standard.set(true, forKey: "HasLaunched")
                  UserDefaults.standard.synchronize()
                  return true
              }
              return false
    }
    
     private func oneshotTimer() async{
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        hasTimeElapsed = true
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .environment(\.locale, .init(identifier: "en"))
    }
}
