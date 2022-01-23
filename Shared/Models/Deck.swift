import SwiftUI

struct Deck: Identifiable, Codable {
    let id: UUID
    var title: String
    var deckEntries: [String]
    var numberOfLearningSessions : Int = 0
    var theme: Theme
    
    init(id: UUID = UUID(), title: String, deckEntries: [String],theme: Theme) {
        self.id = id
        self.title = title
        self.deckEntries = deckEntries
        self.theme = theme
    }
}


extension Deck{
    var numberOfEntries: Int {
        return deckEntries.count
    }
}

extension Deck {
    static var sampleData: [Deck] {
        [
            Deck(title: "Basics A", deckEntries: ["是" ,"我", "你","是" ,"我", "你"],theme: .yellow),
            Deck(title: "Basics B",deckEntries: ["你", "我"], theme: .orange),
        ]
    }
}
