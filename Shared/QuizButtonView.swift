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
    var defaultColor : Color = Color("dark")
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? highlightColor : defaultColor)
            .background(configuration.isPressed ? highlightColor : defaultColor)
            .cornerRadius(8.0)
            
        
    }
}

struct QuizButtonView: View {
    let isCorrectAnswer : Bool
    @Binding var quizOpacity : Double
    @Binding var flip : Bool
    let text: String
    var body: some View {
        Button(action:{
            if(isCorrectAnswer){
                withAnimation(.easeIn){
                    quizOpacity = 0
                    flip.toggle()
                }

            }
        }) {
            ZStack{
                Rectangle().opacity(0)
                Text(text).foregroundColor(.white)
               
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
        QuizButtonView(isCorrectAnswer: false, quizOpacity: $quizOpacity, flip: .constant(false), text: "")
    }
}
