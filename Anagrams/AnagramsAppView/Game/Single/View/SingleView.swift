//
//  SingleView.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 16.01.22.
//

import SwiftUI
import MyCustomUI

struct SingleView: View {
    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .embedInNavigation()
            .onAppear { vm.send(event: .onAppear) }
    }
    
    private var content: some View {
        Group {
            switch vm.state {
            case .setup:
                SetupView { vm.send(event: .start($0))
                } continue: { vm.send(event: .continue) }
                    .navigationTitle("single-setup-title")
                
            case.game(let settings):
                GameView(settings: settings) { vm.send(event: .start($0))
                } save: { vm.send(event: .save($0))
                } setup: { vm.send(event: .setup) }
                    .navigationTitle("single-game-title")
                
            default: TitleScreen(spinner: false)
            }
        }
        .eraseToAnyView()
    }
    
    @StateObject var vm: SingleViewModel
    typealias Game = SingleViewModel.Game
    typealias Settings = SingleViewModel.Settings
}

//MARK: - Previews
struct SingleView_Previews: PreviewProvider {
    static var previews: some View {
        SingleView(vm: SingleViewModel())
    }
}
