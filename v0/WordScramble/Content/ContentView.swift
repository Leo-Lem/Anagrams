//
//  ContentView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 02.08.21.
//

import SwiftUI
import MyCustomUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            SingleplayerView()
                .sheet(isPresented: $viewmodel.showingSettings, content: { SettingsView() })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: { LeaderboardView() }) {
                            Image(systemName: "list.star")
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Button("current-user-label \(viewmodel.username ?? "Guest")", action: { viewmodel.logOut() })
                            .transition(.move(edge: .top))
                            .hidden(viewmodel.showingLogin)
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        SymbolButton("gear", true: $viewmodel.showingSettings)
                    }
                }
                .disabled(viewmodel.showingLogin, on: .primary)
                .overlay {
                    ZStack {
                        if viewmodel.showingLogin {
                            Text("")
                                .blurBackground()
                            LoginView()
                                .transition(.scale)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .animation(viewmodel.showingLogin)
        .foregroundColor(.primary)
        .navigationViewStyle(.stack)
        .onChange(of: scenePhase) { _ in
            do { try viewmodel.model.persistence.saveContext() } catch { print("saving failed") } }
    }
    
    @StateObject private var viewmodel = ViewModel()
    @Environment(\.scenePhase) var scenePhase
}

//MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
