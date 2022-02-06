//
//  InfoView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 06.02.22.
//

import SwiftUI

extension Bundle {
    public var appName: String { getInfo("CFBundleName")  }
    public var displayName: String {getInfo("CFBundleDisplayName")}
    public var language: String {getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String {getInfo("CFBundleIdentifier")}
    public var copyright: String {getInfo("NSHumanReadableCopyright") }
    
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

struct InfoView: View {
    var body: some View {
     
    
        
             
        List{
        Section(header: Text(String(localized: "Info"))) {
            HStack{
                Spacer()
                VStack{
                    Text(String(localized: "汉子")).font(.headline)
                    Text(String(localized: "app_name")).font(.headline)
                    Text(String(localized: "Version")).font(.subheadline)
                    Text("\(Bundle.main.appVersionLong)").font(.subheadline)
                }
                Spacer()
             
            }
        }
            Section(header: Text(String(localized: "Licenses"))) {
                
                Link(destination: URL(string: "https://github.com/Alamofire/Alamofire/blob/master/LICENSE")!) {
                    Label("Alamofire", systemImage: "doc")
                }

                Link(destination: URL(string: "https://github.com/skishore/makemeahanzi/blob/master/LGPL")!) {
                    Label("Make me a Hanzi", systemImage: "doc")
                }
                
                Link(destination: URL(string: "https://github.com/LucasMucGH/BottomSheet/blob/main/LICENSE.txt")!) {
                    Label("Bottomsheet", systemImage: "doc")
                }
                
                Link(destination: URL(string: "https://github.com/lorenzofiamingo/SwiftUI-CachedAsyncImage/blob/main/LICENSE.md")!) {
                    Label("CachedAsyncImage", systemImage: "doc")
                }
                
            }
            
            Section(header: Text(String(localized: "Privacy"))) {
                Link(String(localized:"Privacy Policy"),
                      destination: URL(string: "https://hanzi-draw.de/privacy.html")!)
            }
            
        
        }
        .navigationTitle(String(localized: "About"))
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
