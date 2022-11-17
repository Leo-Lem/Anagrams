//
//  Settings.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 03.01.22.
//

import Foundation

struct Settings {
    var language: Language
    var root: RootWord
    var timelimit: Int
    
    init(root: RootWord, timelimit: Int) {
        self.language = root.language
        self.root = root
        self.timelimit = timelimit
    }
}
