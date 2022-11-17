//
//  MenuView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 16.01.22.
//

import SwiftUI

struct MenuView: View {
    let start: (_ mode: Mode) -> Void
    
    var body: some View {
        VStack {
            Logo()
            
            Divider()
            
            Button("Single") { start(.single) }
            //TODO: add more gamemodes
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView() { _ in }
    }
}
