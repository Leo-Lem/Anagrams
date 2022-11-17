//
//  SettingsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import SwiftUI
import MyCustomUI

struct SettingsView: View {
    @Binding var language: Model.SupportedLanguage
    @Binding var timelimit: Int
    
    let apply: () -> Void
    
    var body: some View {
        VStack {
            SymbolButton("chevron.down") { dismiss() }
                .padding()
            
            Text("settings-label").font(.largeTitle).bold()
            
            Divider()
            
            Form {
                Section {
                    Picker("", selection: $language) {
                        ForEach(Model.SupportedLanguage.allCases, id: \.self) { language in
                            Text(language.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("select-language-label")
                } footer: {
                    
                }
                
                Section {
                    HStack {
                        Text(localizeIntWithLabel(timelimit, label: .minutes))
                        Spacer()
                        Stepper("", value: $timelimit, in: 1...60).labelsHidden()
                    }
                } header: {
                    Text("select-timelimit-label")
                }
            }
            
            Divider()
            
            Button("apply-and-new-game-label", action: apply)
                .buttonStyle(.borderedProminent)
                .padding()
        }
        .overlay(alignment: .topTrailing) {
            
        }
    }
    
    @Environment(\.dismiss) var dismiss
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(language: .constant(.german), timelimit: .constant(10)) {}
    }
}
