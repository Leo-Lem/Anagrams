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
    
    let field: LoginView.ViewModel.LoginFieldValue
    
    var body: some View {
        VStack {
            TextField("username-label", text: $username)
                .onSubmit {
                    field.action()
                    self.pinFocus = true
                }
                .focused($nameFocus)
                .task { nameFocus = true }
        
            SecureField(field.type == .register ? "optional-password-label" : "password-label", text: $pin)
                .onSubmit { field.action() }
                .focused($pinFocus)
        }
        .disableAutocorrection(true)
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal)
    }
    
    @FocusState private var nameFocus: Bool
    @FocusState private var pinFocus: Bool
}

//MARK: - Previews
struct EnterDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EnterDetailsView(username: .constant("Leo"), pin: .constant(""), field: LoginView.ViewModel.LoginFieldValue(.guest))
    }
}
