//
//  GameMode.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation

protocol GameMode {
    var id: UUID { get }
    var mode: GameModeType { get }
    var settings: Settings { get }
    
    var timer: Bool { get set }
    var time: Int { get set }
    var newWord: NewWord? { get set }
    
    var foundWords: [Found] { get set }
}

//MARK: shortcut properties
extension GameMode {
    var root: RootWord { settings.root }
    var language: Language { root.language }
    var timelimit: Int { settings.timelimit }
}
