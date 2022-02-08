//
//  DrawingControlsView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 12.01.22.
//

import SwiftUI
import BottomSheet

struct DrawingControlsView: View {
    @Binding var strokes: [Stroke]
    @Binding var color: Color
    @Binding var lineWidth: CGFloat
    @Binding var bottomSheetPosition: BottomSheetPosition
    @Binding var score: CGFloat
    @Binding var currentHanzi: String
    @State private var lastRemovedStroke : Stroke? = nil
    @State private var errorWrapper: ErrorWrapper?
    let backendApi : BackendApi
    private let spacing: CGFloat = 40
    private let buttonColor = Color("dark")

    var body: some View {
            HStack(spacing: spacing) {
                
                Button(action: {
                    if self.strokes.count > 0 {
                        lastRemovedStroke = strokes.removeLast()
                    }
                }){
                    ZStack{
                        Rectangle().opacity(0).frame(height:10)
                        HStack{
                            Image(systemName:"arrow.uturn.backward").foregroundColor(.white)
                            //Text(String(localized: "Undo")).foregroundColor(.white)
                        }
                    }
                }.cornerRadius(8).buttonStyle(QuizButtonStyle(highlightColor: Color.gray))
                
                Button(action: {
                    Task {
                        let score =  await backendApi.getDrawingScore(strokes: strokes, currentHanzi: currentHanzi)
                        if(score != nil){
                            withAnimation(.linear(duration:0.2)){
                                bottomSheetPosition = .top
                            }
                            withAnimation(.linear(duration: 0)){
                                self.score = score!
                            }
                        }else{
                            errorWrapper = ErrorWrapper(error: nil, guidance: String(localized: "ScoreFetchError"))
                        }
                 
                       
                    }
                }){
                    ZStack{
                        Rectangle().opacity(0).frame(height:10)
                    HStack{
                        Image(systemName: "checkmark").foregroundColor(.white)
                        //Text(String(localized: "Done")).foregroundColor(.white)
                    }
                    }
                }
                .sheet(item: $errorWrapper, onDismiss: {
                }) { wrapper in
                    ErrorView(errorWrapper: wrapper)
                }.cornerRadius(8).buttonStyle(QuizButtonStyle(highlightColor: Color.gray))
                
                Button(action: {
                    if lastRemovedStroke != nil {
                        strokes.append(lastRemovedStroke!)
                        lastRemovedStroke = nil
                    }
               
                }){
                    ZStack{
                        Rectangle().opacity(0).frame(height:10)
                    HStack{
                        Image(systemName: "arrow.uturn.forward").foregroundColor(.white)
                        //Text(String("Redo")).foregroundColor(.white)
                    }
                    }
                
                } .cornerRadius(8).buttonStyle(QuizButtonStyle(highlightColor: Color.gray))
                 
                
            }
    }
}

struct DrawingControlsView_Previews: PreviewProvider {
    @State static private var drawings: [Stroke] = [Stroke]()
    @State static private var color: Color = Color.black
    @State static private var lineWidth: CGFloat = 3.0
    @State static private var bottomSheetPosition: BottomSheetPosition = .hidden
    @State static private var score: CGFloat = 0
    static private var backendApi = Api()
    static var previews: some View {
        DrawingControlsView(strokes:$drawings,color:$color, lineWidth:$lineWidth,bottomSheetPosition:$bottomSheetPosition, score: $score, currentHanzi: .constant(""), backendApi: backendApi)
    }
}
