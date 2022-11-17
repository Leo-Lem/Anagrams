//
//  NewWordView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 05.01.22.
//

import SwiftUI

extension SingleplayerView {
    struct NewWordView: View {
        @Binding var newWord: String
        let addWord: () -> Void
        
        var body: some View {
            TextField("enter-word-label", text: $newWord) {
                addWord()
                self.focused = true
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            .focused($focused)
            .task { focused = true }
        }
        
        @FocusState private var focused: Bool
    }
}
//MARK: - Previews
struct NewWordView_Previews: PreviewProvider {
    static var previews: some View {
        SingleplayerView.NewWordView(newWord: .constant(""), addWord: {})
    }
}
