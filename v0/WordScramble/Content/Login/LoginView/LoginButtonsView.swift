//
//  LoginButtonsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 05.01.22.
//

import SwiftUI
import MyCustomUI

struct LoginButtonsView: View {
    let showingRegister: Bool, registerDisabled: Bool, loginDisabled: Bool
    let register: () -> Void, login: () -> Void, cancel: () -> Void
    
    var body: some View {
        HStack {
            Button(action: cancel) {
                Image(systemName: "chevron.left")
                Text("cancel-label")
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            if showingRegister {
                Button("register-label", action: register)
                    .frame(maxWidth: .infinity)
                    .disabled(registerDisabled, on: .primary)
                
                Divider()
            }
            
            Button(action: login) {
                Text("login-label")
                Image(systemName: "chevron.right")
            }
            .frame(maxWidth: .infinity)
            .disabled(loginDisabled, on: .primary)
        }
        .frame(maxHeight: 50)
    }
}

//MARK: - Previews
struct LoginButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        LoginButtonsView(showingRegister: true, registerDisabled: false, loginDisabled: false,
                         register: {}, login: {}, cancel: {})
    }
}
