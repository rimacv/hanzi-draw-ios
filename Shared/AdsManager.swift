//
//  AdsManager.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 23.01.22.
//

import Foundation

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}

class AdsManager: NSObject, ObservableObject {
    
    private struct AdMobConstant {
        static let interstitial1ID = "ca-app-pub-9021609527295015/4206259158"
    }
    
    final class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {
        
        private var interstitial: GADInterstitialAd?
        
        override init() {
            super.init()
        }
        
        func requestInterstitialAds() {
            DispatchQueue.main.async {
                let request = GADRequest()
                request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                GADInterstitialAd.load(withAdUnitID: AdMobConstant.interstitial1ID, request: request, completionHandler: { [self] ad, error in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    interstitial = ad
                    interstitial?.fullScreenContentDelegate = self
                })
            }
        }
        
        func showAd() {
            let root = getKeyWindow()?.rootViewController
            if let fullScreenAds = interstitial {
                if(root != nil){
                    fullScreenAds.present(fromRootViewController: root!)
                }
            } else {
                print("not ready")
            }
        }
        
        func getKeyWindow () -> UIWindow? {
            return UIApplication.shared.connectedScenes
                // Keep only active scenes, onscreen and visible to the user
                .filter { $0.activationState == .foregroundActive }
                // Keep only the first `UIWindowScene`
                .first(where: { $0 is UIWindowScene })
                // Get its associated windows
                .flatMap({ $0 as? UIWindowScene })?.windows
                // Finally, keep only the key window
                .first(where: \.isKeyWindow)
        }
        
    }
    
    
}


class AdsViewModel: ObservableObject {
    static let shared = AdsViewModel()
    @Published var interstitial = AdsManager.Interstitial()
    @Published var showInterstitial = false {
        didSet {
            if showInterstitial {
                interstitial.showAd()
                showInterstitial = false
            } else {
                interstitial.requestInterstitialAds()
            }
        }
    }
    
    func askForTrackingPermission(){
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { [self] status in
            if status == .authorized {
                print(ASIdentifierManager.shared().advertisingIdentifier)
              
            }
            interstitial.requestInterstitialAds()
        })
    }
    
}
