//
//  CDDefaults+Defaults.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 05.01.22.
//

struct Defaults {
    var language: Language, timer: Bool, timelimit: Int, autosave: Bool
    
    static let standard = Defaults(language: .english, timer: true, timelimit: 300, autosave: true)
}
