//
//  RootwordView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 29.12.21.
//

import SwiftUI
import MyCustomUI

extension SingleView.GameView {
    struct RootWordView: View {
        let rootWord: String
        @Binding var editing: Bool
        let newGame: (String) -> Void
        
        var body: some View {
            HStack {
                //SymbolButton("chevron.left", last).disabled(editing, on: .primary) TODO: implement in-memory rootword saving
                
                Group {
                    Text(rootWord)
                        .hidden(editing)
                        .onLongPressGesture {
                            editing = true
                            textFieldFocus = true
                        }
                        .overlay {
                            if editing {
                                TextField(rootWord, text: $newRootWord).focused($textFieldFocus)
                                    .onSubmit {
                                        newGame(newRootWord)
                                        newRootWord = ""
                                        editing = false
                                    }
                            }
                        }
                }
                .font(.largeTitle)
                
                
                //SymbolButton("chevron.right", next).disabled(editing, on: .primary) TODO: implement in-memory rootword saving
            }
        }
        
        @State private var newRootWord = ""
        @FocusState var textFieldFocus: Bool
    }
}
