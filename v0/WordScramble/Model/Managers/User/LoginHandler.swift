//
//  Account.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 08.01.22.
//

import Foundation
import UIKit

class LoginHandler {
    var userBase: [User] = [User]()
    var user: User = User.guest {
        didSet {
            guard status == .validated else {
                return (self.status = (user.name == nil ? .guest : .notValidated))
            }
        }
    }
    
    enum Status { case validated, notValidated, guest }
    var status: Status = .guest
    
    var pinRequired: Bool? {
        guard let user = fetchUser() else { return nil }
        return user.pin != nil
    }
}

//MARK: account methods
extension LoginHandler {
    func login() throws {
        try validateName()
        if pinRequired! { throw LoginAlert(.pinRequired) }
    }
    
    func loginWithPIN() throws {
        try validateName()
        try validatePIN()
    }
    
    func register() throws {
        try validateNewName()
    }
    
    func logout() {
        user = User.guest
    }
}

//MARK: user validation
extension LoginHandler {
    private func validateName() throws {
        guard fetchUser() != nil else { throw LoginAlert(.username) }
    }
    
    private func validatePIN() throws {
        if pinRequired ?? true {
            guard fetchUser()?.pin == user.pin else { throw LoginAlert(.pin) }
        }
    }
    
    private func validateNewName() throws {
        guard fetchUser() == nil else { throw LoginAlert(.registerUsername)}
    }
    
    private func fetchUser() -> User? {
        guard let name = user.name else { return nil }
        return self.userBase.first { $0.name == name }
    }
}
