//
//  User.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.02.22.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID, joinedOn: Date
    var credentials: Credentials?,
        preferences: Preferences
    var game: Game? = nil,
        entries: [Entry] = []
    
    var isGuest: Bool { self.credentials == nil }
    static let guest = User()
}

//MARK: - Credentials
extension User {
    struct Credentials: Codable {
        var name: String, pin: String?
        
        var noPIN: Bool { self.pin == nil }
    }
}

//MARK: - Preferences
extension User {
    struct Preferences: Codable {
        var language: Game.Language,
            timer: Bool,
            timelimit: Int,
            autosave: Bool
        
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
