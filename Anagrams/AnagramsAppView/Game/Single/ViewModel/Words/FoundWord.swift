//
//  FoundWord.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 03.01.22.
//

import Foundation

struct FoundWord: Word {
    let word: String, language: Language
    
    init(_ word: String, language: Language) {
        self.word = word
        self.language = language
    }
    
    init(_ new: NewWord) {
        self.word = new.word
        self.language = new.language
    }
}

//MARK: computed properties
extension FoundWord {
    var points: Int { word.count }
    var wiktionaryLink: URL { URL(string: "https://wiktionary.org/wiki/")!.appendingPathComponent(word) }
}
