//
//  hanzidrawApp.swift
//  Shared
//
//  Created by Rimac Valdez on 03.01.22.
//

import SwiftUI
import GoogleMobileAds
import RevenueCat

struct Constants {
    static var drawPadSize = CGFloat(200)
    static var adFrequency : Int = 3
}

@main
struct hanzidrawApp: App {
    let adsVM = AdsViewModel.shared
    init(){
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_BODvJYsoznPWIKVhHRVTbRqcZFd")
    }
  
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(adsVM)
                
        }
    }
}
