//
//  Model.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import Foundation
import MyOthers

class Model: ObservableObject {
    static let shared = Model()
    
    let persistence = PersistenceController.shared
    
    lazy var userManager = UserManager(model: self)
    lazy var gameManager = GameManager(model: self)
    lazy var boardManager = BoardManager(model: self)
}
