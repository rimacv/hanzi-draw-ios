//
//  BottomSheetResultView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 20.01.22.
//

import SwiftUI
import BottomSheet

struct DialogButton : ButtonStyle {
    let highlightColor : Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Rectangle().opacity(1).overlay(
            configuration.label
            
        ).padding()
            .foregroundColor(configuration.isPressed ? highlightColor : Color("dark"))
            .background(configuration.isPressed ? highlightColor : Color("dark"))
            .cornerRadius(8.0)
        
        
        
    }
}



struct BottomSheetResultView: View {
    @Binding var score : CGFloat
    var resetDrawField: () -> Void
    var nextHanzi: () -> Void
    var body: some View {
        GeometryReader{  geometry in
            ZStack{
                Rectangle().fill(.white).border(.white)
                VStack{
                    Rectangle().fill(Color("dark")).border(Color("dark")).overlay(Text("Score").bold().foregroundColor(.white)).padding(.leading,0).padding(.bottom, 20).frame(height:geometry.size.height * 0.35)
                    
                    Spacer()
                    HStack{
                        
                        ProgressView(value: self.score,total: 100)
                            .progressViewStyle(ResultProgressBarStyle(theme: .bubblegum))
                        Text(String(format: "%.2f",score))
                    }.padding(.leading).padding(.trailing).frame(height:50)
                    Spacer()
                    HStack{
                        
                        Button(action: resetDrawField){
                            ZStack{
                                Rectangle().opacity(0).frame(height: geometry.size.height * 0.1)
                                Text(String(localized: "Retry")).foregroundColor(.white)
                            }
                            
                        }
                        .buttonStyle(QuizButtonStyle(highlightColor:  Color.gray))
                        .padding().padding(.bottom)
                        
                        Button(action:nextHanzi){
                            ZStack{
                                Rectangle().opacity(0).frame(height:  geometry.size.height * 0.1)
                                Text(String(localized: "Continue")).foregroundColor(.white)
                            }
                        }
                        .buttonStyle(QuizButtonStyle(highlightColor:  Color.gray))
                        .padding().padding(.bottom)
                        
                        
                    }
                    
                    Spacer()
                    
                }
            }
        }
        
    }
    
}

struct BottomSheetResultView_Previews: PreviewProvider {
    @State static private var score : CGFloat = 1
    static var previews: some View {
        BottomSheetResultView(score: $score, resetDrawField: {}, nextHanzi: {}).previewLayout(.fixed(width: 200, height: 200))
    }
}
