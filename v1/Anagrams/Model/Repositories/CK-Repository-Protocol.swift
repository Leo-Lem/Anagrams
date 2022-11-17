//
//  CK-Repository-Protocol.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import Combine
import CloudKit

protocol CloudKitRepository: Repository where Object == CKRecord, ObjectID: CVarArg {
    var ckID: String { get }
    var objectSymbol: String { get }
    var objectIDSymbol: String { get }
}

extension CloudKitRepository {
    var container: CKContainer { CKContainer(identifier: ckID) }
    var database: CKDatabase { container.publicCloudDatabase }
}

//MARK: fetching objects
extension CloudKitRepository {
    func fetchRecord(objectID: ObjectID) -> AnyPublisher<CKRecord?, Error> {
        let predicate = NSPredicate(format: "\(objectIDSymbol) == %@", objectID)
        return fetchFirstRecord(predicate: predicate)
    }
    
    func fetchRecord(predicate: NSPredicate) -> AnyPublisher<CKRecord?, Error> {
        let records = fetchRecords(predicate: predicate)
        return records
            .tryMap { $0.first }
            .eraseToAnyPublisher()
    }
    
    func fetchRecords(predicate: NSPredicate) -> AnyPublisher<[CKRecord], Error> {
        let results = fetchQueryResults(predicate: predicate)
        return results
            .tryMap { try $0.map { try $0.get() } }
            .eraseToAnyPublisher()
    }
    
    private func fetchRecordIDs(predicate: NSPredicate) -> AnyPublisher<[CKRecord.ID], Error> {
        let resultsWithID = fetchQueryResultsWithRecordID(predicate: predicate)
        return resultsWithID
            .map { $0.map { $0.0 } }
            .eraseToAnyPublisher()
    }
    
    private func fetchQueryResults(predicate: NSPredicate) -> AnyPublisher<[Result<CKRecord, Error>], Error> {
        let results = fetchQueryResultsWithRecordID(predicate: predicate)
        return results
            .map { $0.map { $0.1 } }
            .eraseToAnyPublisher()
    }
    
    private func fetchQueryResultsWithRecordID(predicate: NSPredicate) -> AnyPublisher<[(CKRecord.ID, Result<CKRecord, Error>)], Error> {
        return Future { promise in
            Task {
                do {
                    let query = CKQuery(recordType: objectSymbol, predicate: predicate)
                    let resultsWithID = try await self.database.records(matching: query)
                    
                    promise(.success(resultsWithID.matchResults))
                } catch { promise(.failure(error)) }
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: connection status
extension CloudKitRepository {
    func canConnect() -> AnyPublisher<Bool, Never> {
        return Future<Bool, Never> { promise in
            Task {
                let ckStatus = try? await self.container.accountStatus()
                let status = (ckStatus == .available)
                promise(.success(status))
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: saving objects
extension CloudKitRepository {
    
}
