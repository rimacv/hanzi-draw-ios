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


struct HanziRequest : Encodable {
    let hanzi: String
}
struct PinyinListRequest : Encodable {
    let hanziList: String
}
struct PinyinListResponse : Decodable {
    let pinyinList: [String]
}
struct HanziImageUrlResponse : Decodable {
    let fileName: String
}

struct HanziInfoResponse : Decodable {
    let definition: String
    let pinyin: String
}



