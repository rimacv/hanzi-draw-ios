//
//  ResultProgressBarStyle.swift
//  hanzidraw
//
//  Created by Rimac Valdez on 21.01.22.
//

import SwiftUI

struct ResultProgressBarStyle: ProgressViewStyle {
    var theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 10.0)
//                .fill(.ultraThickMaterial)
//                .frame(height: 35.0)
            if #available(iOS 15.0, *) {
                ProgressView(configuration)
                    .tint(.green)
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                    .cornerRadius(8)
                    .padding(.horizontal)
            } else {
                ProgressView(configuration)
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                    .padding(.horizontal)
            }
        }
    }
}

struct ResultProgressBarStyle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 0.4)
            .progressViewStyle(ResultProgressBarStyle(theme: .buttercup))
            .previewLayout(.sizeThatFits)
    }
}
