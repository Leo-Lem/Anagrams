//
//  ContentView-ViewModel.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        //model
        private let model = Model.singleton
        var rootword: String { model.game.root }
        var usedWords: [String] { model.game.used }
        var score: Int { model.game.used.joined(separator: "").count }
        
        //rootword
        @Published var editingRootword = false
        var newRootword = "" {
            willSet { objectWillChange.send() }
            didSet { newRootword = newRootword.lowercased() }
        }
        private(set) var previousWords = [String]()
        
        //game
        var newWord = "" {
            willSet { objectWillChange.send() }
            didSet { newWord = newWord.lowercased() }
        }
        var gameErrors = [Model.GameError]() {
            willSet { objectWillChange.send() }
            didSet { removeError() }
        }
        
        //timer
        var time: Int {
            willSet { objectWillChange.send() }
            didSet { updateTimer() }
        }
        var timesUp: Bool { time >= limitInSeconds }
        var limitInSeconds: Int { model.user.timelimit * 60 }
        
        //settings
        @Published var showingSettings = false
        @Published var language: Model.SupportedLanguage
        @Published var timelimit: Int
        var timerEnabled: Bool {
            willSet { objectWillChange.send() }
            didSet { model.user.timer = self.timerEnabled }
        }
        
        //saving
        @Published var showingSave = false
        @Published var showingSaveAlert = false
        var username: String {
            get { model.user.name == "unknown-user" ? "" : model.user.name}
            set {
                objectWillChange.send()
                model.user.name = newValue
            }
        }
        
        init() {
            self.language = model.user.language
            self.timerEnabled = model.user.timer
            self.timelimit = model.user.timelimit
            
            self.time = model.game.time
        }
    }
}

extension ContentView.ViewModel {
    func addWord(_ word: String) {
        do {
            try model.game.addWord(word)
        } catch let gameError as Model.GameError {
            self.gameErrors.append(gameError)
        } catch { print("Unexpected Error: \(error)") }
        
        self.previousWords.removeAll()
    }
    
    func newGame(with rootword: String? = nil) {
        do {
            guard let root = rootword else { return restartWithRandom() }
            guard rootword != "" else { return restartWithRandom() }
            
            try checkRoot(root)
            
            model.game.restart(with: root)
        } catch let gameError as Model.GameError {
            self.gameErrors.append(gameError)
        } catch { print("Unexpected Error: \(error)") }
    }
    
    func nextRootword() {
        self.previousWords.append(model.game.root)
        newGame()
    }
    
    func previousRootword() {
        newGame(with: previousWords.last)
        self.previousWords.removeLast()
    }
    
    func saveAndNextRootword() {
        save()
        nextRootword()
    }
    
    func saveAndNewGame() {
        save()
        newGame()
        self.showingSave = false
    }
    
    func applyAndNewGame() {
        model.user.language = language
        model.user.timelimit = timelimit
        
        model.startWords = model.fetchStartWords()
        newGame()
        self.showingSettings = false
    }
    
    private func restartWithRandom() {
        model.game.restart(with: model.startword)
        self.time = 0
    }
    
    private func save() {
        model.user.name = self.username.isEmpty ? "unknown-user" : self.username
        model.addLeaderboardEntry(game: model.game)
    }
}

extension ContentView.ViewModel {
    private func checkRoot(_ word: String) throws {
        guard word.count > 5 else { throw Model.GameError(.rootTooShort, word: word) }
        guard word.capitalized(with: Locale(identifier: model.user.language.rawValue)).checkIfReal(language: model.user.language.rawValue) else {
            throw Model.GameError(.rootNotReal, word: word)
        }
    }
}

import SwiftUI

extension ContentView.ViewModel {
    private func updateTimer() {
        model.game.time = time
        
        guard timerEnabled else { return }
        
        if time == limitInSeconds / 2 {
            self.gameErrors.append(Model.GameError(.halftime))
        } else if time == limitInSeconds - 1 {
            self.gameErrors.append(Model.GameError(.timesUp))
        }
    }
    
    private func removeError() {
        guard gameErrors.count <= 3 else {
            gameErrors.removeFirst()
            return
        }
        
        if let gameError = gameErrors.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //TODO: Figure out how to add this animation from the view itself
                self.gameErrors.removeAll { $0.id == gameError.id }
            }
        }
    }
}
