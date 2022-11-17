//
//  SingleplayerView-ViewModel.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 02.01.22.
//

import Foundation
import Combine

extension SingleplayerView {
    @MainActor class ViewModel: SuperViewModel {
        @Published var editingRoot = false
        
        lazy var rootword: String = game.root.word.lowercased() {
            willSet { objectWillChange.send() }
        }
        var newWord: String = "" {
            willSet { objectWillChange.send() }
            didSet {
                newWord = newWord.trimmingCharacters(in: .letters.inverted)
                newWord = newWord.lowercased()
            }
        }
    }
}

//MARK: shortcut properties
extension SingleplayerView.ViewModel {
    private var gameManager: GameManager { model.gameManager }
    private var user: User { model.userManager.user }
    private var game: Game { model.gameManager.game }
    
    var foundWords: [FoundWord] { game.foundWords }
    var score: Int { game.score }
    var root: RootWord { gameManager.rootWord }
}

//MARK: root word
extension SingleplayerView.ViewModel {
    func setNextRoot() { gameManager.setNextRootAndStartNewGame() }
    func setLastRoot() { gameManager.setLastRootAndStartNewGame() }
    func commitRoot() {
        gameManager.rootWord = RootWord(rootword, language: user.defaults.language)
        gameManager.commitRootToStartNewGame()
    }
}

//MARK: new word
extension SingleplayerView.ViewModel {
    func addWord() {
        gameManager.newWord = NewWord(newWord, game: game)
        gameManager.addNewWord()
        newWord = ""
    }
}

//MARK: timer
extension SingleplayerView.ViewModel {
    var time: Int {
        get { model.gameManager.time }
        set { model.gameManager.time = newValue }
    }
    
    var timer: Bool {
        get { model.gameManager.timer }
        set {
            model.gameManager.timer = newValue
            model.userManager.setPreference(timer: newValue)
        }
    }
    
    var timelimit: Int { game.settings.timelimit }
    var timeUp: Bool { time >= timelimit }
    var timerEnabledAndTimeUp: Bool { timer && timeUp }
}

//MARK: game handler alerts
extension SingleplayerView.ViewModel {
    var rootAlert: RootAlert? { gameManager.rootAlert }
    var newAlerts: [NewAlert] { gameManager.newAlerts.reversed() }
    var timeAlert: TimeAlert? { gameManager.timeAlert}
}

//MARK: saving to leaderboard
extension SingleplayerView.ViewModel {
    func save() { model.boardManager.addEntry() }
}
