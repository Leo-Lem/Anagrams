//
//  TimerView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI
import MyCustomUI

extension SingleView.GameView {
    struct TimerSaveScoreBarView: View {
        @Binding var enabled: Bool
        let timeLeft: Int, score: Int, timeUp: Bool
        let save: () -> Void
        
        var body: some View {
            HStack {
                Group {
                    NumberOverUnitLabel(timeLeft, .seconds)
                        .foregroundColor(timeUp ? .red : .primary)
                        .onTapGesture { enabled = false }
                        .hidden(!enabled)
                        .overlay {
                            if !enabled {
                                SymbolButton("timer", true: $enabled)
                                    .font(.title2)
                                    .disabled(timeUp, on: .primary)
                            }
                        }
                }
                
                
                Spacer()
                
                SymbolButton("square.and.arrow.up", save)
                
                Spacer()
                
                NumberOverUnitLabel(score, .points)
            }
            .padding(10)
            .background(.bar)
        }
    }
}
