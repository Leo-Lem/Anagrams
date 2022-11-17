//
//  SingleSetupView.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 16.01.22.
//

import SwiftUI
import MyCustomUI

extension SingleView {
    struct SetupView: View {
        let start: (Settings) -> Void, `continue`: () -> Void
        
        var body: some View {
            VStack {
                Form {
                    Picker("", selection: $language) {
                        ForEach(Language.allCases, id: \.self) { Text($0.rawValue) }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Text(localizeWithUnit(timelimit, label: .minutes))
                        Spacer()
                        Stepper("", value: $timelimit, in: 1...60).labelsHidden()
                    }
                    
                    /*Section(String(localized: "autosave-preference")) {
                        //TODO: add autosaving preference and functionality
                    }*/
                }
                
                HStack {
                    Button("start-game-label", action: { startGame(settings) })
                    Button("continue-game-label", action: continueGame)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        
        //MARK: - local properties
        @State private var language: Language = .english
        @State private var timelimit = 5
        //@State private var autosave = false
        
        var settings: Settings { Settings(language: language, timelimit: timelimit) }
    }
}
