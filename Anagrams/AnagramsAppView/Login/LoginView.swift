//
//  LoginView.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Text("app-title")
                .font(.title)
                .padding()
            
            //EnterDetailsView(username: $viewmodel.name, pin: $viewmodel.pin, field: viewmodel.loginFieldValue)
            
            //if viewmodel.alert != nil { CustomAlertView(alert: viewmodel.alert!) }
            
            Divider()
            
            //LoginButtonsView(button: viewmodel.loginButtonValue, cancel: { viewmodel.cancel() })
                .frame(maxHeight: 40)
        }
        .background(.background)
        .cornerRadius(20)
        .shadow(color: .primary, radius: 5)
        .padding()
    }
    
    @StateObject var viewmodel: LoginViewModel
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewmodel: LoginViewModel())
    }
}
