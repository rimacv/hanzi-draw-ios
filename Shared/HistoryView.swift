//
//  HistoryView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 02.02.22.
//

import SwiftUI

struct HistoryView: View {
    let history: History

    
    
    var body: some View {
        GeometryReader { geometry in
            List {
                Section(header: Text("Session Info")) {
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(history.date, style: .date)
                    }.accessibilityElement(children: .combine)
                    
                    HStack {
                        Label("Deck Size", systemImage: "character.book.closed.fill.zh")
                        Spacer()
                        Text("\(history.sessionScores.count) cards")
                    }
                    .accessibilityElement(children: .combine)
                    
                }
                Section(header: Text("Charachter scores")) {
                    ForEach(history.sessionScores) { score in
                        HStack {
                            Text(score.text + ": ")
                            RoundedRectangle(cornerRadius: 8).fill(LinearGradient(
                                gradient: .init(colors: [.green, .green]),
                                startPoint: .init(x: 0.5, y: 0),
                                endPoint: .init(x: 0.5, y: 0.6)
                            )).frame(width: (geometry.size.width - geometry.size.width * 0.5) * (score.score / 100), height:15)
                            Text("\(NumberFormatter().string(from: NSNumber(value: score.score)) ?? "$0")")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Session History")
        }
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: History(sessionScores: [SessionScore(text: "a", score: 12)]))
    }
}
