//
//  Entry.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 30.12.21.
//

import CoreData
import MyOthers

@objc (CDEntry)
class CDEntry: NSManagedObject {
    convenience init(context: NSManagedObjectContext? = nil,
                     user: CDUser, language: String, rootWord: String, timelimit: Int16, time: Int16, foundWords: [String]) {
        self.init(context: context)
        
        self.id = UUID()
        self.timestamp = Date()
        
        self.user = context != nil ? fetchObject(user, from: context!) : user
        
        self.language = language
        self.rootWord = rootWord
        self.timelimit = timelimit
        
        self.time = time
        self.foundWords = foundWords
    }
}

//MARK: - custom wrapped struct to make properties easily accessible in Swift
typealias Entry = CDEntry.Wrapped
extension CDEntry {
    var wrapped: Wrapped { Wrapped(self) }
    
    struct Wrapped: Hashable, Identifiable {
        let cd: CDEntry
        
        //swift constants
        var id: UUID { cd.id! }
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
        var time: Int? {
            get { cd.time == -1 ? nil : Int(cd.time) }
            set { cd.time = Int16(newValue ?? -1) }
        }
        var timestamp: Date {
            get { cd.timestamp! }
            set { cd.timestamp = newValue }
        }
        
        //computed
        var score: Int { foundWords.reduce(0) { $0 + $1.points } }
        
        init(_ cdEntry: CDEntry) { self.cd = cdEntry }
        
        init(context: NSManagedObjectContext? = nil,
             user: User, settings: Settings, time: Int?, foundWords: [Found]) {
            let user = user.cd
            let time = Int16(time ?? -1)
            let foundWords = foundWords.map { $0.word }
            
            self.cd = CDEntry(context: context, user: user,
                              language: settings.language.rawValue, rootWord: settings.root.word, timelimit: Int16(settings.timelimit),
                              time: time, foundWords: foundWords)
        }
    }
}
