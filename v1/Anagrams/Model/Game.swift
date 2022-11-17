//
//  ContentView-ViewModel-Game.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
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
        let language: Language, rootWord: RootWord, timelimit: Int
        
        static let `default` = Settings(language: .english,
                                        rootWord: RootWord("universal", language: .english),
                                        timelimit: 300)
    }
}

extension Game {
    init(rootWord: RootWord, preferences: User.Preferences) {
        self.id = UUID()
        self.timestamp = Date()
        
        self.timer = preferences.timer
        self.settings = Settings(language: preferences.language,
                                 rootWord: rootWord,
                                 timelimit: preferences.timelimit)
    }
}
