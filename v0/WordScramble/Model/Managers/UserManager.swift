//
//  LoginModel.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 05.01.22.
//

import Foundation
import CoreData
import MyOthers

class UserManager: Manager {
    private(set) var userBase = [User]()
    private(set) var loginHandler = LoginHandler()
    private(set) var alert: LoginAlert? = nil
    
    var loggingIn: Bool = true
    
    var user: User {
        get { loginHandler.status == .validated ? loginHandler.user : User.guest }
        set { loginHandler.user = newValue } }
    
    var isGuest: Bool { user.name == nil }
    
    override init(model: Model) {
        super.init(model: model)
        
        Task {
            do {
                self.userBase = try await fetchUsers()
                guard !userBase.isEmpty else { throw LoginAlert(.connection) }
            } catch { addAlert(LoginAlert(.connection)) }
            
            tryLoggingSavedUserIn()
        }
    }
}

//MARK: account manager
extension UserManager {
    var pinRequired: Bool? { loginHandler.pinRequired }
    
    func logUserIn() {
        do {
            setAccount()
            
            try loginHandler.login()
            
            try login()
        } catch let alert as LoginAlert where alert.kind == .pinRequired {
            return
        } catch let alert as LoginAlert {
            addAlert(alert)
        } catch {addAlert(LoginAlert(.unknown)) }
    }
    
    func logUserInWithPIN() {
        do {
            setAccount()
            
            try loginHandler.loginWithPIN()
            
            try login()
        } catch let alert as LoginAlert {
            addAlert(alert)
        } catch { addAlert(LoginAlert(.unknown)) }
    }
    
    func registerUser() {
        do {
            setAccount()
            
            try loginHandler.register()
            try addRegisteredUser()
            
            try login()
        } catch let alert as LoginAlert {
            addAlert(alert)
        } catch { addAlert(LoginAlert(.unknown)) }
    }
    
    func logUserOut() {
        self.user = User(name: user.name)
        self.loggingIn = true
    }
    
    func cancel() {
        tryLoggingSavedUserIn()
        loggingIn = false
    }
    
    private func tryLoggingSavedUserIn() {
        fetchCredentials()
        logUserIn()
        if loginHandler.status != .validated { logUserInWithPIN() }
        if loginHandler.status != .validated {
            self.user = User.guest
            self.alert = nil
        }
    }
    
    private func login() throws {
        loginHandler.status = .validated
        
        guard let user = userBase.first(where: { $0.name == user.name }) else { throw LoginAlert(.connection) }
        self.user = user
        
        saveCredentials()
        self.loggingIn = false
        
        model.gameManager.startSavedGame()
        updateViews()
    }
    
    private func setAccount() {
        self.loginHandler.userBase = userBase
    }
}
//MARK: changing user preferences methods
extension UserManager {
    var defaults: Defaults {
        get { user.defaults }
        set { user.defaults = newValue }
    }
    
    func setPreference(language: Language? = nil, timelimit: Int? = nil,
                       timer: Bool? = nil, autosave: Bool? = nil) {
        defaults.language ?= language
        defaults.timelimit ?= timelimit
        defaults.timer ?= timer
        defaults.autosave ?= autosave
        
        try? persistence.saveContext()
        updateViews()
    }
}

//MARK: alert methods
extension UserManager {
    //alert
    private func addAlert(_ alert: LoginAlert) {
        self.alert = alert
        updateViews()
    }
    func clearAlert() {
        self.alert = nil
    }
}

//MARK: persistence handling
extension UserManager {
    private func addRegisteredUser() throws {
        guard loginHandler.status == .validated else { return }
        
        do {
            viewContext.insert(user.cd)
            try persistence.saveContext()
            userBase.append(user)
        } catch { throw LoginAlert(.connection) }
    }
    
    //fetching the users from the database
    func fetchUsers() async throws -> [User] {
        let task = Task { () -> [User] in
            let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
            
            return try await viewContext.perform { () -> [User] in
                let result = try fetchRequest.execute()
                return result.map { User($0) }
            }
        }
        
        let result = await task.result
        
        do {
            let users = try result.get()
            return users
        } catch {
            throw LoginAlert(.connection)
        }
    }
    
    private func fetchCredentials() {
        let name = UserDefaults.standard.object(forKey: "name") as? String
        let pin = UserDefaults.standard.object(forKey: "pin") as? String
        self.user = User(name: name, pin: pin)
    }
    
    private func saveCredentials() {
        UserDefaults.standard.set(user.name, forKey: "name")
        UserDefaults.standard.set(user.pin, forKey: "pin")
    }
}
