//
//  ContentView.swift
//  Shared
//
//  Created by Rimac Valdez on 03.01.22.
//

import SwiftUI
import BottomSheet


struct DeckListView: View {
    @State var decks : [Deck] = Deck.sampleData
    @State private var isEditViewShown: Bool = false
    @State private var newDeckData : Deck.Data =  Deck.Data()
    
    var body: some View {
        NavigationView{
            List{
                ForEach($decks) { $deck in
                    DeckView(deck: deck)
                        .listRowBackground(deck.theme.mainColor)
                }
                .onDelete { indices in
                    decks.remove(atOffsets: indices)
                }
            }
            .navigationTitle(String(localized: "Decks"))
            .toolbar {
                Button(action: {
                    isEditViewShown
                    = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(String(localized: "New Decks"))
            }
            .sheet(isPresented: $isEditViewShown){
                NavigationView {
                    DeckEditView(data: $newDeckData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isEditViewShown = false
                                newDeckData = Deck.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newDeck = Deck(data: newDeckData)
                                decks.append(newDeck)
                                newDeckData = Deck.Data()
                                isEditViewShown = false
                            }.disabled(newDeckData.title == "" || newDeckData.deckEntries.count == 0)
                        }
                    }
                }
            }
        }
     
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView()
    }
}
