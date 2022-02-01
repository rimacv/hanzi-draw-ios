//
//  DeckDetailView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 29.01.22.
//

import SwiftUI

struct DeckDetailView: View {
    @Binding var deck : Deck
    @State private var data = Deck.Data()
    @State var isPresentingEditView = false
    var body: some View {
        List {
            Section(header: Text("Deck Info")) {
                NavigationLink(destination: PracticeView(deck: deck)) {
                    Label("Start Learning Session", systemImage: "graduationcap.fill")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Deck Size", systemImage: "character.book.closed.fill.zh")
                    Spacer()
                    Text("\(deck.deckEntries.count) cards")
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
            }
            Section(header: Text("Cards")) {
                ForEach(deck.deckEntries) { deckEntry in
                    HStack{
                        Label(deckEntry.text, systemImage: "character.book.closed.fill.zh")
                        Spacer()
                        if(deckEntry.history.count > 0){
                            let averageScore = calculateAverageScore(deckEntryHistory: deckEntry.history)
                         
                            Label("\(NumberFormatter().string(from: NSNumber(value: averageScore)) ?? "$0") ", systemImage: "percent")
                        }else{
                            Label("0", systemImage: "percent")
                        }
                    
                    }
                   
                }
            }
            Section(header: Text("History")) {
                if deck.history.isEmpty {
                    Label("No sessions yet", systemImage: "calendar.badge.exclamationmark")
                }
                ForEach(deck.history) { history in
                    HStack {
                        Image(systemName: "calendar")
                        Text(history.date, style: .date)
                    }
                }
            }
        }
        .navigationTitle(deck.title)
        .toolbar {
            Button("Edit") {
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
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                deck.update(from: data)
                            }.disabled(deck.title == "" || deck.deckEntries.count == 0)
                        }
                    }
            }
        }
    }
    
    func calculateAverageScore(deckEntryHistory: [DeckEntryHistory]) -> Double{
        if deckEntryHistory.count == 0{
            return 0
        }
        var averageHistory = 0.0
        for entry in deckEntryHistory{
            averageHistory += entry.score
        }
        averageHistory /= Double(deckEntryHistory.count)
        return averageHistory
    }
}

struct DeckDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeckDetailView(deck: .constant(Deck(title:"", deckEntries: [Deck.DeckEntry](), theme: Theme.bubblegum)))
    }
}
