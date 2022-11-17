//
//  File.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation

protocol CustomAlert: Error, Identifiable, Hashable, Codable {
    associatedtype Kind: RawRepresentable, Codable
    
    var id: UUID { get }
    var timestamp: Date { get }
    var kind: Kind { get }
    
    var localizedTitle: String { get }
    var localizedDesc: String { get }
}

extension CustomAlert {
    static func ==<A: CustomAlert>(lhs: Self, rhs: A) -> Bool { lhs.id == rhs.id }
    static func !=<A: CustomAlert>(lhs: Self, rhs: A) -> Bool { lhs.id != rhs.id }
}
