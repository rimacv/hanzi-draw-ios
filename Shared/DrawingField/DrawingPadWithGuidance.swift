//
//  DrawingPadView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 09.01.22.
//

import SwiftUI
import CachedAsyncImage
import BottomSheet

struct DrawingPadWithGuidance: View {
    @Binding var currentStroke: Stroke
    @Binding var strokes: [Stroke]
    @Binding var color: Color
    @Binding var lineWidth: CGFloat
    @Binding var inverseDrawPadOpacity : Double
    @Binding var bottomSheetPosition: BottomSheetPosition
    @Binding var score: CGFloat
    @Binding var currentHanzi: String
    
    @Binding var percentage: CGFloat
    @Binding var strokeOpacity : Double
    @Binding var hintStrokes: [Stroke]
    @State var currentHintStrokeBoundingBox : CGRect? = CGRect()
    let animationDuration = 0.5
    
    
    var body: some View {
        
        VStack{
            CachedAsyncImage(url: URL(string: "https://hanzi-draw.de/text/raster.png")) { image in
                VStack{
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay{
                            
                            if(inverseDrawPadOpacity == 0){
                                Path { path in
                                    let hintStroke =  GetCurrentHintStroke()
                                    if(hintStroke != nil){
                                        self.DrawStrokeAsPath(stroke: hintStroke!, toPath: &path)
                                    }
                                }
                                .trim(from: 0, to: percentage)
                                .stroke(Color.black, style: StrokeStyle(lineWidth: CGFloat(Int(self.lineWidth)), lineCap: .round, lineJoin: .round))
                                .opacity(strokeOpacity)

                                .onAnimationCompleted(for: self.percentage){
                                    withAnimation(.linear(duration: animationDuration)){
                                        strokeOpacity = 0
                                    }
                                }
                                .onChange(of: strokes.count){ _ in
                                    UpdateCurrentHintStrokeBoundingBox()
                                }
                                .onAppear {
                                    UpdateCurrentHintStrokeBoundingBox()
                                }
                            }

                        }
                        .overlay{
                            GeometryReader { geometry in
                                Path { path in
                                    for stroke in self.strokes {
                                        self.DrawStrokeAsPath(stroke: stroke, toPath: &path)
                                    }
                                    self.DrawStrokeAsPath(stroke: self.currentStroke, toPath: &path)
                                }
                                .stroke(self.color, style: StrokeStyle(lineWidth: CGFloat(Int(self.lineWidth)), lineCap: .round, lineJoin: .round))
                                .background((.white.opacity(0.1)))
                                .gesture(
                                    DragGesture(minimumDistance: 0.1)
                                        .onChanged({ (value) in
                                            let currentPoint = value.location
                                            if currentPoint.y >= 0
                                                && currentPoint.y < geometry.size.height && currentPoint.x < geometry.size.width && currentPoint.x >= 0  {
                                                if(currentHintStrokeBoundingBox == nil){
                                                    self.currentStroke.points.append(currentPoint)
                                                  
                                                }else if currentHintStrokeBoundingBox!.contains(currentPoint){
                                                    self.currentStroke.points.append(currentPoint)
                                                }else{
                                                    self.color = .red
                                                    self.currentStroke.points.append(currentPoint)
                                                }
                                              
                                               
                                            }
                                        })
                                        .onEnded({ (value) in
                                            self.percentage = 0.0
                                            if(currentStroke.points.count > 0 && self.color != .red){
                                                self.strokes.append(self.currentStroke)
                                            }else{
                                                withAnimation(.linear(duration: animationDuration)) {
                                                  self.percentage = 1
                                                  self.strokeOpacity = 1
                                                    
                                                }
                                            }
                                            self.color = .black
                                            self.currentStroke = Stroke()
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
                DrawingControlsView(strokes: $strokes,
                                    color: $color,
                                    lineWidth: $lineWidth,bottomSheetPosition: $bottomSheetPosition, score:$score, currentHanzi: $currentHanzi, percentage:$percentage, backendApi: Api()).opacity((1 - inverseDrawPadOpacity)).padding().padding(.top, 5).padding(.bottom, 10)
            Spacer()
        }
    }
    
    private func GetCurrentHintStroke() -> Stroke?{
        var i = 0
        for stroke in self.hintStrokes {
            if i == strokes.count{
                return stroke
            }
            i += 1
        }
        return nil
    }

    private func UpdateCurrentHintStrokeBoundingBox(){
        let hintStroke = GetCurrentHintStroke()
        if(hintStroke != nil){
            var tmpPath = Path()
            DrawStrokeAsPath(stroke: hintStroke!,toPath: &tmpPath)
            currentHintStrokeBoundingBox = GetBoundingBox(br: tmpPath.boundingRect)
        }else{
            currentHintStrokeBoundingBox = nil
        }
    }
    
    private func DrawStrokeAsPath(stroke: Stroke, toPath path: inout Path) {
        let points = stroke.points
        if points.count > 1 {
            for i in 0..<points.count-1 {
                let current = points[i]
                let next = points[i+1]
                path.move(to: current)
                path.addLine(to: next)
            }
        }
    }
    
    private func GetBoundingBox(br : CGRect) -> CGRect{
        let additonalSize = 20.0
        let newP = CGPoint(x: br.origin.x - additonalSize, y: br.origin.y - additonalSize)
        let newWidth = br.width + additonalSize * 2
        let newHeigth = br.height + additonalSize * 2
        return CGRect(x: newP.x, y: newP.y, width: newWidth, height: newHeigth)
        

    }
    
    
}
