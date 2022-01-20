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
}

struct SimialarityResponse : Decodable {
    var result : Double
}

struct ValidationResponse : Decodable {
    var result : String
}

struct Api : BackendApi {
    
    func getDrawingScore(strokes: [Stroke], currentHanzi: String) async -> Double? {
        let evaluationRequest = ValidationRequest(strokes: strokes, limit: 20, hanzi: "你")
        do {
            let response =  try await AF.request("http://127.0.0.1:11000/api/similarity",
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
        let evaluationRequest = ValidationRequest(strokes: strokes, limit: 20, hanzi: "你")
        do {
            let response =  try await AF.request("http://127.0.0.1:11000/api/validate/v2",
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
}
