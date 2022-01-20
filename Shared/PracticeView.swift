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
    
    @State var bottomSheetPosition: BottomSheetPosition = .hidden
    var body: some View {
        VStack{
            
            CachedAsyncImage(url: URL(string: "https://hanzi-draw.de/text/20320-still.png")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: Constants.drawPadSize, height: Constants.drawPadSize)
            
            ZStack{
                DrawingPadView(currentDrawing: $currentDrawing,
                               drawings: $drawings,
                               color: $color,
                               lineWidth: $lineWidth,
                               inverseDrawPadOpacity: $quizOpacity)
               
                QuizView(quizOpacity: $quizOpacity).padding(.bottom)
                    .bottomSheet(bottomSheetPosition: $bottomSheetPosition, options: [.cornerRadius(8)], content: {
                        Text("Hallo")
                    })
                    
            }

        }
   
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}
