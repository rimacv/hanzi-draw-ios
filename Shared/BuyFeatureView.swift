//
//  BuyFeatureView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 19.03.22.
//

import SwiftUI
import RevenueCat
import ConfettiSwiftUI

struct BuyFeatureView: View {
    @State var offerPrice: String = ""
    @State var counter : Int = 0
    @State var isProductBought = false
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some View {
        
        
        
        GeometryReader{  geometry in
            ScrollView{
                VStack{
                    if(!isProductBought){
                        Text(String(localized: "Purchase Header")).font(.title).bold()
                    }else{
                        Text(String(localized: "Thank you!")).font(.title).bold().scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1).padding()
                    }
                    
                    Spacer()
                    ZStack{
                        ConfettiCannon(counter: $counter,num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        Image(systemName: "graduationcap.fill").resizable().aspectRatio(contentMode: .fit).frame(width:geometry.size.width * 0.3, height: geometry.size.height * 0.3)
                        HStack{
                            Rectangle().opacity(0).frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.3)
                            VStack{
                                Rectangle().opacity(0).frame(width: geometry.size.width * 0.12, height: geometry.size.height * 0.12)
                                Image(systemName: "plus.circle.fill").resizable().aspectRatio(contentMode: .fit).frame(width:geometry.size.width * 0.08, height: geometry.size.height * 0.08)
                            }
                            
                        }
                        
                    }
                    if(!isProductBought){
                        Text(String(localized: "Offer Price") + offerPrice ).bold().scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1).padding()
                        
                        Text(String(localized: "Purchase Description")).bold().scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1).padding(.leading).padding(.trailing)
                        Text(String(localized: "Purchase Description 2")).bold().scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1).padding(.leading).padding(.trailing)
                        Text(String(localized: "Purchase Support Description")).bold()
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1).padding(.leading).padding(.trailing)
                    }else{
                        Text(String(localized: "Purchase Successful!")).bold().scaledToFit()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1).padding()
                    }
                    
                    Spacer()

                    
                    if(!isProductBought){
                        Button(action: {
                            Purchases.shared.getOfferings { (offerings, error) in
                                if let packages = offerings?.current?.availablePackages {
                                    
                                    if(packages.first != nil){
                                        let package = packages.first!
                                        Purchases.shared.purchase(package: packages.first!) { (transaction, customerInfo, error, userCancelled) in
                                            if !userCancelled {
                                                if error != nil {
                                                    errorWrapper = ErrorWrapper(error: error, guidance: String(localized: "BuyError"))
                                                }else{
                                                    counter += 1
                                                    isProductBought = true
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }){
                            ZStack{
                                Rectangle().opacity(0).frame(height: geometry.size.height * 0.05)
                                Text(String(localized: "Buy")).foregroundColor(.white)
                            }
                            
                        }
                        .buttonStyle(QuizButtonStyle(highlightColor:  Color.gray))
                        .padding().disabled(isProductBought)
                        
                        Button(action: {
                            Purchases.shared.restorePurchases { customerInfo, error in
                                if error == nil {
                                    let hasUserAppFreeEntitlement = customerInfo?.entitlements.all.keys.contains("Ad Free")
                                    if hasUserAppFreeEntitlement != nil  && hasUserAppFreeEntitlement! {
                                        isProductBought = true
                                    }
                                }else{
                                    errorWrapper = ErrorWrapper(error: error, guidance: String(localized: "RestorePurchaseError"))
                                }
                            }
                        }){
                            ZStack{
                                Rectangle().opacity(0).frame(height: geometry.size.height * 0.05)
                                Text(String(localized: "Restore Purchase")).foregroundColor(.white)
                            }
                            
                        }
                        .buttonStyle(QuizButtonStyle(highlightColor:  Color.gray))
                        .padding().padding(.bottom).disabled(isProductBought)
                        
                    }
                    else{
                        
                        Button(action: {}){
                            ZStack{
                                Rectangle().opacity(0).frame(height: geometry.size.height * 0.05)
                                Text(String(localized: "Buy")).foregroundColor(.white)
                            }
                            
                        }
                        .buttonStyle(QuizButtonStyle(highlightColor:  Color.gray, defaultColor: Color.gray))
                        .padding().padding(.bottom).disabled(isProductBought)
                        
                        Button(action: {}){
                            ZStack{
                                Rectangle().opacity(0).frame(height: geometry.size.height * 0.05)
                                Text(String(localized: "Restore Purchase")).foregroundColor(.white)
                            }
                            
                        }
                        .buttonStyle(QuizButtonStyle(highlightColor:  Color.gray,  defaultColor: Color.gray))
                        .padding().padding(.bottom).disabled(isProductBought)
                    }
                }
            }
            
            
            
        }.onAppear{
            
            Purchases.shared.getCustomerInfo { (purchaserInfo, error) in
                if error == nil {
                    if purchaserInfo != nil {
                        let hasUserAppFreeEntitlement = purchaserInfo?.entitlements.all.keys.contains("Ad Free")
                        if hasUserAppFreeEntitlement != nil  && hasUserAppFreeEntitlement! {
                            isProductBought = true
                            return
                        }
                    }
                }
            }
            
            Purchases.shared.getOfferings { (offerings, error) in
                if let packages = offerings?.current?.availablePackages {
                    
                    if(packages.first != nil){
                        let package = packages.first!
                        offerPrice = package.localizedPriceString
                    }
                }
            }
        }
        .sheet(item: $errorWrapper, onDismiss: {
        }) { wrapper in
            ErrorView(errorWrapper: wrapper)
        }.cornerRadius(8).buttonStyle(QuizButtonStyle(highlightColor: Color.gray))
    }
}

struct BuyFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        BuyFeatureView()
    }
}
