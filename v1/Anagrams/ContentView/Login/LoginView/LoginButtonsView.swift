//
//  LoginButtonsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 05.01.22.
//

import SwiftUI
import MyCustomUI

struct LoginButtonsView: View {
    let button: LoginView.ViewModel.LoginButtonValue
    let cancel: () -> Void
    
    var body: some View {
        HStack {
            Button(action: cancel) {
                Image(systemName: "chevron.left")
                Text("cancel-label")
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            Button(action: button.action) {
                Text(LocalizedStringKey(button.label))
                Image(systemName: "chevron.right")
            }
            .disabled(button.type == .disabledLogin, on: .primary)
            .frame(maxWidth: .infinity)
        }
    }
}

//MARK: - Previews
struct LoginButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        LoginButtonsView(button: LoginView.ViewModel.LoginButtonValue(.register), cancel: {})
    }
}
