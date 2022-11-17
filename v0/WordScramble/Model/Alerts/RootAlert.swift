//
//  RootAlert.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation

struct RootAlert: CustomAlert {
    let id: UUID, timestamp: Date, kind: Kind
    let root: RootWord
    
    init(_ kind: Kind, root: RootWord) {
        self.id = UUID()
        self.timestamp = Date()
        self.kind = kind
        self.root = root
    }
    
    var localizedTitle: String {
        let format = NSLocalizedString("title-root-\(kind.rawValue) %@", comment: "")
        return String(format: format, root.word)
    }
    var localizedDesc: String { "desc-root-\(kind.rawValue)" }
    
    enum Kind: String, Codable {
        case notReal = "notReal", tooShort = "tooShort"
    }
}



