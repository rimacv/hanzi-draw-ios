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
    var body: some View {
        VStack{
            HStack(alignment: .center){
                QuizButtonView(isCorrectAnswer: true, quizOpacity: $quizOpacity)
                
                
                
                QuizButtonView(isCorrectAnswer: false, quizOpacity: $quizOpacity)
                
            }
            
            HStack(alignment: .center){
                QuizButtonView(isCorrectAnswer: false, quizOpacity: $quizOpacity)
                QuizButtonView(isCorrectAnswer: false, quizOpacity: $quizOpacity)
            }
        }.padding()
        
    }
}

struct QuizView_Previews: PreviewProvider {
    @State static var quizOpacity : Double = 1
    static var previews: some View {
        QuizView(quizOpacity: $quizOpacity)
    }
}
