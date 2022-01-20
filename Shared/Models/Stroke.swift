//
//  Drawing.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 09.01.22.
//

import CoreGraphics

struct Stroke : Encodable{
    var points: [CGPoint] = [CGPoint]()
    
    enum CodingKeys: String, CodingKey {
         case points    = "data"
     }
}
