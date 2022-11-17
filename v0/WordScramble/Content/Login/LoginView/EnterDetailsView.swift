//
//  EnterDetailsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 05.01.22.
//

import SwiftUI

struct EnterDetailsView: View {
    @Binding var username: String
    @Binding var pin: String
    
    let showingPIN: Bool, showingRegister: Bool
    let login: () -> Void
    
    var body: some View {
        VStack {
            TextField("username-label", text: $username)
                .padding(.horizontal)
                .onSubmit { login() }
                .focused($nameFocus)
                .task { nameFocus = true}
        
            if showingPIN {
                SecureField(showingRegister ? "optional-password-label" : "password-label", text: $pin)
                    .padding(.horizontal)
                    .onSubmit { login() }
                    .focused($pinFocus)
                    .task { if showingPIN { pinFocus = true } }
                    .animation(.default, value: showingPIN)
            }
        }
        .disableAutocorrection(true)
        .textFieldStyle(.roundedBorder)
    }
    
    @FocusState private var nameFocus: Bool
    @FocusState private var pinFocus: Bool
}

//MARK: - Previews
struct EnterDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EnterDetailsView(username: .constant(""), pin: .constant(""), showingPIN: true, showingRegister: true) {}
    }
}
