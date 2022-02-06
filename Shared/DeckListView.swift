//
//  ContentView.swift
//  Shared
//
//  Created by Rimac Valdez on 03.01.22.
//

import SwiftUI


struct DeckListView: View {
    
    @Binding var decks: [Deck]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isEditViewShown: Bool = false
    @State private var newDeckData : Deck.Data =  Deck.Data()
    
    let saveAction: ()->Void
    
    var body: some View {
        NavigationView{
            List{
                ForEach($decks) { $deck in
                    DeckView(deck: $deck)
                        .listRowBackground(deck.theme.mainColor)
                }
                .onDelete { indices in
                    decks.remove(atOffsets: indices)
                }
            }
            .navigationTitle(String(localized: "Decks"))
            .toolbar (content:{
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        NavigationLink(destination: InfoView()){
                                Image(systemName: "info.circle")
                            .accessibilityLabel(String(localized: "New Decks"))
                        }
                     
                        
                        Button(action: {
                            isEditViewShown
                            = true
                        }) {
                            Image(systemName: "dollarsign.circle")
                        }
                        .accessibilityLabel(String(localized: "New Decks"))
                    }
        
                }
                ToolbarItem(placement:  .navigationBarTrailing) {
                    Button(action: {
                        isEditViewShown
                        = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel(String(localized: "New Decks"))
                }
                
            } )
            
            
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
            .onChange(of: scenePhase) { phase in
                if phase == .inactive { saveAction() }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var decks = [Deck]()
    static var previews: some View {
        DeckListView(decks: $decks, saveAction: {})
    }
}
