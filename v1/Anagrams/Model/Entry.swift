//
//  Entry.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 30.12.21.
//

import Foundation

struct Entry: Codable {
    let id: UUID, timestamp: Date
    
    let settings: Game.Settings
    var foundWords: [FoundWord] = [], time: Int = 0
    
    var score: Int { foundWords.reduce(0) { $0 + $1.points } }
}

extension Entry {
    init(user: User, game: Game) {
        self.id = UUID()
        self.timestamp = Date()
        
        self.settings = game.settings
        self.foundWords = game.foundWords
        self.time = game.timer ? game.time : -1
    }
}
