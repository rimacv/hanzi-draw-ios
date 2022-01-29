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
