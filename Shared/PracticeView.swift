//
//  PracticeView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 08.01.22.
//

import SwiftUI
import CachedAsyncImage
import BottomSheet
import RevenueCat

struct HanziImage : View{
    @Binding var hanziImageUrl : String
    @Binding var currentHanzi : String
    
    var body: some View {
        if(!hanziImageUrl.isEmpty){
            CachedAsyncImage(url: URL(string: hanziImageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: Constants.drawPadSize, height: Constants.drawPadSize)
        }else{
            Text(currentHanzi).font(.system(size: 60)).frame(width: Constants.drawPadSize, height: Constants.drawPadSize)
        }
       
    }
}

struct HanziInfoView : View{
    @Binding var pinyin : String
    @Binding var definition : String
    
    var body: some View {
     
        VStack{
            Text(pinyin)
            Text(definition)
        }
        
       
    }
}

struct Info{
    private var randomizeHanzis = false
    private var deckIndex = 0
    private var hanziCounter = 0
    
    mutating func nextHanzi(){
        hanziCounter += 1
        deckIndex += 1
    }
    
    func getDeckIndex() -> Int{
        return deckIndex
    }
    
    func getHanziCounter() -> Int{
        return hanziCounter
    }
}

struct PracticeView: View {
    @State private var currentDrawing: Stroke = Stroke()
    @State private var drawings: [Stroke] = [Stroke]()
    @State private var color: Color = Color.black
    @State private var quizOpacity = 1.0
    @State private var showDrawPad = false
    @State private var bottomSheetPosition: BottomSheetPosition = .hidden
    @State private var score: CGFloat = 0
    @State private var currentHanzi = ""
    @State private var currentHanziDefinition = ""
    @State private var currentHanziPinyin = ""
    @State private var pinyinList : [String]?
    @State private var hanziImageUrl = ""
    @State private var sessionInfo = Info()
    @State private var isLoaded = false
    @State private var correctAnswerIndex = Int.random(in: 0..<4)
    @State private var sessionScores = [SessionScore]()
    @Binding var deck : Deck

    @State private var flip = false
    @State private var disabled = false
    
    @EnvironmentObject var adsViewModel: AdsViewModel
    @Environment(\.dismiss) var dismiss
    
    func SetDrawPadSize(size: Double){
        Constants.drawPadSize = size
    }

    var body: some View {
        GeometryReader() { geometry in
           
            if(!isLoaded){
                
                ProgressView()
                    .onAppear{
                        correctAnswerIndex = Int.random(in: 0..<4)
                    }
                    .task {
                        SetDrawPadSize(size: geometry.size.height * 0.38)
                        currentHanzi = deck.deckEntries[sessionInfo.getDeckIndex()].text
                        
                        
                        hanziImageUrl =  await Api().getImageUrlForHanzi(hanzi:currentHanzi) ??  ""
                        let hanziInfo = await Api().getHanziInfo(hanzi: currentHanzi)
                        currentHanziPinyin = hanziInfo?.pinyin ?? ""
                        currentHanziDefinition = hanziInfo?.definition ?? ""
                        
                        var hanziList = ""
                        for entry in deck.deckEntries{
                            hanziList += entry.text
                        }
                        pinyinList = await Api().getPinyinList(hanziList: hanziList)
                        isLoaded.toggle()
                    }
            }else{
                
                    VStack{
                        HStack{
                            Rectangle().opacity(0).frame(width: geometry.size.width * 0.85, height: 0)
                            Text("\(sessionInfo.getHanziCounter() + 1 ) / \(deck.numberOfEntries)  ")
                        }
                        
                        FlipView(HanziImage(hanziImageUrl: $hanziImageUrl, currentHanzi: $currentHanzi).padding(.bottom, 10), HanziInfoView(pinyin: $currentHanziPinyin, definition: $currentHanziDefinition), tap: {}, flipped:$flip, disabled: $disabled )
                  
         
                        ZStack{
                            DrawingPadView(currentDrawing: $currentDrawing,
                                           drawings: $drawings,
                                           color: $color,
                                           lineWidth: $deck.strokeSize,
                                           inverseDrawPadOpacity: $quizOpacity, bottomSheetPosition: $bottomSheetPosition, score: $score, currentHanzi: $currentHanzi )
                            
                            Spacer()
                            QuizView(quizOpacity: $quizOpacity, currentHanziPinyin: $currentHanziPinyin, correctAnswerIndex: $correctAnswerIndex, pinyinList: pinyinList!).padding(.bottom, 20)
                        }
                        .bottomSheet( bottomSheetPosition: $bottomSheetPosition, options: [.cornerRadius(8),.notResizeable,]    ,content: {
                            BottomSheetResultView(score: $score, resetDrawField: resetDrawField, nextHanzi: nextHanzi)
                        })
                    }

            }
        }
   
    }
    
    func resetDrawField() -> Void {
        bottomSheetPosition = .hidden
        currentDrawing = Stroke()
        drawings = [Stroke]()
        score = 0
    }
    

    func nextHanzi() -> Void {
        
        sessionScores.append(SessionScore( text:currentHanzi, score: score))
        if(sessionInfo.getDeckIndex() < deck.numberOfEntries - 1){
            
            ifAppIsNotAdFree(action: {
                if ((sessionInfo.getHanziCounter() + 1)  % Constants.adFrequency == 0) {
                    adsViewModel.showInterstitial.toggle()
                }
            })
            
            resetDrawField()
            sessionInfo.nextHanzi()
            currentHanzi = deck.deckEntries[sessionInfo.getDeckIndex()].text
            quizOpacity = 1.0
            Task {
                hanziImageUrl =  await Api().getImageUrlForHanzi(hanzi:currentHanzi)
                ??  hanziImageUrl
                let hanziInfo = await Api().getHanziInfo(hanzi: currentHanzi)
                currentHanziPinyin = hanziInfo?.pinyin ?? ""
                currentHanziDefinition = hanziInfo?.definition ?? ""
                
            }
        }else{
            let newHistory = History(sessionScores: sessionScores)
            deck.history.insert(newHistory, at: 0)
            ifAppIsNotAdFree(action: {
                adsViewModel.showInterstitial.toggle()
            })
            
            resetDrawField()
            dismiss()
        }
        
    }
    
    func ifAppIsNotAdFree(action: @escaping () -> Void) {
        Purchases.shared.getCustomerInfo { (purchaserInfo, error) in
            if error == nil {
                if purchaserInfo != nil {
                    let hasUserAppFreeEntitlement = purchaserInfo?.entitlements.all.keys.contains("Ad Free")
                    if hasUserAppFreeEntitlement != nil  && hasUserAppFreeEntitlement! {
                        return
                    }
                }
            }
            action()
        }
    }
}

struct PracticeView_Previews: PreviewProvider {
    @State static private var decks : [Deck] = Deck.sampleData
    static private var answers = [(String, Bool)]()
    static var previews: some View {
        PracticeView(deck:  $decks[0])
    }
}
