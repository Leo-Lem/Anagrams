//
//  SettingsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import SwiftUI
import MyCustomUI
import MyOthers

struct SettingsView: View {
    var body: some View {
        VStack {
            SymbolButton("chevron.down", { dismiss() }).padding()
            
            Text("preferences-title").font(.largeTitle).bold()
            
            Divider()
            
            Form {
                Section {
                    Picker("", selection: $viewmodel.language) {
                        ForEach(Language.allCases, id: \.self) { Text($0.rawValue) }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Text(localizeWithUnit(viewmodel.minuteLimit, label: .minutes))
                        Spacer()
                        Stepper("", value: $viewmodel.minuteLimit, in: 1...60).labelsHidden()
                    }
                } header: {
                    Text("game-preference")
                } footer: {
                    Button("apply-and-new-game-label") {
                        viewmodel.newGame()
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                /*Section(String(localized: "autosave-preference")) {
                    //TODO: add autosaving preference and functionality
                }*/
            }
        }
    }
    
    @StateObject private var viewmodel = ViewModel()
    @Environment(\.dismiss) private var dismiss
}

    
//MARK: - Previews
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
