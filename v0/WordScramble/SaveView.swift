//
//  SaveView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 29.12.21.
//

import SwiftUI
import MyCustomUI

struct SaveView: View {
    @Binding var username: String
    
    let saveAndNewGame: () -> Void
    
    var body: some View {
        HStack {
            TextField("enter-name-to-save-label", text: $username)
                .textFieldStyle(.roundedBorder)
                .font(.title2)
                .fixedSize()
                .shadow(color: .secondary, radius: 10)
                .focused($focused)
                .task { focused = true }
            
            SymbolButton("chevron.right.circle", saveAndNewGame)
                .font(.title)
                .foregroundColor(username.isEmpty ? .gray : .primary)
                .disabled(username.isEmpty)
        }
    }
    
    @FocusState private var focused: Bool
}

struct SaveView_Previews: PreviewProvider {
    static var previews: some View {
        SaveView(username: .constant("Leo")) {}
    }
}
