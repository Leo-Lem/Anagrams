//
//  ContentView-ViewModel-Game.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import Foundation
import MyOthers
import CoreData

@objc(CDGame)
class CDGame: NSManagedObject {
    convenience init(context: NSManagedObjectContext? = nil,
                     user: CDUser, mode: String, language: String, rootWord: String, timer: Bool, timelimit: Int16) {
        self.init(context: context)
        
        self.id = UUID()
        self.mode = mode
        
        self.user = (context != nil ? fetchObject(user, from: context!) : user)
        
        self.language = language
        self.rootWord = rootWord
        self.timelimit = timelimit
        
        self.timer = timer
        self.time = 0
        self.foundWords = []
    }
}

//MARK: - custom wrapped struct to make properties easily accessible in Swift
typealias Game = CDGame.Wrapped
extension CDGame {
    var wrapped: Wrapped { Wrapped(self) }
    
    struct Wrapped: GameMode {
        let cd: CDGame
        
        //swift constants
        var id: UUID { cd.id! }
        var mode: GameModeType { GameModeType(rawValue: cd.mode!)! }
        
        var user: User { cd.user!.wrapped }
        var settings: Settings {
            get { Settings(root: RootWord(cd.rootWord!, language: Language(rawValue: cd.language!)!), timelimit: Int(cd.timelimit)) }
            set {
                cd.language = newValue.language.rawValue
                cd.rootWord = newValue.root.word
                cd.timelimit = Int16(newValue.timelimit)
            }
        }
        
        //swift variables
        var foundWords: [Found] {
            get { cd.foundWords!.map { Found($0, language: settings.language) } }
            set { cd.foundWords = newValue.map { $0.word } }
        }
        var time: Int {
            get { Int(cd.time) }
            set { cd.time = Int16(newValue) }
        }
        var timer: Bool {
            get { cd.timer }
            set { cd.timer = newValue }
        }
        
        //computed
        var score: Int { foundWords.reduce(0) { $0 + $1.points } }
        
        //not saved
        var newWord: NewWord? = nil
        
        init(_ cdGame: CDGame) { self.cd = cdGame }
        
        init(context: NSManagedObjectContext? = nil,
             root: RootWord, user: User, mode: GameModeType) {
            let settings = Settings(root: root, timelimit: user.defaults.timelimit)
            let timer = user.defaults.timer
            let mode = mode.rawValue
            let user = user.cd
            
            self.cd = CDGame(context: context, user: user, mode: mode,
                             language: settings.language.rawValue, rootWord: settings.root.word, timer: timer, timelimit: Int16(settings.timelimit))
        }
    }
}
