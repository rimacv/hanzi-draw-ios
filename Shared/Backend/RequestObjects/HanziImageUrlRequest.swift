//
//  HanziImageUrlRequest.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 22.01.22.
//

import Foundation

//
//  EvaluationRequest.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 18.01.22.
//

import Foundation


struct HanziImageUrlRequest : Encodable {
    let hanzi: String
}

struct HanziImageUrlResponse : Decodable {
    let fileName: String
}



