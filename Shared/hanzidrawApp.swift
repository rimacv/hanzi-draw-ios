//
//  hanzidrawApp.swift
//  Shared
//
//  Created by Rimac Valdez on 03.01.22.
//

import SwiftUI
import GoogleMobileAds
import RevenueCat
import Firebase
struct Constants {
    static var drawPadSize = CGFloat(200)
    static var adFrequency : Int = 3
    static var appVersion = "0.0.1"
    static var buildNumber = "r1"
}

@main
struct hanzidrawApp: App {
    let adsVM = AdsViewModel.shared
    init(){
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_BODvJYsoznPWIKVhHRVTbRqcZFd")
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        if(appVersion != nil && appVersion is String){
            Constants.appVersion = appVersion as! String
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"]
            if(buildNumber != nil && buildNumber is String){
                Constants.buildNumber = buildNumber as! String
            }
        }
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
  
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(adsVM)
                
        }
    }
}
