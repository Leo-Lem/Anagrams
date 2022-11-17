//
//  User.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 15.01.22.
//

import Foundation

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
