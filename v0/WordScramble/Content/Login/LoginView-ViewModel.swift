//
//  LoginView-ViewController.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 01.01.22.
//

import Combine

extension LoginView {
    @MainActor class ViewModel: SuperViewModel {
        lazy var name: String = user.name ?? "" {
            willSet { objectWillChange.send() }
            didSet {
                if showingRegister { userManager.clearAlert() }
                if pinRequired && showingPIN { changedName = true }
            }
        }
        lazy var pin: String = user.pin ?? "" {
            willSet { objectWillChange.send() }
        }
        
        var alert: LoginAlert? { userManager.alert }
        
        var userManager: UserManager { model.userManager }
        var user: User { userManager.user }
        
        var changedName: Bool = false
        var pinRequired: Bool { userManager.pinRequired ?? false }
        var showingPIN: Bool { (pinRequired && !changedName) || showingRegister }
        var showingRegister: Bool { self.alert?.kind == .username }
        
        var registerDisabled: Bool { self.name.isEmpty }
        var loginDisabled: Bool { self.name.isEmpty || (showingPIN && self.pin.isEmpty) || showingRegister }
        
        func register() {
            userManager.user = User(name: name, pin: pin)
            userManager.registerUser()
            changedName = false
        }
        func login() {
            let shown = showingPIN
            userManager.user = User(name: name, pin: pin)
            shown ? userManager.logUserInWithPIN() : userManager.logUserIn()
            changedName = false
        }
        func cancel() {
            model.userManager.cancel()
            changedName = false
        }
    }
}
