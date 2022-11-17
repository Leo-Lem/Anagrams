//
//  UserManager.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 15.01.22.
//

import Foundation
import CloudKit
import Combine

//MARK: manages authentication and such
class UserManager {
    var user = User.guest
    
    //TODO: load and save credentials from/to the userdefaults
    //TODO: manage validation
    //TODO: implement registration
    
    static let repo = UserRepository()
}

extension UserManager {
    func validateCredentials(_ credentials: User.Credentials) -> AnyPublisher<ValidationStatus, Never> {
        return Future<ValidationStatus, Never>() { promise in
            Task {
                let status = await Self.repo.validateCredentials((credentials.name, credentials.pin))
                promise(.success(status))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func login(_ credentials: User.Credentials) throws {
        Task {
            let status = await Self.repo.validateCredentials((credentials.name, credentials.pin))
            guard case .validated = status else { return }
            
            let record = try await Self.repo.fetchUser(credentials.name)!
            
            self.user = getUser(from: record)
        }
    }
}

//MARK: conversion to/from cloudkit objects
extension UserManager {
    func getCKRecord() -> CKRecord {
        Self.getCKRecord(from: self.user)
    }
    
    static func getCKRecord(from user: User) -> CKRecord {
        let record = CKRecord(recordType: "User")
        
        record.setValuesForKeys([
            "id": user.id.uuidString,
            "joinedOn": user.joinedOn,
            "name": user.credentials?.name ?? "",
            "pin": user.credentials?.pin ?? "",
            "language": user.preferences.language.rawValue,
            "timer": user.preferences.timer ? 1 : 0,
            "timelimit": user.preferences.timelimit,
            "autosave": user.preferences.autosave ? 1 : 0
        ])
        
        return record
    }
    
    func getUser(from record: CKRecord) -> User {
        let id = UUID(uuidString: record.value(forKey: "id") as! String)!,
            joinedOn = record.value(forKey: "joinedOn") as! Date
        
        let name = record.value(forKey: "name") as! String
        let pin = record.value(forKey: "pin") as! String
        let credentials = User.Credentials(name: name, pin: pin.isEmpty ? nil : pin)
        
        let language = Language(rawValue: record.value(forKey: "language") as! String)!
        let timer = Int(record.value(forKey: "timer") as! Int64) == 1 ? true : false
        let timelimit = Int(record.value(forKey: "timelimit") as! Int64)
        let autosave = Int(record.value(forKey: "autosave") as! Int64) == 1 ? true : false
        let preferences = User.Preferences(language: language, timer: timer, timelimit: timelimit, autosave: autosave)
        
        let user = User(id: id, joinedOn: joinedOn, credentials: credentials, preferences: preferences)
        
        return user
    }
}
