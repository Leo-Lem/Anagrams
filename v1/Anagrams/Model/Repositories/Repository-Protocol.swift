//
//  Repository-Protocol.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import Combine

protocol Repository {
    associatedtype Object
    associatedtype ObjectID
    
    func canConnect() -> AnyPublisher<Bool, Never>
}
