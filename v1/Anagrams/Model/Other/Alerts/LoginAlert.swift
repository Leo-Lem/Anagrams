//
//  LoginAlert.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation

struct LoginAlert: CustomAlert {
    let id: UUID, timestamp: Date, kind: Kind
    
    init(_ kind: Kind) {
        self.id = UUID()
        self.timestamp = Date()
        self.kind = kind
    }
    
    var localizedTitle: String { String(localized: "title-login-\(kind.rawValue)") }
    var localizedDesc: String { String(localized: "desc-login-\(kind.rawValue)") }
    
    enum Kind: String, Codable {
        case guest = "guest",
             username = "username",
             pinRequired = "pinRequired",
             pin = "pin",
             newUsername = "newUsername",
             connection = "connection",
             unknown = "unknown"
    }
}


