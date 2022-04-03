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
            if(pinyin != "" && definition != ""){
                Text(pinyin)
                Text(definition)
            } else{
                Text(String(localized: "No info available"))
            }
        }
        
       
    }
}

struct Info{
    private var randomizeHanzis = false
    private var deckIndex = 0
    private var hanziCounter = 0
    private var resetDrawfieldCounter = 0
    
    mutating func nextHanzi(){
        hanziCounter += 1
        deckIndex += 1
    }
    
    mutating func IncreaseResetCounter(){
        resetDrawfieldCounter += 1
    }
    
    func getDeckIndex() -> Int{
        return deckIndex
    }
    
    func getHanziCounter() -> Int{
        return hanziCounter
    }
    
    func getResetDrawfieldCounter() -> Int{
        return resetDrawfieldCounter
    }
}

struct PracticeView: View {
    @State private var currentStroke: Stroke = Stroke()
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
    @State private var showHelp = false
    @State private var errorWrapper: ErrorWrapper?
    
    @State private var percentage: CGFloat = .zero
    @State private var strokeOpacity = 1.0
    @State private var hintStrokes: [Stroke] = [Stroke]()
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
                        
                        let data = await Api().getStrokeHints(hanzi: currentHanzi)
                        if(data != nil){
                            hintStrokes = data!
                        }
                        
                        var hanziList = ""
                        for entry in deck.deckEntries{
                            hanziList += entry.text
                        }
                        pinyinList = await Api().getPinyinList(hanziList: hanziList)
                        if(pinyinList != nil){
                            isLoaded.toggle()
                      
                        }else{
                            errorWrapper =  ErrorWrapper(error: nil, guidance: String(localized: "SessionLoadError"))
                        }
                       
                    }
                    .sheet(item: $errorWrapper, onDismiss: {
                    }) { wrapper in
                        ErrorView(errorWrapper: wrapper)
                    }.cornerRadius(8).buttonStyle(QuizButtonStyle(highlightColor: Color.gray))
            }else{
                
                    VStack{
                                                                      
                      FlipView(HanziImage(hanziImageUrl: $hanziImageUrl, currentHanzi: $currentHanzi).padding(.bottom, 10), HanziInfoView(pinyin: $currentHanziPinyin, definition: $currentHanziDefinition), tap: {}, flipped:$flip, disabled: $disabled )
                        

                        ZStack{
                            
                            if(deck.mode == .guided){
                                DrawingPadWithGuidance(currentStroke: $currentStroke,
                                               strokes: $drawings,
                                               color: $color,
                                               lineWidth: $deck.strokeSize,
                                                inverseDrawPadOpacity: $quizOpacity, bottomSheetPosition: $bottomSheetPosition, score: $score, currentHanzi: $currentHanzi, percentage: $percentage, strokeOpacity : $strokeOpacity, hintStrokes: $hintStrokes)
                            }else{
                                DrawingPadView(currentStroke: $currentStroke,
                                               strokes: $drawings,
                                               color: $color,
                                               lineWidth: $deck.strokeSize,
                                                inverseDrawPadOpacity: $quizOpacity, bottomSheetPosition: $bottomSheetPosition, score: $score, currentHanzi: $currentHanzi)
                            }
                            Spacer()
                            QuizView(quizOpacity: $quizOpacity, currentHanziPinyin: $currentHanziPinyin, correctAnswerIndex: $correctAnswerIndex,flip: $flip, pinyinList: pinyinList!).padding(.bottom, 20)

                        }
                        .toolbar {
                
                            ToolbarItem(placement: .principal){
                            
                                ProgressView(value: CGFloat(sessionInfo.getHanziCounter() + 1), total: CGFloat(deck.numberOfEntries))
                                    .progressViewStyle(ResultProgressBarStyle(theme: .sky))
                            }
                            
                        ToolbarItem(placement: .navigationBarTrailing){
                                 Button(action: {
                                     showHelp = true
                                 }) {
                                     Image(systemName: "questionmark.circle.fill")
                                 }
                                .accessibilityLabel(String(localized: "Help"))
                                .alert(isPresented: $showHelp) {
                                    Alert(title: Text(String(localized: "Tooltip")), message: Text(String(localized: "TapInfo")), dismissButton: .default(Text(String(localized: "Got it!"))))
                                }
                                
                            }
                          
                        }
                        .bottomSheet( bottomSheetPosition: $bottomSheetPosition, options: [.cornerRadius(8),.notResizeable,]    ,content: {
                            BottomSheetResultView(score: $score, resetDrawField: resetDrawField, nextHanzi: nextHanzi, bottomSheetPosition: $bottomSheetPosition)
                        })
                    }

            }
        }
   
    }
    
    func resetDrawField() -> Void {
        
        // if session is finished ad will be shown due to logic in nextHanzi()
        if(isSessionOngoing()){
            PurchaseWrapper.ifAppIsNotAdFree(action: {
                if ((sessionInfo.getResetDrawfieldCounter() + 1)  % Constants.adFrequency == 0) {
                    adsViewModel.showInterstitial.toggle()
                }
            })
        }
        sessionInfo.IncreaseResetCounter()
        bottomSheetPosition = .hidden
        currentStroke = Stroke()
        drawings = [Stroke]()
        score = 0
        strokeOpacity = 1
        percentage = 0
        if(flip){
            flip = false
        }
    }
    

    func nextHanzi() -> Void {
        
        sessionScores.append(SessionScore( text:currentHanzi, score: score))
        if(isSessionOngoing()){

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
                let data = await Api().getStrokeHints(hanzi: currentHanzi)
                if(data != nil){
                    hintStrokes = data!
                }
            }
        }else{
            let newHistory = History(sessionScores: sessionScores)
            deck.history.insert(newHistory, at: 0)
            PurchaseWrapper.ifAppIsNotAdFree(action: {
                adsViewModel.showInterstitial.toggle()
            })
            
            resetDrawField()
            dismiss()
        }
        
    }
    
    func isSessionOngoing() -> Bool {
        return sessionInfo.getDeckIndex() < deck.numberOfEntries - 1
    }
}

struct PracticeView_Previews: PreviewProvider {
    @State static private var decks : [Deck] = Deck.sampleData
    static private var answers = [(String, Bool)]()
    static var previews: some View {
        PracticeView(deck:  $decks[0])
    }
}
