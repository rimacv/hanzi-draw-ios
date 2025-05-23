//
//  ContentView.swift
//  Shared
//
//  Created by Rimac Valdez on 03.01.22.
//

import SwiftUI
import RevenueCat

struct DeckListView: View {
    
    @Binding var decks: [Deck]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isEditViewShown: Bool = false
    @State private var isBuyFeatureViewShown: Bool = false
    @State private var newDeckData : Deck.Data =  Deck.Data()
    @State private var showLimitReachAlert = false
    
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
                                .accessibilityLabel(String(localized: "App Info"))
                        }
                        
                        
                        Button(action: {
                            isBuyFeatureViewShown = true
                        }) {
                            Image(systemName: "dollarsign.circle")
                        }
                        .accessibilityLabel(String(localized: "Buy new features"))
                    }
                    
                }
                ToolbarItem(placement:  .navigationBarTrailing) {
                    Button(action: {
                        
                        PurchaseWrapper.ifAppIsAdFreeElse(
                            onAdFree: {
                                isEditViewShown = true
                                
                            },
                            onNotAdFree:   {
                                if decks.count >= 4 {
                                    showLimitReachAlert = true
                                }else{
                                    isEditViewShown = true
                                }
                        })
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel(String(localized: "New Decks"))
                    .alert(isPresented: $showLimitReachAlert) {
                        Alert(title: Text(String(localized:"Deck limit reached")), message: Text(String(localized: "Upgrade to Pro to remove the limit.")), dismissButton: .default(Text(String(localized: "Got it!"))))
                    }
                }
                
            } )
            
            
            .sheet(isPresented: $isEditViewShown){
                NavigationView {
                    DeckEditView(data: $newDeckData)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(String(localized: "Dismiss")) {
                                    isEditViewShown = false
                                    newDeckData = Deck.Data()
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button(String(localized: "Add")) {
                                    let newDeck = Deck(data: newDeckData)
                                    decks.append(newDeck)
                                    newDeckData = Deck.Data()
                                    isEditViewShown = false
                                }.disabled(newDeckData.title == "" || newDeckData.deckEntries.count == 0)
                            }
                        }
                }
            }
            .sheet(isPresented: $isBuyFeatureViewShown){
                NavigationView {
                    BuyFeatureView()
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(String(localized: "Dismiss")) {
                                    isBuyFeatureViewShown = false
                                }
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
