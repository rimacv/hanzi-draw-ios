//
//  hanzidrawApp.swift
//  Shared
//
//  Created by Rimac Valdez on 03.01.22.
//

import SwiftUI
import GoogleMobileAds

struct Constants {
    static let drawPadSize = CGFloat(200)
}

@main
struct hanzidrawApp: App {
    let adsVM = AdsViewModel.shared
    
    init(){
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
  
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(adsVM)
        }
    }
}
