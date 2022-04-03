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
    @Binding var currentHanziPinyin: String
    @Binding var correctAnswerIndex : Int
    @Binding var flip : Bool
    var pinyinList : [String]
    var body: some View {
        let answerOptions = generateAnswerOptions()
        VStack{
            HStack(alignment: .center){
                QuizButtonView(isCorrectAnswer: answerOptions[0].1, quizOpacity: $quizOpacity, flip: $flip ,text: answerOptions[0].0)
                
                
                
                QuizButtonView(isCorrectAnswer: answerOptions[1].1, quizOpacity: $quizOpacity,flip: $flip, text: answerOptions[1].0)
                
            }
            
            HStack(alignment: .center){
                QuizButtonView(isCorrectAnswer: answerOptions[2].1, quizOpacity: $quizOpacity,flip: $flip,text: answerOptions[2].0)
                QuizButtonView(isCorrectAnswer: answerOptions[3].1, quizOpacity: $quizOpacity,flip: $flip,text: answerOptions[3].0)
            }
        }.padding()
        
    }
    
    func generateAnswerOptions() ->[(String, Bool)]{
        var answerOptions = [(String, Bool)]()
        var listOfWrongAnswers = [String]()
        
        for pinyin in pinyinList {
            if(!listOfWrongAnswers.contains(pinyin) && pinyin != currentHanziPinyin){
                listOfWrongAnswers.append(pinyin)
            }
            if(listOfWrongAnswers.count == 4){
                break
            }
        }
        
        while listOfWrongAnswers.count != 4 {
            let randomElement = FillUpPinyin.listOfFillUpPinyin.randomElement()!
            if(!listOfWrongAnswers.contains(randomElement) && randomElement != currentHanziPinyin){
                listOfWrongAnswers.append(randomElement)
               
            }
        }
        for wrongAnswer in listOfWrongAnswers{
            answerOptions.append((wrongAnswer, false))
        }
        answerOptions[correctAnswerIndex] = (currentHanziPinyin,true)
        return answerOptions
    }

}

struct QuizView_Previews: PreviewProvider {
    @State static var quizOpacity : Double = 1
    static var previews: some View {
        QuizView(quizOpacity: $quizOpacity, currentHanziPinyin: .constant(""), correctAnswerIndex: .constant(0), flip: .constant(false), pinyinList: [""])
    }
}
