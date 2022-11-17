//
//  Game.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.02.22.
//

import Foundation

struct Game: Codable, Identifiable {
    let id: UUID, timestamp: Date
    let config: Configuration
    var new: String? = nil,
        found: [String] = [],
        timer: Bool,
        time: Int = 0
}

extension Game {
    init(word: String, preferences: User.Preferences) {
        self.init(
            id: UUID(),
            timestamp: Date(),
            config: Configuration(word: word, language: preferences.language, timelimit: preferences.timelimit),
            timer: preferences.timer
        )
    }
}

//MARK: - Configuration
extension Game {
    struct Configuration: Codable {
        let word: String, language: Language, timelimit: Int
        
        static let `default` = Self(word: "universal", language: .english, timelimit: 300)
    }
}

//MARK: - Supported
extension Game {
    enum Language: String, CaseIterable, Codable {
        case english = "en",
             german = "de",
             spanish = "es",
             french = "fr"
    }
}
