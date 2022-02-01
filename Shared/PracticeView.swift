//
//  PracticeView.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 08.01.22.
//

import SwiftUI
import CachedAsyncImage
import BottomSheet

struct HanziImage : View{
    @Binding var hanziImageUrl : String
    
    var body: some View {
        CachedAsyncImage(url: URL(string: hanziImageUrl)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: Constants.drawPadSize, height: Constants.drawPadSize)
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
    @State private var lineWidth: CGFloat = 3.0
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
    @Binding var deck : Deck

    
    @EnvironmentObject var adsViewModel: AdsViewModel
    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        
        if(!isLoaded){
            
            ProgressView()
                .onAppear{
                    correctAnswerIndex = Int.random(in: 0..<4)
                }
                .task {
                    currentHanzi = deck.deckEntries[sessionInfo.getDeckIndex()].text
                    
                    
                    hanziImageUrl =  await Api().getImageUrlForHanzi(hanzi:currentHanzi) ??  hanziImageUrl
                    let hanziInfo = await Api().getHanziInfo(hanzi: currentHanzi)
                    currentHanziPinyin = hanziInfo?.pinyin ?? ""
                    currentHanziDefinition = hanziInfo?.definition ?? ""
                    
                    var hanziList = ""
                    for entry in deck.deckEntries{
                        hanziList += entry.text
                    }
                    pinyinList = await Api().getPinyinList(hanziList: hanziList)
                    print(hanziImageUrl)
                    isLoaded.toggle()
                }
        }else{
            VStack{
                HanziImage(hanziImageUrl: $hanziImageUrl)
                
                ZStack{
                    DrawingPadView(currentDrawing: $currentDrawing,
                                   drawings: $drawings,
                                   color: $color,
                                   lineWidth: $lineWidth,
                                   inverseDrawPadOpacity: $quizOpacity, bottomSheetPosition: $bottomSheetPosition, score: $score, currentHanzi: $currentHanzi )
                    
                    
                    QuizView(quizOpacity: $quizOpacity, currentHanziPinyin: $currentHanziPinyin, correctAnswerIndex: $correctAnswerIndex, pinyinList: pinyinList!).padding(.bottom, 20)
                    
                    
                    
                    
                }
                .bottomSheet( bottomSheetPosition: $bottomSheetPosition, options: [.cornerRadius(8),.notResizeable]	,content: {
                    BottomSheetResultView(score: $score, resetDrawField: resetDrawField, nextHanzi: nextHanzi)
                })
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
        
    
        if(sessionInfo.getDeckIndex() < deck.numberOfEntries - 1){
            
            if ((sessionInfo.getDeckIndex() + 1)  % 2 == 0) {
                adsViewModel.showInterstitial.toggle()
            }
            
            deck.deckEntries[sessionInfo.getDeckIndex()].history.insert(DeckEntryHistory(score: score), at: 0)
            
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
            let newHistory = History()
            deck.history.insert(newHistory, at: 0)
            adsViewModel.showInterstitial.toggle()
            resetDrawField()
            dismiss()
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
