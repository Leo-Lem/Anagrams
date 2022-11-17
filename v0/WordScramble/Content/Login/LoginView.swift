//
//  LoginView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 01.01.22.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Leo's Anagrams")
                .font(.title)
                .padding()
            
            EnterDetailsView(username: $viewmodel.name,
                             pin: $viewmodel.pin,
                             showingPIN: viewmodel.showingPIN,
                             showingRegister: viewmodel.showingRegister) {
                if !viewmodel.loginDisabled { viewmodel.login() }
            }
            
            if viewmodel.alert != nil { CustomAlertView(alert: viewmodel.alert!) }
            
            Divider()
            
            LoginButtonsView(showingRegister: viewmodel.showingRegister,
                             registerDisabled: viewmodel.registerDisabled,
                             loginDisabled: viewmodel.loginDisabled,
                             register: { viewmodel.register() },
                             login: { viewmodel.login() },
                             cancel: { viewmodel.cancel() })
        }
        .frame(maxWidth: .infinity)
        .background(.background)
        .cornerRadius(20)
        .shadow(color: .primary, radius: 10)
        .padding()
    }
    
    @StateObject private var viewmodel = ViewModel()
}

//MARK: - Previews
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
