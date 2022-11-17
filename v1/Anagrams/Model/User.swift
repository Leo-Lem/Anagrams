//
//  User.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import Foundation
import CloudKit

struct User: Codable {
    let id: UUID, joinedOn: Date
    
    var credentials: Credentials?, preferences: Preferences
    var game: Game? = nil, entries: [Entry] = []
    
    var isGuest: Bool { self.credentials == nil }
    static let guest = User()
}

extension User {
    struct Credentials: Codable {
        var name: String, pin: String?
        
        var noPIN: Bool { self.pin == nil }
        
        static func load() -> Credentials? {
            UserDefaults.standard.getObject(forKey: "name", castTo: Credentials.self)
        }
        
        static func save(_ credentials: Credentials) {
            UserDefaults.standard.setObject(credentials, forKey: "credentials")
        }
    }
    
    struct Preferences: Codable {
        var language: Language, timer: Bool, timelimit: Int, autosave: Bool
        
        static let `default` = Preferences(language: .english, timer: true, timelimit: 300, autosave: true)
    }
}

extension User {
    init(credentials: Credentials? = nil, preferences: Preferences = Preferences.default) {
        self.id = UUID()
        self.joinedOn = Date()
        self.preferences = preferences
        self.credentials = credentials
    }
}

extension User {
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: "User")
        record.setValuesForKeys([
            "id": id.uuidString,
            "joinedOn": joinedOn,
            "name": credentials?.name ?? "",
            "pin": credentials?.pin ?? "",
            "language": preferences.language.rawValue,
            "timer": preferences.timer ? 1 : 0,
            "timelimit": preferences.timelimit,
            "autosave": preferences.autosave ? 1 : 0
        ])
        return record
    }
}
