//
//  ContentView.swift
//  Shared
//
//  Created by Rimac Valdez on 03.01.22.
//

import SwiftUI

struct DeckListView: View {
    @State var decks : [Deck] = Deck.sampleData
    
    var body: some View {
        NavigationView{
            List{
                ForEach($decks) { $deck in
                    DeckView(deck: deck)
                        .listRowBackground(deck.theme.mainColor)
                }
            }
            .navigationTitle("Decks")
            .toolbar {
                Button(action: {
                    
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Deck")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView()
    }
}
