//
//  SplashScreenView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 08.01.22.
//

import SwiftUI
import StoreKit

@MainActor
struct SplashScreenView: View {
    @State private var hasTimeElapsed = false
    
    @StateObject private var store = DeckStore()
    @State private var errorWrapper: ErrorWrapper?
    @EnvironmentObject var adsViewModel: AdsViewModel
    var body: some View {
        if(hasTimeElapsed){
            DeckListView(decks: $store.decks){
                Task {
                    do {
                        try await DeckStore.save(scrums: store.decks)
                    } catch {
                        errorWrapper = ErrorWrapper(error: nil, guidance: String(localized: "SaveError"))
                    }
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    adsViewModel.askForTrackingPermission()
                }
                
                if(isReviewViewToBeDisplayed(minimumLaunchCount: 6)){
                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }
                
            }
            .task {
                // Ensures that data is saved when app is started the first time
                do {
                    try await DeckStore.save(scrums: store.decks)
                } catch {
                    //errorWrapper = ErrorWrapper(error: nil, guidance: String(localized: "SaveError"))
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
            .sheet(item: $errorWrapper, onDismiss: {
                hasTimeElapsed = true
                errorWrapper = nil
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
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
            let adFrequency = await Api().getAddFrequency()
            if(adFrequency != nil){
                Constants.adFrequency = adFrequency!
            }
        } catch {
            store.decks = Deck.sampleData
            errorWrapper = ErrorWrapper(error: nil, guidance: String(localized: "DeckLoadError"))
        }
    }
    
    func IsFirstLaunch() -> Bool{
        if !UserDefaults.standard.bool(forKey: "HasLaunched") {
            UserDefaults.standard.set(true, forKey: "HasLaunched")
            UserDefaults.standard.set(1, forKey: "launchCountUserDefaultsKey")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    
    func isReviewViewToBeDisplayed(minimumLaunchCount:Int) -> Bool {
        let launchCount = UserDefaults.standard.integer(forKey: "launchCountUserDefaultsKey")
        if launchCount >= minimumLaunchCount {
            return true
        } else {
            UserDefaults.standard.set((launchCount + 1), forKey: "launchCountUserDefaultsKey")
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
