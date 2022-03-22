import SwiftUI

struct Deck: Identifiable, Codable {
    let id: UUID
    var title: String
    var deckEntries: [DeckEntry]
    var history : [History] = []
    var theme: Theme
    var strokeSize : CGFloat
    init(id: UUID = UUID(), title: String, deckEntries: [DeckEntry],theme: Theme, strokeSize : CGFloat = 7) {
        self.id = id
        self.title = title
        self.deckEntries = deckEntries
        self.theme = theme
        self.strokeSize = strokeSize
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
        var strokeSize : CGFloat = 3
    }
    
    var data: Data {
        Data(title: title, deckEntries: deckEntries, theme: theme, strokeSize: strokeSize)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        deckEntries = data.deckEntries
        theme = data.theme
        strokeSize = data.strokeSize
    }
    
    init(data: Data) {
        id = UUID()
        title = data.title
        deckEntries = data.deckEntries
        theme = data.theme
        strokeSize = data.strokeSize
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
            Deck(title: "Basics A", deckEntries: [DeckEntry(text:"我"), DeckEntry(text:"你"), DeckEntry(text:"她"), DeckEntry(text:"他" ), DeckEntry(text:"们")],theme: .yellow),
            Deck(title: "Basics B",deckEntries: [DeckEntry(text:"是"), DeckEntry(text:"很"), DeckEntry(text:"好"), DeckEntry(text:"吗"), DeckEntry(text:"呢")], theme: .orange),
        ]
    }
    
}
