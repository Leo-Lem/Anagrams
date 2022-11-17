//
//  SingleGame.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 16.01.22.
//

import Foundation

extension SingleViewModel {
    struct Game: GameMode {
        let id: UUID, timestamp: Date
        let settings: Settings
        
        var foundWords: [FoundWord] = []
        var timer: Bool = true, time: Int = 0
        
        var score: Int { foundWords.reduce(0) { $0 + $1.points } }
        var secondlimit: Int { settings.timelimit * 60 }
        var timeLeft: Int { secondlimit - time }
        var timeUp: Bool { time >= secondlimit }
        
        init(word: String, language: Language, timelimit: Int) throws {
            self.id = UUID()
            self.timestamp = Date()
            
            self.settings = try SingleViewModel.Settings(word: word, language: language, timelimit: timelimit)
        }
    }
    
    struct Settings: Codable {
        let word: String, language: Language, timelimit: Int
        
        var rootWord: RootWord { RootWord(word, language: language) }
        
        static let `default` = try! Settings(word: "universal", language: .english, timelimit: 5)
        
        init(word: String, language: Language, timelimit: Int) throws {
            self.word = word
            self.language = language
            self.timelimit = timelimit
            
            try self.rootWord.checkValidity()
        }
    }
}

//MARK: - convenience initializers
extension SingleViewModel.Game {
    init(settings: SingleViewModel.Settings) {
        self.id = UUID()
        self.timestamp = Date()
        
        self.settings = settings
    }
}

extension SingleViewModel.Settings {
    init(language: Language, timelimit: Int) {
        self.word = RootWordRepository.randomWord(in: language.rawValue)
        self.language = language
        self.timelimit = timelimit
    }
    
    init(rootWord: RootWord, timelimit: Int) throws {
        self.word = rootWord.word
        self.language = rootWord.language
        self.timelimit = timelimit
        
        try self.rootWord.checkValidity()
    }
}
