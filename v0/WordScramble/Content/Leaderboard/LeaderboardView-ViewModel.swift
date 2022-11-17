//
//  LeaderboardView-ViewController.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 01.01.22.
//

import Combine

extension LeaderboardView {
    @MainActor class ViewModel: SuperViewModel {
        var boardManager: BoardManager { model.boardManager }
        
        var entries: [Entry] { model.boardManager.leaderboard.sorted { $0.score > $1.score } }
        
        func refreshEntries() { try? model.boardManager.fetchLeaderboard() }
    }
}
