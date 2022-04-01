//
//  DeckDetailView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 29.01.22.
//

import SwiftUI
import AdSupport
import AppTrackingTransparency


struct DeckDetailView: View {
    @Binding var deck : Deck
    @State private var data = Deck.Data()
    @State var isPresentingEditView = false
    @State private var  cards = String(localized: "cards")
    var body: some View {
        List {
            Section(header: Text(String(localized: "Deck Info"))) {
                NavigationLink(destination: PracticeView(deck: $deck)) {
                    Label(String(localized: "Start Learning Session"), systemImage: "graduationcap.fill")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label(String(localized: "Deck Size"), systemImage: "character.book.closed.fill.zh")
                    Spacer()
                    Text("\(deck.deckEntries.count) " + cards).onAppear{
                        updateCardsText()
                    }
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(deck.theme.name)
                        .padding(4)
                        .foregroundColor(deck.theme.accentColor)
                        .background(deck.theme.mainColor)
                        .cornerRadius(4)
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Label(String(localized: "Stroke width"), systemImage: "paintbrush.pointed.fill")
                    Spacer()
                    Text("\(Int(deck.strokeSize)) pts")
                        .padding(4)
                        .cornerRadius(4)
                }
                .accessibilityElement(children: .combine)
            }
            Section(header: Text(String(localized: "Cards - Average Score"))) {
                ForEach(deck.deckEntries) { deckEntry in
                    
                    HStack{
                        Label(deckEntry.text, systemImage: "character.book.closed.fill.zh")
                        Spacer()
                        if(deck.history.count > 0){
                            let averageScore = calculateAverageScore(deckEntry: deckEntry, deckHistory: deck.history)
                            
                            Label("\(NumberFormatter().string(from: NSNumber(value: averageScore)) ?? "$0") ", systemImage: "percent")
                        }else{
                            Label("0", systemImage: "percent")
                        }
                        
                    }
                    
                    
                }
            }
            Section(header: Text(String(localized: "History"))) {
                if deck.history.isEmpty {
                    Label(String(localized: "No sessions yet"), systemImage: "calendar.badge.exclamationmark")
                }
                ForEach(deck.history) { history in
                    NavigationLink(destination:HistoryView(history:history)){
                        HStack {
                            Image(systemName: "calendar")
                            Text(history.date, style: .date)
                        }
                    }
                }
            }
        }
        .navigationTitle(deck.title)
        .toolbar {
            Button(String(localized: "Edit")) {
                data = deck.data
                isPresentingEditView = true
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                DeckEditView(data: $data)
                    .navigationTitle(deck.title)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(String(localized: "Dismiss")) {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button(String(localized: "Done")) {
                                isPresentingEditView = false
                                deck.update(from: data)
                                updateCardsText()
                            }.disabled(data.title == "" || data.deckEntries.count == 0)
                        }
                    }
            }
        }
    }
    func updateCardsText(){
        if(deck.deckEntries.count == 1){
            cards = String(localized: "card")
        }else{
            cards = String(localized: "cards")
        }
    }
    
    func calculateAverageScore(deckEntry:Deck.DeckEntry , deckHistory: [History]) -> Double{
        if deckHistory.count == 0{
            return 0
        }
        var averageScore = 0.0
        var occurenceCounter = 0
        for historyEntry in deckHistory{
            for score in historyEntry.sessionScores{
                if(score.text == deckEntry.text){
                    averageScore += score.score
                    occurenceCounter += 1
                }
            }
            
        }
        if(occurenceCounter != 0){
            averageScore /= Double(occurenceCounter)
        }
        
        return averageScore
    }
}

struct DeckDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeckDetailView(deck: .constant(Deck(title:"", deckEntries: [Deck.DeckEntry](), theme: Theme.bubblegum)))
    }
}
