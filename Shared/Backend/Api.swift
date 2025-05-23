//
//  Api.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 16.01.22.
//

import Foundation
import Alamofire

import CoreGraphics

protocol BackendApi {
    // protocol definition goes here
    func getDrawingScore(strokes: [Stroke], currentHanzi: String) async -> Double?
    func validateDrawing(strokes: [Stroke], currentHanzi: String) async -> String?
    func getImageUrlForHanzi(hanzi: String) async -> String?
}

struct SimialarityResponse : Decodable {
    var result : Double
}

struct ValidationResponse : Decodable {
    var result : String
}

struct Api : BackendApi {
    
    func getDrawingScore(strokes: [Stroke], currentHanzi: String) async -> Double? {
        let evaluationRequest = ValidationRequest(strokes: strokes, limit: 20, hanzi: currentHanzi)
        do {
            let response =  try await AF.request("https://hanzi-draw.de/api/similarity",
                                                 method: .post,
                                                 parameters: evaluationRequest,
                                                 encoder: JSONParameterEncoder.default).serializingData().value
            let decodedResponse = try JSONDecoder().decode(SimialarityResponse.self, from: response)
            return decodedResponse.result
        }
        catch {
            return nil
        }
    }
    
    func validateDrawing(strokes: [Stroke], currentHanzi: String) async -> String?{
        let evaluationRequest = ValidationRequest(strokes: strokes, limit: 20, hanzi: currentHanzi)
        do {
            let response =  try await AF.request("https://hanzi-draw.de/api/validate/v2",
                                                 method: .post,
                                                 parameters: evaluationRequest,
                                                 encoder: JSONParameterEncoder.default).serializingData().value
            let decodedResponse = try JSONDecoder().decode(ValidationResponse.self, from: response)
            return decodedResponse.result
        }
        catch {
            return nil
        }
    }
    
    func getImageUrlForHanzi(hanzi: String) async -> String? {
        let evaluationRequest = HanziRequest(hanzi: hanzi)
        do {
            let response =  try await AF.request("https://hanzi-draw.de/api/imagename",
                                                 method: .post,
                                                 parameters: evaluationRequest,
                                                 encoder: JSONParameterEncoder.default,
                                                 headers: ["Content-Type" : "application/json", "App-Version": "0.1", "Accept-Language": "en" ]).serializingData().value
            let decodedResponse = try JSONDecoder().decode(HanziImageUrlResponse.self, from: response)
            if(decodedResponse.fileName == "Not Found"){
                return nil
            }
            return "https://hanzi-draw.de/text/" + decodedResponse.fileName + ".png"
        }
        catch {
            return nil
        }
    }
    
    func getHanziInfo(hanzi: String) async -> HanziInfoResponse? {
        let evaluationRequest = HanziRequest(hanzi: hanzi)
        do {
            let response =  try await AF.request("https://hanzi-draw.de/api/info",
                                                 method: .post,
                                                 parameters: evaluationRequest,
                                                 encoder: JSONParameterEncoder.default,
                                                 headers: ["Content-Type" : "application/json", "App-Version": "0.1", "Accept-Language": "en" ]).serializingData().value
            let decodedResponse = try JSONDecoder().decode(HanziInfoResponse.self, from: response)
            return decodedResponse
        }
        catch {
            return nil
        }
    }
    
    
    
    func getPinyinList(hanziList: String) async -> [String]? {
        let evaluationRequest = PinyinListRequest(hanziList: hanziList)
        do {
            let headers = getHeaders()
            let response =  try await AF.request("https://hanzi-draw.de/api/infoList/pinyin",
                                                 method: .post,
                                                 parameters: evaluationRequest,
                                                 encoder: JSONParameterEncoder.default,
                                                 headers: headers).serializingData().value
            let decodedResponse = try JSONDecoder().decode(PinyinListResponse.self, from: response)
            return decodedResponse.pinyinList
        }
        catch {
            return nil
        }
    }
    
    func getAddFrequency() async -> Int? {
        do {
            let headers = getHeaders()
            let parameters : [String: [String]]? = nil
            let response =  try await AF.request("https://hanzi-draw.de/api/adfrequence",
                                                 method: .get,
                                                 parameters: parameters,
                                                 encoder: JSONParameterEncoder.default,
                                                 headers: headers).serializingData().value
            let decodedResponse = try JSONDecoder().decode(AdFrequenceResponse.self, from: response)
            return decodedResponse.frequence
        }
        catch {
            return nil
        }
    }
    
    func getStrokeHints(hanzi: String) async ->  [Stroke]? {
        do {
            let headers = getHeaders()
            let parameters =  HanziRequest(hanzi: hanzi)
            let response =  try await AF.request("https://hanzi-draw.de/api/strokehints",
                                                 method: .post,
                                                 parameters: parameters,
                                                 encoder: JSONParameterEncoder.default,
                                                 headers: headers).serializingData().value
            let decodedResponse = try JSONDecoder().decode(StrokeHints.self, from: response)
            var medians : [Stroke] = [Stroke]()
            for stroke in decodedResponse.medians {
                var median: Stroke = Stroke ()
                for point in stroke {
                    median.points.append(CGPoint(x: Api.normalizeX(x: Double(point[0]), width: 1024), y: Api.normalizeY(y: Double(point[1]), width: 1024)))
                }
                medians.append(median)
            }
            return medians
        }
        catch {
            print("Unexpected error: \(error).")
            return nil
        }
    }
    
    static func normalizeX(x: Double, width: Double) -> Int{
        return Int((x / width ) * Constants.drawPadSize)
    }
    
    static func normalizeY(y: Double, width: Double) -> Int{
        var myY = y - 900
        if(myY < 0){
            myY *= -1
        }
        return Int((myY / width ) * Constants.drawPadSize)
    }
    
    func getHeaders() -> HTTPHeaders {
        return  ["Content-Type" : "application/json", "App-Version": Constants.appVersion, "Accept-Language": "en", "Platform" : "ios" ]
    }
}
