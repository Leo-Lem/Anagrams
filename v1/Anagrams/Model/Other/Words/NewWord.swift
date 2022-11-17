//
//  New.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 03.01.22.
//

import Foundation

struct NewWord: Word {
    let word: String
    let root: RootWord, foundWords: [Found]

    init(_ word: String, game: Game) {
        self.word = word
        self.root = game.settings.rootWord
        self.foundWords = game.foundWords
    }
}

//MARK: property shortcuts
extension NewWord {
    var language: Language { root.language}
    private var languageCode: String { language.rawValue }
    private var localized: String { word.capitalized(with: Locale(identifier: languageCode)) }
}

//MARK: determine if new word follows game rules
extension NewWord {
    private var isNotRoot: Bool { self.isNotEqual(to: root) }
    private var isLongEnough: Bool { self.count >= 4 }
    private var isPossible: Bool { root.checkIfContained(self) }
    private var isNew: Bool { !(foundWords.contains { $0.isEqual(to: self) }) }
    private var isReal: Bool { self.checkIfReal(language: language) }
    
    var isValid: Bool { isNotRoot && isLongEnough && isPossible && isNew && isReal }
    
    func checkValidity() throws {
        guard isNotRoot else { throw NewAlert(.isRoot, new: self) }
        guard isLongEnough else { throw NewAlert(.tooShort, new: self) }
        guard isPossible else { throw NewAlert(.notPossible, new: self) }
        guard isNew else { throw NewAlert(.notNew, new: self) }
        guard isReal else { throw NewAlert(.notReal, new: self) }
    }
}
