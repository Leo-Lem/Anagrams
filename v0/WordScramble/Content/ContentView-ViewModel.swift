//
//  ContentView-ViewModel.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import Combine
import SwiftUI

extension ContentView {
    @MainActor class ViewModel: SuperViewModel {
        @Published var showingSettings: Bool = false
        
        var userManager: UserManager { model.userManager }
        var showingLogin: Bool { userManager.loggingIn }
        var isGuest: Bool { userManager.isGuest }
        var username: String? { userManager.user.name }
        
        func logOut() { userManager.logUserOut() }
    }
}
