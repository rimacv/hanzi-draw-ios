import SwiftUI

struct Deck: Identifiable, Codable {
    let id: UUID
    var title: String
    var deckEntries: [DeckEntry]
    var history : [History] = []
    var theme: Theme
    var strokeSize : CGFloat
    var mode : Mode
    init(id: UUID = UUID(), title: String, deckEntries: [DeckEntry],theme: Theme, strokeSize : CGFloat = 7, mode : Mode = .guided) {
        self.id = id
        self.title = title
        self.deckEntries = deckEntries
        self.theme = theme
        self.strokeSize = strokeSize
        self.mode = mode
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
        var strokeSize : CGFloat = 7
        var mode : Mode = Mode.guided
    }
    
    var data: Data {
        Data(title: title, deckEntries: deckEntries, theme: theme, strokeSize: strokeSize, mode: mode )
    }
    
    mutating func update(from data: Data) {
        title = data.title
        deckEntries = data.deckEntries
        theme = data.theme
        strokeSize = data.strokeSize
        mode = data.mode
    }
    
    init(data: Data) {
        id = UUID()
        title = data.title
        deckEntries = data.deckEntries
        theme = data.theme
        strokeSize = data.strokeSize
        mode = data.mode
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

enum Mode: String, CaseIterable, Identifiable, Codable {
    case guided
    case free

    var name: String {
        rawValue.capitalized
    }
    var id: String {
        name
    }
    
    func getLocalizedName() -> String {
        switch self {
        case .guided : return String(localized: "GUIDED")
        case .free : return String(localized: "FREE")
        }
    }
}
