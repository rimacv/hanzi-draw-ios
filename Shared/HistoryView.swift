//
//  HistoryView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 02.02.22.
//

import SwiftUI
import SwiftUICharts

struct HistoryView: View {
    let history: History
    var body: some View {
        
        VStack{
            //LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen")
            BarChartView(data: ChartData(values: GetChartData()), title: "Scores", legend: "Deck Entry", form: ChartForm.medium)
        }
//
        
     
//
//        ForEach(history.sessionScores) { SessionScore in
//            HStack{
//
//
//
//
//
//            }
        }
    
           
        //}
    //}
    
    func GetChartData()-> [(String, Double)]{
        var data : [(String, Double)] = []
        for entry in history.sessionScores{
            data.append((entry.text, entry.score))
            data.append((entry.text, entry.score))
            data.append((entry.text, entry.score))
            data.append((entry.text, entry.score))
            data.append((entry.text, entry.score))
            data.append((entry.text, entry.score))
            data.append((entry.text, entry.score))
            data.append((entry.text, entry.score))
            data.append((entry.text, entry.score))
        }
        return data
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: History(sessionScores: [SessionScore(text: "a", score: 12)]))
    }
}
