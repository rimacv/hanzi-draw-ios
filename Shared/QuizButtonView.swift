//
//  QuizButtonView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 09.01.22.
//

import SwiftUI
import BottomSheet
struct QuizButtonStyle : ButtonStyle {
    let highlightColor : Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? highlightColor : Color("dark"))
            .background(configuration.isPressed ? highlightColor : Color("dark"))
            .cornerRadius(8.0)
            
        
    }
}

struct QuizButtonView: View {
    let isCorrectAnswer : Bool
    @Binding var quizOpacity : Double
    
    var body: some View {
        Button(action:{
            if(isCorrectAnswer){
                withAnimation(.easeIn){
                    quizOpacity = 0
                }

            }
        }) {
            ZStack{
                Rectangle().opacity(0)
                Text("Sign In").foregroundColor(.white)
               
            }
            
        }.buttonStyle(QuizButtonStyle(highlightColor: isCorrectAnswer ?
                                      Color.green : Color.red))
            .opacity(quizOpacity)
        .cornerRadius(8)
    }
}

struct QuizButtonView_Previews: PreviewProvider {
    @State static var quizOpacity : Double = 1
    static var previews: some View {
        QuizButtonView(isCorrectAnswer: false, quizOpacity: $quizOpacity)
    }
}
