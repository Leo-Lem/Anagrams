//
//  SingleplayerView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 02.01.22.
//

import SwiftUI
import MyCustomUI

struct SingleplayerView: View {
    var body: some View {
        VStack {
            RootView(rootword: $viewmodel.rootword,
                     editing: $viewmodel.editingRoot,
                     last: { viewmodel.setLastRoot() },
                     next: { viewmodel.setNextRoot() },
                     new: { viewmodel.commitRoot() })
            
            Group {
                NewWordView(newWord: $viewmodel.newWord, addWord: { viewmodel.addWord() })
                    .disabled(viewmodel.timerEnabledAndTimeUp)
                
                Group {
                    if viewmodel.timeAlert != nil { CustomAlertView(alert: viewmodel.timeAlert!).zIndex(2) }
                    if viewmodel.rootAlert != nil { CustomAlertView(alert: viewmodel.rootAlert!).zIndex(2) }
                    
                    NewAlertsView(alerts: viewmodel.newAlerts).zIndex(1)
                }
                
                FoundWordsView(foundWords: viewmodel.foundWords)
            }
            .disabled(viewmodel.editingRoot)
        }
        .overlay(alignment: .bottom) {
            TimerSaveScoreBarView(time: $viewmodel.time,
                                  enabled: $viewmodel.timer,
                                  limit: viewmodel.timelimit,
                                  score: viewmodel.score,
                                  save: { viewmodel.save() })
                .disabled(viewmodel.editingRoot)
        }
        .animation(viewmodel.newAlerts)
        .animation(viewmodel.rootAlert)
        .animation(viewmodel.timeAlert)
        .animation(viewmodel.timer)
    }
    
    @StateObject var viewmodel = ViewModel()
}

//MARK: - Previews
struct SingleplayerView_Previews: PreviewProvider {
    static var previews: some View {
        SingleplayerView()
    }
}
