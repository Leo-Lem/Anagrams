//
//  Game.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 15.01.22.
//

import Foundation

struct Game: Codable {
    let id: UUID, timestamp: Date
    //let mode: Mode TODO: Implement different game modes
    let settings: Settings
    
    var newWord: NewWord? = nil, foundWords: [FoundWord] = [], timer: Bool
    var time: Int = 0
    
    var score: Int { foundWords.reduce(0) { $0 + $1.points } }
}

extension Game {
    struct Settings: Codable {
        let word: String, language: Language, timelimit: Int
        
        var rootWord: RootWord {
            RootWord(word, language: language)
        }
    }
}

extension Game {
    init(rootWord: RootWord, preferences: User.Preferences) {
        self.id = UUID()
        self.timestamp = Date()
        
        self.timer = preferences.timer
        self.settings = Settings(rootWord: rootWord, timelimit: preferences.timelimit)
    }
    
    init(word: String, preferences: User.Preferences) {
        self.id = UUID()
        self.timestamp = Date()
        
        self.timer = preferences.timer
        self.settings = Settings(word: word, language: preferences.language, timelimit: preferences.timelimit)
    }
}

extension Game.Settings {
    init(rootWord: RootWord, timelimit: Int) {
        self.word = rootWord.word
        self.language = rootWord.language
        self.timelimit = timelimit
    }
    
    static let `default` = Self(word: "universal", language: .english, timelimit: 300)
}
