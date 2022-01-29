import SwiftUI

struct Deck: Identifiable, Codable {
    let id: UUID
    var title: String
    var deckEntries: [DeckEntry]
    var history : [History] = []
    var theme: Theme
    
    init(id: UUID = UUID(), title: String, deckEntries: [DeckEntry],theme: Theme) {
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
    
    struct Data {
        var title: String = ""
        var deckEntries: [DeckEntry] = []
        var theme: Theme = .seafoam
    }
    
    var data: Data {
        Data(title: title, deckEntries: deckEntries, theme: theme)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        deckEntries = data.deckEntries
        theme = data.theme
    }
    
    init(data: Data) {
        id = UUID()
        title = data.title
        deckEntries = data.deckEntries
        theme = data.theme
    }
}

extension Deck{
    struct DeckEntry : Codable, Identifiable{
        var id: UUID = UUID()
        var text: String
        
        init(id: UUID? = nil, text: String) {
            self.id = id ?? self.id
            self.text = text
        }
        
        private enum CodingKeys: String, CodingKey {
               case text
        }
    }
}

extension Deck {
    static var sampleData: [Deck] {
        [
            Deck(title: "Basics A", deckEntries: [DeckEntry(text:"是") , DeckEntry(text:"我"), DeckEntry(text:"你"), DeckEntry(text:"是" ), DeckEntry(text:"我"), DeckEntry(text:"你")],theme: .yellow),
            Deck(title: "Basics B",deckEntries: [DeckEntry(text:"你"), DeckEntry(text:"我")], theme: .orange),
        ]
    }
}
