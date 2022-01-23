//
//  QuizView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 12.01.22.
//

import SwiftUI
import BottomSheet

struct QuizView: View {
    @Binding var quizOpacity : Double
    let answerOptions : [(String,Bool)]
    var body: some View {
        VStack{
            HStack(alignment: .center){
                QuizButtonView(isCorrectAnswer: answerOptions[0].1, quizOpacity: $quizOpacity, text: answerOptions[0].0)
                
                
                
                QuizButtonView(isCorrectAnswer: answerOptions[1].1, quizOpacity: $quizOpacity,text: answerOptions[1].0)
                
            }
            
            HStack(alignment: .center){
                QuizButtonView(isCorrectAnswer: answerOptions[2].1, quizOpacity: $quizOpacity,text: answerOptions[2].0)
                QuizButtonView(isCorrectAnswer: answerOptions[3].1, quizOpacity: $quizOpacity,text: answerOptions[3].0)
            }
        }.padding()
        
    }
}

struct QuizView_Previews: PreviewProvider {
    @State static var quizOpacity : Double = 1
    static var previews: some View {
        QuizView(quizOpacity: $quizOpacity, answerOptions: [(String,Bool)]())
    }
}
