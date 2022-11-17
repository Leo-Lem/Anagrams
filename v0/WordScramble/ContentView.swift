//
//  ContentView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 02.08.21.
//

import SwiftUI
import MyCustomUI

struct ContentView: View {
    @StateObject var viewmodel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                RootwordView(newRootword: $viewmodel.newRootword, editingRootword: $viewmodel.editingRootword,
                             rootword: viewmodel.rootword, isFirst: viewmodel.previousWords.isEmpty) { rootword in
                    withAnimation { viewmodel.newGame(with: rootword) }
                } nextWord: {
                    withAnimation {
                        viewmodel.score != 0 ? viewmodel.showingSaveAlert = true : viewmodel.nextRootword() }
                } previousWord: {
                    withAnimation { viewmodel.previousRootword() }
                }
                .alert("next-word-save-label", isPresented: $viewmodel.showingSaveAlert) {
                    Button("save-label") { viewmodel.saveAndNextRootword() }
                    Button("dont-save-label", role: .destructive) { viewmodel.nextRootword() }
                    Button("cancel-label", role: .cancel) {}
                }
                
                Group {
                    TextField("enter-word-label \(viewmodel.language.rawValue)", text: $viewmodel.newWord) {
                        withAnimation { viewmodel.addWord(viewmodel.newWord) }
                        viewmodel.newWord = ""
                        self.focused = true
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .disabled(viewmodel.timerEnabled && viewmodel.timesUp)
                    .focused($focused)
                    
                    ForEach(viewmodel.gameErrors.reversed()) { error in
                        GameErrorView(error: error)
                            .transition(.slide)
                            .onTapGesture {
                                withAnimation { viewmodel.gameErrors.removeAll { $0.id == error.id } }
                            }
                    }.zIndex(10)
                    
                    List(viewmodel.usedWords, id: \.self) { word in
                        UsedWordView(word: word)
                    }
                }
                .hidden(viewmodel.editingRootword)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    SymbolButton("gear") {
                        withAnimation { viewmodel.showingSettings = true }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    SymbolButton("increase.indent") {
                        withAnimation { viewmodel.showingSave.toggle() }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        LeaderboardView()
                    } label: {
                        Image(systemName: "list.star")
                    }
                }
            }
            
            .overlay(alignment: .bottom) {
                HStack {
                    TimerView(time: $viewmodel.time, limit: viewmodel.limitInSeconds)
                        .onTapGesture {
                            withAnimation { viewmodel.timerEnabled = false}
                        }
                        .hidden(!viewmodel.timerEnabled)
                        .overlay {
                            if !viewmodel.timerEnabled {
                                SymbolButton("timer") {
                                    withAnimation { viewmodel.timerEnabled = true }
                                }
                                .font(.title2)
                                .disabled(viewmodel.timesUp)
                                .foregroundColor(viewmodel.timesUp ? .gray : .primary)
                            }
                        }
                        
                    Spacer()
                        
                    ScoreView(score: viewmodel.score)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.bar)
                
            }
            
            .overlay(alignment: .top) {
                if viewmodel.showingSave {
                    ZStack(alignment: .top) {
                        Color.black.opacity(0.2)
                            .onTapGesture {
                                withAnimation { viewmodel.showingSave = false }
                            }
                        
                        SaveView(username: $viewmodel.username) {
                            withAnimation { viewmodel.saveAndNewGame() }
                        }
                        .padding()
                    }
                }
            }
            
            .sheet(isPresented: $viewmodel.showingSettings) {
                SettingsView(language: $viewmodel.language, timelimit: $viewmodel.timelimit) {
                    withAnimation { viewmodel.applyAndNewGame() }
                }
            }
            
            .navigationBarTitleDisplayMode(.inline)
        }
        .foregroundColor(.primary)
        .navigationViewStyle(.stack)
    }
    
    @FocusState private var focused: Bool
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
