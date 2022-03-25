//
//  AddDeckView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 27.01.22.
//

import SwiftUI

struct DeckEditView: View {
    
    @Binding var data: Deck.Data
    @State var newCards : String = ""
    @FocusState  var isFocused  : Bool 
    var body: some View {
        Form {
            Section(header: Text(String(localized: "Deck Info"))) {
                TextField("Title", text: $data.title, onCommit: {isFocused = true})
                ThemePicker(selection: $data.theme)
                HStack{
                    Slider(
                        value: $data.strokeSize,
                        in: 3...10
                        
                    )
                    Text("\(Int(data.strokeSize)) pts")
                }
              
            }
            Section(header: Text(String(localized: "Add Cards"))) {
                ForEach(data.deckEntries) { card in
                    Text(card.text)
                }
                .onDelete { indices in
                    data.deckEntries.remove(atOffsets: indices)
                }
                HStack {
                    TextField(String(localized: "Add charachters e.g. 汉子"), text: $newCards, onCommit:addCharachters ).focused($isFocused)
                    Button(action:addCharachters) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel("Add cards")
                    }
                    .disabled(newCards.isEmpty)
                    
                }
            }
            
        }
        
    }
    
    func addCharachters() {
        for hanzi in newCards{
            if(hanzi != " "){
                let deckEntry = Deck.DeckEntry(text: String(hanzi))
                data.deckEntries.append(deckEntry)
            }
        }
        newCards = ""
        
    }
}

struct AddDeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckEditView(data: .constant(Deck.sampleData[0].data))
    }
}
