//
//  RootwordView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 29.12.21.
//

import SwiftUI
import MyCustomUI

extension SingleplayerView {
    struct RootView: View {
        @Binding var rootword: String
        @Binding var editing: Bool
        
        let last: () -> Void, next: () -> Void, new: () -> Void
        
        var body: some View {
            HStack {
                SymbolButton("chevron.left", last)
                    .disabled(editing, on: .primary)
                
                Text(rootword)
                    .hidden(editing)
                    .font(.largeTitle)
                    .overlay {
                        if editing {
                            TextField("", text: $rootword)
                                .font(.largeTitle)
                                .onSubmit {
                                    new()
                                    self.editing = false
                                }
                                .focused($focused)
                        }
                    }
                    .onLongPressGesture {
                        self.editing = true
                        self.focused = true
                    }
                
                SymbolButton("chevron.right", next)
                    .disabled(editing, on: .primary)
            }
        }
        
        @FocusState private var focused: Bool
    }
}

//MARK: - Previews
struct RootwordView_Previews: PreviewProvider {
    static var previews: some View {
        SingleplayerView.RootView(rootword: .constant("hello"), editing: .constant(false), last: {}, next: {}, new: {})
    }
}
