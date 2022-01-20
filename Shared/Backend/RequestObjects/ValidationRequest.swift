//
//  EvaluationRequest.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 18.01.22.
//

import Foundation


struct ValidationRequest : Encodable {
    let data: String
    let limit:Int
    let hanzi: String
    
    init(strokes: [Stroke], limit: Int, hanzi: String){
        var strokeData = [[[Int]]]()
        for stroke in strokes {
            var convertedStroke = [[Int]]()
            for point in stroke.points {
                var points = [Int]()
                let normalizedX = ValidationRequest.normalize(x: point.x, width: Constants.drawPadSize)
                let normalizedY = ValidationRequest.normalize(x: point.y, width: Constants.drawPadSize)
             
                points.append(normalizedX)
                points.append(normalizedY)
                convertedStroke.append(points)
            }
            strokeData.append(convertedStroke)
        }
        self.data = strokeData.description
        self.limit = limit
        self.hanzi = hanzi
       
    }
    
    static func normalize(x: Double, width: Double) -> Int{
        return Int((x / width ) * 255)
    }
}



