//
//  UserRepository.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import CloudKit
import Combine

class UserRepository: CloudKitRepository {
    let objectSymbol = "User", objectIDSymbol = "name"
}

//MARK: validation methods
enum ValidationStatus { case unknown, pinRequired, wrongPIN, validated }
extension UserRepository {
    func validateCredentials(_ credentials: (name: String, pin: String?)) async -> ValidationStatus {
        guard let user = try? await fetchUser(credentials.name) else { return .unknown }
        guard let pin = user.value(forKey: "pin") as? String, !pin.isEmpty else { return .validated }
        guard let credPIN = credentials.pin else { return .pinRequired }
        guard credPIN == pin else { return .wrongPIN }
        return .validated
    }
    
    func fetchUser(_ name: String) async throws -> CKRecord? {
        try await self.fetchRecord(objectID: name)
    }
}
