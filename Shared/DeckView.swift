//
//  DeckView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 08.01.22.
//

import SwiftUI

struct DeckView: View {
    @Binding var deck : Deck
    var body: some View {
        VStack(alignment: .leading){
            Text(deck.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            HStack {
                NavigationLink(destination: DeckDetailView(deck: $deck).onAppear{
                    
                }  ){
                    Label("\(deck.numberOfEntries)", systemImage: "character.book.closed.fill.zh")
                        .accessibilityLabel("\(deck.numberOfEntries) cards in deck")
                Spacer()
                    Label("\(deck.history.count)", systemImage: "graduationcap.fill")
                    .accessibilityLabel("\(deck.history.count) number of learning sessions")
                
                }
                .isDetailLink(false)
                
            }.font(.caption)
        }
        .padding()
        .foregroundColor(deck.theme.accentColor)
        
        
        
    }
}

struct DeckView_Previews: PreviewProvider {
    @State static var deck = Deck.sampleData[0]
    static var previews: some View {
        DeckView(deck: $deck)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
