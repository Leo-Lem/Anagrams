//
//  Root.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 03.01.22.
//

import Foundation

struct RootWord: Word {
    let word: String, language: Language
    
    init(_ word: String, language: Language) {
        self.word = word
        self.language = language
    }
    
    static func ==(lhs: RootWord, rhs: RootWord) -> Bool { lhs.word == rhs.word && lhs.language == rhs.language }
}

//MARK: shortcut properties
extension RootWord {
    private var languageCode: String { language.rawValue }
    private var localized: String { word.capitalized(with: Locale(identifier: languageCode)) }
}

//MARK: determine if root word follows game rules
extension RootWord {
    private var isLongEnough: Bool { self.count >= 6 }
    private var isReal: Bool { self.checkIfReal(language: language.rawValue) }
    
    var isValid: Bool { isLongEnough && isReal }
    
    func checkValidity() throws {
        guard isLongEnough else { throw RootAlert(.tooShort, root: self) }
        guard isReal else { throw RootAlert(.notReal, root: self) }
    }
}
