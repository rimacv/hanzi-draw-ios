//
//  History.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 29.01.22.
//

import Foundation

struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    let sessionScores : [SessionScore]
    init(id: UUID = UUID(), date: Date = Date(), sessionScores: [SessionScore]) {
        self.id = id
        self.date = date
        self.sessionScores = sessionScores
    }
}

struct SessionScore: Identifiable, Codable {
    let id: UUID
    let text: String
    let score : Double

    init(id: UUID = UUID(), text: String, score : Double) {
        self.id = id
        self.score = score
        self.text = text
    }
}
