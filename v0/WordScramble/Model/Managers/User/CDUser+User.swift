//
//  User.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import CoreData
import MyOthers

@objc (CDUser)
class CDUser: NSManagedObject {
    convenience init(context: NSManagedObjectContext? = nil,
                     name: String?, pin: String?,
                     language: String, timer: Bool, timelimit: Int16, autosave: Bool) {
        self.init(context: context)
        
        self.registeredOn = Date()
        
        self.name = name
        self.pin = pin
        
        self.language = language
        self.timer = timer
        self.timelimit = timelimit
        self.autosave = autosave
        
        self.entries = []
    }
}

//MARK: - custom wrapped struct to make properties easily accessible in Swift
typealias User = CDUser.Wrapped
extension CDUser {
    var wrapped: Wrapped { Wrapped(self) }
    
    struct Wrapped: Hashable, Identifiable {
        let cd: CDUser
        
        //swift constants
        var id: String { name ?? "guest" }
        var registeredOn: Date { cd.registeredOn! }
        
        //swift variables
        var name: String? {
            get { cd.name }
            set { cd.name = newValue }
        }
        var pin: String? {
            get { cd.pin }
            set { cd.pin = newValue }
        }
        var defaults: Defaults {
            get { Defaults(language: Language(rawValue: cd.language!)!, timer: cd.timer, timelimit: Int(cd.timelimit), autosave: cd.autosave) }
            set {
                cd.language = newValue.language.rawValue
                cd.timer = newValue.timer
                cd.timelimit = Int16(newValue.timelimit)
                cd.autosave = newValue.autosave
            }
        }
        var game: Game? {
            get { cd.game != nil ? Game(cd.game!) : nil }
            set {
                guard let root = newValue?.root, let user = newValue?.user, let mode = newValue?.mode else { return cd.game = nil }
                cd.game = Game(root: root, user: user, mode: mode).cd
            }
        }
        var entries: [Entry] {
            get {
                let set = cd.entries as? Set<CDEntry> ?? []
                return set.map { $0.wrapped }
            }
            set {
                let array = newValue.map { $0.user }
                cd.entries = NSSet(array: array)
            }
        }
        
        var isGuest: Bool { self.name == nil }
        
        init(_ cdUser: CDUser) { self.cd = cdUser }
        
        init(context: NSManagedObjectContext? = nil,
             name: String?, pin: String? = nil, defaults: Defaults = Defaults.standard) {
            let pin = (name == nil ? nil : pin)
            
            self.cd = CDUser(context: context, name: name, pin: pin,
                             language: defaults.language.rawValue,
                             timer: defaults.timer,
                             timelimit: Int16(defaults.timelimit),
                             autosave: defaults.autosave)
        }
        
        static let guest = User(name: nil, pin: nil, defaults: Defaults.standard)
    }
}
