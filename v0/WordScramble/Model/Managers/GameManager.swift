//
//  GameHandler.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation
import MyOthers
import CoreData

class GameManager: Manager {
    private (set) lazy var game: Game = Game(root: rootWord, user: user, mode: .single)
    
    //input values
    lazy var rootWord: RootWord = RootWord.random(language: language) {
        willSet { roots.append(newValue) }
    }
    lazy var newWord: NewWord = NewWord("", game: game)
    
    //alerts
    private(set) var rootAlert: RootAlert? = nil {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                if self.rootAlert?.timestamp ?? Date() < Date()-3 { self.rootAlert = nil }
            }
        }
    }
    private(set) var timeAlert: TimeAlert? = nil {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                if self.timeAlert?.timestamp ?? Date() < Date()-3 { self.timeAlert = nil }
            }
        }
    }
    private(set) var newAlerts = [NewAlert]() {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()+4) {
                self.newAlerts = self.newAlerts.filter { $0.timestamp > Date()-3 }
            }
            newAlerts = newAlerts.suffix(3)
        }
    }
    
    //saving root words in memory
    private(set) var roots: [RootWord] = [] {
        didSet {
            roots.removeDuplicates()
            roots.removeAll { $0.language != language }
        }
    }
    private var lastRoot: RootWord? {
        guard let index = self.roots.firstIndex(where: { $0.word == rootWord.word }) else { return nil }
        return self.roots[optional: index - 1]
    }
    private var nextRoot: RootWord? {
        guard let index = self.roots.firstIndex(of: self.rootWord) else { return nil }
        return self.roots[optional: index + 1]
    }
    
    override init(model: Model) {
        super.init(model: model)
        self.roots.append(rootWord)
    }
}

extension GameManager {
    private var user: User { model.userManager.user }
    private var language: Language { user.defaults.language }
}

//MARK: game setup
extension GameManager {
    func commitRootToStartNewGame() {
        guard !rootWord.isEmpty else {
            rootWord = RootWord.random(language: language)
            return startNewGame()
        }
        
        do {
            try rootWord.checkValidity()
            startNewGame()
        } catch let alert as RootAlert {
            self.rootAlert = alert
            rootWord = lastRoot ?? RootWord.random(language: language)
            print(rootWord)
            updateViews()
        } catch {}
    }
    
    func setNextRootAndStartNewGame() {
        rootWord = nextRoot ?? RootWord.random(language: language)
        startNewGame()
    }
    
    func setLastRootAndStartNewGame() {
        guard let root = lastRoot else { return }
        self.rootWord = root
        startNewGame()
    }
    
    func startSavedGame() {
        self.game = user.game ?? Game(context: viewContext, root: RootWord.random(language: language), user: user, mode: .single)
        updateViews()
    }
    
    private func startNewGame() {
        self.game = Game(context: user.isGuest ? nil : viewContext, root: rootWord, user: user, mode: .single)
        updateViews()
    }
}

//MARK: game play
extension GameManager {
    func addNewWord() {
        guard !newWord.isEmpty else { return }
        
        do {
            try newWord.checkValidity()
            game.foundWords.append(Found(newWord))
        } catch let alert as NewAlert {
            newAlerts.append(alert)
        } catch { }
        
        newWord = NewWord("", game: game)
        updateViews()
    }
    
    var timer: Bool {
        get { game.timer }
        set {
            game.timer = newValue
            updateViews()
        }
    }
    
    var time: Int {
        get { game.time }
        set {
            game.time = newValue
            fetchTimeAlert()
            updateViews()
        }
    }
    
    private func fetchTimeAlert() {
        guard timer else { return }
        
        guard time != game.timelimit/2 else { return timeAlert = TimeAlert(.half) }
        guard time != game.timelimit-30 else { return timeAlert = TimeAlert(.thirty) }
        guard time != game.timelimit else { return timeAlert = TimeAlert(.out) }
    }
}
