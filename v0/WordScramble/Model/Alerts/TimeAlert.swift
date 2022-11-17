//
//  TimeAlert.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation

struct TimeAlert: CustomAlert {
    let id: UUID, timestamp: Date, kind: Kind

    init(_ kind: Kind) {
        self.id = UUID()
        self.timestamp = Date()
        self.kind = kind
    }
    
    var localizedTitle: String { String(localized: "title-time-\(kind.rawValue)") }
    var localizedDesc: String { String(localized: "desc-time-\(kind.rawValue)") }
    
    enum Kind: String, Codable {
        case half = "half", thirty = "thirty", out = "out"
    }
}
