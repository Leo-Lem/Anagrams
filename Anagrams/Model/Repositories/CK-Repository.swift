//
//  CK-Repository-Protocol.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import Combine
import CloudKit

class CloudKitRepository {
    private static let containerID = "iCloud.com.LeoLem.WordScramble"
    private static var container: CKContainer { CKContainer(identifier: containerID) }
    
    var database: CKDatabase { Self.container.publicCloudDatabase }
    private let objectSymbol = "Example", objectIDSymbol = "id"
    typealias ObjectID = String
}

//MARK: connection status
extension CloudKitRepository {
    //connection status
    static func connection() async throws -> CKAccountStatus {
        let status = try await self.container.accountStatus()
        return status
    }
    
    static func available() async throws -> Bool {
        let status = try await self.container.accountStatus()
        return status == .available
    }
}

//MARK: fetching objects
extension CloudKitRepository {
    
    func fetchRecord(objectID: ObjectID) async throws -> CKRecord? {
        let predicate = NSPredicate(format: "\(objectIDSymbol) == %@", objectID)
        let record = try await fetchRecord(predicate: predicate)
        return record
    }
    
    private func fetchRecord(predicate: NSPredicate) async throws -> CKRecord? {
        let records = try await fetchRecords(predicate: predicate)
        return records.first
    }
    
    private func fetchRecords(predicate: NSPredicate) async throws -> [CKRecord] {
        let results = try await fetchResults(predicate: predicate)
        return try results.map { try $0.get() }
    }
    
    private func fetchResults(predicate: NSPredicate) async throws -> [Result<CKRecord, Error>] {
        let results = try await fetchQueryResults(predicate: predicate)
        return results.map { $0.1 }
    }
    
    private func fetchRecordIDs(predicate: NSPredicate) async throws -> [CKRecord.ID] {
        let resultsWithID = try await fetchQueryResults(predicate: predicate)
        return resultsWithID .map { $0.0 }
    }
    
    private func fetchQueryResults(predicate: NSPredicate) async throws -> [(CKRecord.ID, Result<CKRecord, Error>)] {
        let query = assembleQuery(predicate: predicate)
        let resultsWithID = try await self.database.records(matching: query)
        
        return resultsWithID.matchResults
    }
    
    private func assembleQuery(predicate: NSPredicate) -> CKQuery {
        CKQuery(recordType: self.objectSymbol, predicate: predicate)
    }
    
}


//MARK: saving objects
extension CloudKitRepository {
    
    private func saveRecords(_ records: CKRecord...) async throws {
        _ = try await self.database.modifyRecords(saving: records, deleting: [])
        
        //TODO: check if operation was successful
    }
    
}
