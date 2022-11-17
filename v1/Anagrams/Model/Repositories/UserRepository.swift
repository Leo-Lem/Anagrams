//
//  UserRepository.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import CloudKit
import Combine

class UserRepository: CloudKitRepository {
    typealias Object = CKRecord
    typealias ObjectID = String
    
    let ckID = "iCloud.com.LeoLem.WordScramble"
    let objectSymbol = "User", objectIDSymbol = "name"
}

extension UserRepository {
    enum ValidationStatus { case unknown, pinRequired, wrongPIN, validated }
    func validateCredentials(_ credentials: User.Credentials) -> AnyPublisher<ValidationStatus, Never> {
        let user = fetchUser(credentials.name)
        return user
            .map {
                guard let user = $0 else { return .unknown }
                guard let pin = user.value(forKey: "pin") as? String, !pin.isEmpty else { return .validated }
                guard let credPIN = credentials.pin else { return .pinRequired }
                guard credPIN == pin else { return .wrongPIN }
                return .validated
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchUser(_ name: String) -> AnyPublisher<CKRecord?, Never> {
        let record = self.fetchRecord(objectID: name)
        return record
            .catch { _ in Just(nil) }
            .eraseToAnyPublisher()
    }
}
