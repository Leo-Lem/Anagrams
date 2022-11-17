//
//  NetworkConnectionObserver.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import Combine
import Network

//MARK: observes internet connection and notifies of changes
class ConnectionManager {
    static let monitor = NWPathMonitor()
    
    enum ConnectionStatus { case off, noCK, noNet, on }
    static func publisher() -> AnyPublisher<ConnectionStatus, Never> {
        let status = PassthroughSubject<ConnectionStatus, Never>()
        
        monitor.pathUpdateHandler = { path in
            Task { await statusOnPublisher(path: path, publisher: status) }
        }
        
        monitor.start(queue: DispatchQueue(label: "ConnectionMonitor"))
        
        return status.eraseToAnyPublisher()
    }
    
    private static func statusOnPublisher(path: NWPath, publisher: PassthroughSubject<ConnectionStatus, Never>) async {
        let internet = path.status == .satisfied
        let cloudkit = (try? await CloudKitRepository.available()) ?? false
        
        let status: ConnectionStatus
        
        switch (internet, cloudkit) {
        case (false, false): status = .off
        case (false, true): status = .noNet
        case (true, false): status = .noCK
        case (true, true): status = .on
        }
        
        publisher.send(status)
    }
}
