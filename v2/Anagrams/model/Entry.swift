//
//  Entry.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.02.22.
//

import Foundation

struct Entry: Codable {
    let id: UUID, timestamp: Date
    let config: Game.Configuration
    var found: [String], time: Int?
    
    var score: Int { found.reduce(0, { $0 + $1.count }) }
}

//MARK: - Initializer
extension Entry {
    init(game: Game) {
        self.init(
            id: UUID(),
            timestamp: Date(),
            config: game.config,
            found: game.found,
            time: game.timer ? game.time : nil
        )
    }
}
