//
//  GameRepository.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import CloudKit

class GameRepository: CloudKitRepository {
    typealias Object = CKRecord
    typealias ObjectID = String
    
    let ckID = "iCloud.com.LeoLem.WordScramble"
    let objectType = "Game"
}
