//
//  Word.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation
import MyOthers

protocol Word: Codable, Hashable {
    var word: String { get }
    var language: Language { get }
}

extension Word {
    func isEqual<W: Word>(to other: W) -> Bool { self.word == other.word && self.language == other.language }
    func isNotEqual<W: Word>(to other: W) -> Bool { self.word != other.word || self.language != other.language }
}

extension Word {
    var count: Int { self.word.count }
    var isEmpty: Bool { self.word.isEmpty }
    func checkIfContained<W: Word>(_ subword: W) -> Bool { self.word.checkIfContained(subword: subword.word) }
    public func checkIfReal(language: String) -> Bool {
        //TODO: rewrite with new dictionaries
        /*let checker = UITextChecker(), range = NSRange(location: 0, length: self.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: self, range: range, startingAt: 0, wrap: false, language: language)
        
        return misspelledRange.location == NSNotFound*/
        return false
    }
}
