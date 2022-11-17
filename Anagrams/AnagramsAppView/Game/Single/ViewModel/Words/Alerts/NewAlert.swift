//
//  Model-GameError.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 30.12.21.
//

import Foundation

struct NewAlert: CustomAlert {
    let id: UUID, timestamp: Date, kind: Kind
    let new: NewWord
    
    init(_ kind: Kind, new: NewWord) {
        self.id = UUID()
        self.timestamp = Date()
        self.kind = kind
        self.new = new
    }
    
    var localizedTitle: String {
        let format = NSLocalizedString("title-new-\(kind.rawValue) %@", comment: "")
        return String(format: format, new.word)
    }
    var localizedDesc: String { String(localized: "desc-new-\(kind.rawValue)") }
    
    enum Kind: String, Codable {
        case isRoot = "isRoot", tooShort = "tooShort", notPossible = "notPossible", notNew = "notNew", notReal = "notReal"
    }
}
