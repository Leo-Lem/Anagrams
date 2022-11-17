//
//  Persistence.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 30.12.21.
//

import Foundation
import Combine
import CloudKit
import Network

class PersistenceController {
    static let databaseID = "iCloud.com.LeoLem.WordScramble"
    static let container = CKContainer(identifier: databaseID)
    
    lazy var database = Self.container.publicCloudDatabase
    
    enum ValidationStatus { case guest, pinRequired, validated }
    func validateName(_ name: String) -> AnyPublisher<ValidationStatus, Never> {
        return Future<ValidationStatus, Never> { promise in
            Task {
                let predicate = NSPredicate(format: "name == %@", name)
                let query = CKQuery(recordType: "User", predicate: predicate)
                let results = try? await self.database.records(
                    matching: query,
                    desiredKeys: ["pin"],
                    resultsLimit: 1)
                let result = results?.matchResults.first
                let record = try? result?.1.get()
                let pinIsEmpty = (record?.value(forKey: "pin") as? String)?.isEmpty
                if let pinIsEmpty = pinIsEmpty {
                    promise(.success(pinIsEmpty ? .validated : .pinRequired))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func validatePIN(_ credentials: User.Credentials) -> AnyPublisher<ValidationStatus, Never> {
        return Future<ValidationStatus, Never> { promise in
            Task {
                let predicate = NSPredicate(format: "name == %@", credentials.name)
                let query = CKQuery(recordType: "User", predicate: predicate)
                let results = try? await self.database.records(
                    matching: query,
                    desiredKeys: ["pin"],
                    resultsLimit: 1)
                let result = results?.matchResults.first
                let record = try? result?.1.get()
                if let pin1 = credentials.pin, let pin2 = record?.value(forKey: "pin") as? String {
                    if pin1 == pin2 {
                        promise(.success(.validated))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchUser(_ name: String) -> AnyPublisher<User, Error> {
        let predicate = NSPredicate(format: "name == %@", name)
        let query = CKQuery(recordType: "User", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        
        return User.guest
    }
    
    func pushUser(_ user: User) -> AnyPublisher<CKRecord, Error> {
        let subject = PassthroughSubject<CKRecord, Error>()
        
        Task {
            let record = try await database.save(user.ckRecord)
            subject.send(record)
        }
        
        return subject.eraseToAnyPublisher()
    }
}

//MARK: monitoring internet and cloudkit connectivity
extension PersistenceController {
    static let monitor = NWPathMonitor()
    
    static var initialConnectionStatus: AnyPublisher<Bool, Never> {
        return Future<Bool, Never> { promise in
            Task {
                let networkStatus = monitor.currentPath.status
                let ckStatus = try? await Self.container.accountStatus()
                let status = (networkStatus == .satisfied && ckStatus == .available)
                
                promise(.success(status))
            }
        }
        .eraseToAnyPublisher()
    }
    
    static var connectionStatus: AnyPublisher<Bool, Never> {
        let publisher = CurrentValueSubject<Bool, Never>(monitor.currentPath.status == .satisfied)
        
        monitor.pathUpdateHandler = { publisher.send($0.status == .satisfied) }
        monitor.start(queue: DispatchQueue(label: "ConnectionMonitor"))
    }
}
