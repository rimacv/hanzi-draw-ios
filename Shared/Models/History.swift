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

    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
    }
}

struct DeckEntryHistory: Identifiable, Codable {
    let id: UUID
    let score : Double

    init(id: UUID = UUID(), score : Double) {
        self.id = id
        self.score = score
    }
}
