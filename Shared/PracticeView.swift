//
//  PracticeView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 08.01.22.
//

import SwiftUI
import CachedAsyncImage
import BottomSheet


struct PracticeView: View {
    @State private var currentDrawing: Stroke = Stroke()
    @State private var drawings: [Stroke] = [Stroke]()
    @State private var color: Color = Color.black
    @State private var lineWidth: CGFloat = 3.0
    @State private var quizOpacity = 1.0
    @State private var showDrawPad = false
    @State private var bottomSheetPosition: BottomSheetPosition = .hidden
    @State private var score: CGFloat = 0
    
    @State private var hanziImageUrl = ""
    
    var deckIndex = 0
    let deck : Deck
    
    var body: some View {
        VStack{
            
//            if(hanziImageUrl != ""){
                CachedAsyncImage(url: URL(string: hanziImageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: Constants.drawPadSize, height: Constants.drawPadSize)
//            }
            ZStack{
                DrawingPadView(currentDrawing: $currentDrawing,
                               drawings: $drawings,
                               color: $color,
                               lineWidth: $lineWidth,
                               inverseDrawPadOpacity: $quizOpacity, bottomSheetPosition: $bottomSheetPosition, score: $score)
                
                QuizView(quizOpacity: $quizOpacity).padding(.bottom, 20)
                    .bottomSheet( bottomSheetPosition: $bottomSheetPosition, options: [.cornerRadius(8),.notResizeable], content: {
                        BottomSheetResultView(score: $score)
                    })
                
            }
            
        }
        .task {
            hanziImageUrl =  await Api().getImageUrlForHanzi(hanzi: deck.deckEntries[deckIndex])
            ??  hanziImageUrl
            
            print(hanziImageUrl)
        }
        
    }
}

struct PracticeView_Previews: PreviewProvider {
    @State static private var decks : [Deck] = Deck.sampleData
    static var previews: some View {
        PracticeView(deck: decks[0])
    }
}
