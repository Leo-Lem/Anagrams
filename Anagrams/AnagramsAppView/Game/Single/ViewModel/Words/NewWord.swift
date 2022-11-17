//
//  New.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 03.01.22.
//

import Foundation

struct NewWord: Word {
    let word: String
    let rootWord: RootWord, foundWords: [FoundWord]
    var language: Language { rootWord.language }

    init(_ word: String, rootWord: RootWord, foundWords: [FoundWord]) throws {
        self.word = word
        self.rootWord = rootWord
        self.foundWords = foundWords
        
        try self.checkValidity()
    }
    
    init(_ word: String, game: SingleViewModel.Game) throws {
        self.word = word
        self.rootWord = game.settings.rootWord
        self.foundWords = game.foundWords
        
        try self.checkValidity()
    }
}

//MARK: determine if new word follows game rules
extension NewWord {
    private var localized: String { word.capitalized(with: Locale(identifier: language.rawValue)) }
    
    private var isNotRoot: Bool { self.isNotEqual(to: rootWord) }
    private var isLongEnough: Bool { self.count >= 4 }
    private var isPossible: Bool { rootWord.checkIfContained(self) }
    private var isNew: Bool { !(foundWords.contains { $0.isEqual(to: self) }) }
    private var isReal: Bool { self.checkIfReal(language: language.rawValue) }
    
    var isValid: Bool { isNotRoot && isLongEnough && isPossible && isNew && isReal }
    
    func checkValidity() throws {
        guard isNotRoot else { throw NewAlert(.isRoot, new: self) }
        guard isLongEnough else { throw NewAlert(.tooShort, new: self) }
        guard isPossible else { throw NewAlert(.notPossible, new: self) }
        guard isNew else { throw NewAlert(.notNew, new: self) }
        guard isReal else { throw NewAlert(.notReal, new: self) }
    }
}
