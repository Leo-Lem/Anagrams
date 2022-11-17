//
//  SingleplayerView.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 16.01.22.
//

import SwiftUI
import MyCustomUI

extension SingleView {
    struct GameView: View {
        let settings: Settings
        let start: (Settings) -> Void, save: (Game) -> Void, setup: () -> Void
        
        var body: some View {
            VStack {
                RootWordView(rootWord: settings.word, editing: $editingRootWord, newGame: startGame)
                    
                Group {
                    NewWordView(addWord: addWord).disabled(game.timeUp)
                    
                    //TODO: implement alerts
                    if timeAlert != nil { CustomAlertsList(timeAlert!)}
                    if rootAlert != nil { CustomAlertsList(rootAlert!) }
                    CustomAlertsList(newAlerts)
                    
                    //TODO: implement found words
                    FoundWordsList(foundWords: game.foundWords)
                }
                .disabled(editingRootWord)
                      
            }
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .overlay(alignment: .bottom) {
                TimerSaveScoreBarView(
                    enabled: $game.timer,
                    timeLeft: game.timeLeft, score: game.score, timeUp: game.timeUp,
                    save: saveGame
                )
                .onReceive(timer) { _ in timerAction() }
                .disabled(editingRootWord)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("back-to-menu-button", action: returnToSetup)
                }
            }
        }
        
        init(settings: Settings, start: @escaping (Settings) -> Void, save: @escaping (Game) -> Void, setup: @escaping () -> Void) {
            self.settings = settings
            self.start = start
            self.save = save
            self.setup = setup
            
            self._game = State(initialValue: Game(settings: settings))
        }
        
        //MARK: - local properties
        @State private var game: Game
        @State private var editingRootWord = false
        
        @State private var timeAlert: TimeAlert? = nil
        @State private var rootAlert: RootAlert? = nil
        @State private var newAlerts = [NewAlert]()
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        //MARK: - local methods
        func addWord(_ word: String) {
            do {
                let newWord = try NewWord(word, game: self.game)
                let foundWord = FoundWord(newWord)
                
                game.foundWords.append(foundWord)
            } catch let alert as NewAlert {
                newAlerts.append(alert)
            } catch {}
        }
        
        func startGame(_ word: String) {
            do {
                let settings = try getNewSettings(with: word)
                
                start(settings)
            } catch let alert as RootAlert {
                rootAlert = alert
            } catch {}
        }
        
        func timerAction() {
            guard !game.timeUp else { return cancelTimer() }
            
            increaseTimer()
            
            alertAboutTimer()
        }
        
        func returnToSetup() {
            saveGame()
            setup()
        }
        
        func saveGame() { save(game) }
        
        //MARK: - sub-methods
        private func increaseTimer() {
            game.time += Int(timer.upstream.interval)
        }
        
        private func cancelTimer() {
            timer.upstream.connect().cancel()
            game.time = game.settings.timelimit
        }
        
        private func alertAboutTimer() {
            if game.timer {
                switch game.time {
                case game.secondlimit / 2: timeAlert = TimeAlert(.half)
                case game.secondlimit - 30: timeAlert = TimeAlert(.thirty)
                case game.secondlimit: timeAlert = TimeAlert(.out)
                default: break
                }
            }
        }
        
        private func getNewSettings(with word: String) throws -> Settings {
            try Settings(word: word, language: self.settings.language, timelimit: self.settings.timelimit)
        }
        
        private func addToFoundWords(_ newWord: NewWord) throws {
            try newWord.checkValidity()
        }
    }
}
