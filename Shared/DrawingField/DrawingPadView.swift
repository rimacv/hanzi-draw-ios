//
//  DrawingPadView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 09.01.22.
//

import SwiftUI
import CachedAsyncImage
import BottomSheet


struct DrawingPadView: View {
    @Binding var currentDrawing: Stroke
    @Binding var drawings: [Stroke]
    @Binding var color: Color
    @Binding var lineWidth: CGFloat
    @Binding var inverseDrawPadOpacity : Double
    @Binding var bottomSheetPosition: BottomSheetPosition
    @Binding var score: CGFloat
    @Binding var currentHanzi: String
    
    var body: some View {
        VStack{
            CachedAsyncImage(url: URL(string: "https://hanzi-draw.de/text/raster.png")) { image in
                VStack{
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay{
                            GeometryReader { geometry in
                                Path { path in
                                    for drawing in self.drawings {
                                        self.add(drawing: drawing, toPath: &path)
                                    }
                                    self.add(drawing: self.currentDrawing, toPath: &path)
                                }
                                .stroke(self.color, lineWidth: CGFloat(Int(self.lineWidth)))
                                .background((.white.opacity(0.1)))
                                .gesture(
                                    DragGesture(minimumDistance: 0.1)
                                        .onChanged({ (value) in
                                            let currentPoint = value.location
                                            if currentPoint.y >= 0
                                                && currentPoint.y < geometry.size.height && currentPoint.x < geometry.size.width && currentPoint.x >= 0{
                                                
                                                
                                                self.currentDrawing.points.append(currentPoint)
                                            }
                                        })
                                        .onEnded({ (value) in
                                            self.drawings.append(self.currentDrawing)
                                            self.currentDrawing = Stroke()
                                        })
                                )
                            }
                        }
                }
                
            } placeholder: {
                ProgressView()
            }
            .frame(width: Constants.drawPadSize, height: Constants.drawPadSize)
            .opacity((1 - inverseDrawPadOpacity))
            
            Spacer()
                DrawingControlsView(strokes: $drawings,
                                    color: $color,
                                    lineWidth: $lineWidth,bottomSheetPosition: $bottomSheetPosition, score:$score, currentHanzi: $currentHanzi, backendApi: Api()).opacity((1 - inverseDrawPadOpacity)).padding().padding(.top, 5).padding(.bottom, 10)
            Spacer()
        }
    }
    
    private func add(drawing: Stroke, toPath path: inout Path) {
        let points = drawing.points
        if points.count > 1 {
            for i in 0..<points.count-1 {
                let current = points[i]
                let next = points[i+1]
                path.move(to: current)
                path.addLine(to: next)
            }
        }
    }
    
    
}
