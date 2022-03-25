//
//  PurchaseWrapper.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 25.03.22.
//

import Foundation
import RevenueCat

struct PurchaseWrapper {
    
   public static func ifAppIsNotAdFree(action: @escaping () -> Void) {
        Purchases.shared.getCustomerInfo { (purchaserInfo, error) in
            if error == nil {
                if purchaserInfo != nil {
                    let hasUserAppFreeEntitlement = purchaserInfo?.entitlements.all.keys.contains("Ad Free")
                    if hasUserAppFreeEntitlement != nil  && hasUserAppFreeEntitlement! {
                        return
                    }
                }
            }
            action()
        }
    }
    public static func ifAppIsAdFreeElse(onAdFree: @escaping () -> Void, onNotAdFree: @escaping () -> Void) {
         Purchases.shared.getCustomerInfo { (purchaserInfo, error) in
             if error == nil {
                 if purchaserInfo != nil {
                     let hasUserAppFreeEntitlement = purchaserInfo?.entitlements.all.keys.contains("Ad Free")
                     if hasUserAppFreeEntitlement != nil  && hasUserAppFreeEntitlement! {
                         onAdFree()
                     }else{
                         onNotAdFree()
                     }
                 }
             }
         }
     }
    
}
