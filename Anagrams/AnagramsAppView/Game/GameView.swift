//
//  GameView.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import SwiftUI
import MyOthers

struct GameView: View {
    var body: some View {
        content
            .onAppear { vm.send(event: .onAppear) }
    }
    
    private var content: some View {
        return Group {
            switch vm.state {
            case .menu:
                MenuView() { mode in
                    vm.send(event: .onSelectMode(mode))
                }
            default: TitleScreen(spinner: false)
            }
        }
        .eraseToAnyView()
    }
    
    @StateObject var vm: GameViewModel
}

//MARK: - Previews
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(vm: GameViewModel())
    }
}
