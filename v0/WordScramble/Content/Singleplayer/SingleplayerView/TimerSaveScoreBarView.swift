//
//  TimerView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI
import MyCustomUI

extension SingleplayerView {
    struct TimerSaveScoreBarView: View {
        @Binding var time: Int
        @Binding var enabled: Bool
        let limit: Int, score: Int
        
        let save: () -> Void
        
        private var remaining: Int { limit - time }
        private var timeUp: Bool { time >= limit }
        private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        var body: some View {
            HStack {
                NumberOverUnitView(number: remaining, unit: .seconds)
                    .foregroundColor(timeUp ? .red : .primary)
                    .onTapGesture { enabled = false }
                    .hidden(!enabled)
                    .overlay {
                        SymbolButton("timer", true: $enabled).font(.title2)
                            .disabled(timeUp, on: .primary)
                            .hidden(enabled)
                    }
                    .onReceive(timer) { _ in
                        time += (timeUp ? 0 : Int(timer.upstream.interval))
                        if timeUp { time = limit }
                    }
                
                Spacer()
                
                SymbolButton("square.and.arrow.up", save)
                
                Spacer()
                
                NumberOverUnitView(number: score, unit: .points)
            }
            .padding(10)
            .background(.bar)
        }
    }
}

//MARK: - Previews
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        SingleplayerView.TimerSaveScoreBarView(time: .constant(10), enabled: .constant(true), limit: 100, score: 38) {}
    }
}
