//
//  SplashScreenView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 08.01.22.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var hasTimeElapsed = false
    
    var body: some View {
        if(hasTimeElapsed){
            DeckListView()
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
                        .task(oneshotTimer)
                }
                .statusBar(hidden: true)
            }
        }
    
        
    }
    @Sendable private func oneshotTimer() async{
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
