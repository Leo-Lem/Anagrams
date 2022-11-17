//
//  NewWordView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 05.01.22.
//

import SwiftUI

extension SingleView.GameView {
    struct NewWordView: View {
        let addWord: (String) -> Void
        
        var body: some View {
            TextField("enter-word-label", text: $newWord).focused($textFieldFocus)
                .textFieldStyle(.roundedBorder)
                .padding()
                .task { textFieldFocus = true }
                .onSubmit {
                    addWord(newWord)
                    newWord = ""
                    self.textFieldFocus = true
                }
        }
        
        @State private var newWord = ""
        @FocusState private var textFieldFocus: Bool
    }
}
