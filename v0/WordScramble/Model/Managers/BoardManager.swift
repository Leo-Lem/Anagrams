//
//  LeaderboardHandler.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation
import CoreData

class BoardManager: Manager {
    lazy var leaderboard: [Entry] = {
        do {
            try self.fetchLeaderboard()
        } catch { print("failed to fetch leaderboard:\n \(error)") }
        
        return []
    }()
}

extension BoardManager {
    var user: User { model.userManager.user }
    var game: GameMode { model.gameManager.game }
}

extension BoardManager {
    func addEntry() {
        let _ = Entry(context: viewContext, user: user, settings: game.settings,
                      time: game.timer ? game.time : -1, foundWords: game.foundWords)
        
        do { try persistence.saveContext() } catch { print("failed to save Entry to CK:\n\(error)") }
        updateViews()
    }
    
    func fetchLeaderboard() throws{
        Task {
            let fetchRequest: NSFetchRequest<CDEntry> = CDEntry.fetchRequest()
            
            try await self.model.persistence.container.viewContext.perform {
                let result = try fetchRequest.execute()
                self.leaderboard = result.map { Entry($0) }
            }
        }
    }
}
