//
//  AnagramsView.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import SwiftUI
import MyCustomUI

struct AnagramsView: View {
    var body: some View {
        content
    }
    
    private var content: some View {
        return Group {
            switch vm.state {
            case .idle: TitleScreen(spinner: false)
            //case .loggingIn:
                //LoginView(viewmodel: LoginViewModel())
            case .game:
                GameView(vm: GameViewModel())
            //case .board: BoardView()
            //default: LogoView(spinner: false)
            }
        }
        .eraseToAnyView()
    }
    
    @StateObject var vm: AnagramsViewModel
}

//MARK: - Previews
struct AnagramsView_Previews: PreviewProvider {
    static var previews: some View {
        AnagramsView(vm: AnagramsViewModel())
    }
}
