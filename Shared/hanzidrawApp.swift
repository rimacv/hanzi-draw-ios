//
//  hanzidrawApp.swift
//  Shared
//
//  Created by Rimac Valdez on 03.01.22.
//

import SwiftUI

struct Constants {
    static let drawPadSize = CGFloat(200)
}

@main
struct hanzidrawApp: App {
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
