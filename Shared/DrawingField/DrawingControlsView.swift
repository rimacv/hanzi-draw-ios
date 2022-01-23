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
    
    let backendApi : BackendApi
    private let spacing: CGFloat = 40
    private let buttonColor = Color("dark")
    
    var body: some View {
        
        VStack{
            HStack(spacing: spacing) {
                
                Button("Undo") {
                    if self.strokes.count > 0 {
                        lastRemovedStroke = strokes.removeLast()
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                Button("Done") {
                    //self.drawings = [Drawing]()
                    Task {
                        let score =  await backendApi.getDrawingScore(strokes: strokes, currentHanzi: currentHanzi)
                        print(score)
                        let hanzis =  await backendApi.validateDrawing(strokes: strokes, currentHanzi: currentHanzi)
                        print(hanzis)
                        withAnimation(.linear(duration:0.2)){
                            bottomSheetPosition = .top
                        }
                        withAnimation(.linear(duration: 0)){
                            self.score = score!
                        }
                       
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Button("Redo") {
                    if lastRemovedStroke != nil {
                        strokes.append(lastRemovedStroke!)
                        lastRemovedStroke = nil
                    }
                    
                }.padding()
                    .foregroundColor(.white)
                    .background(buttonColor)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
            }
            
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
