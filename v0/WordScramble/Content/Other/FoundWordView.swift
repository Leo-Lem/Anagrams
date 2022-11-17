//
//  UsedWordView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI
import MyCustomUI

struct FoundWordView: View {
    let foundWord: Found
    
    var body: some View {
        HStack {
            Image(systemName: "\(foundWord.points).circle")
            Text(foundWord.word)
            Spacer()
            Image(systemName: "arrowshape.turn.up.right.circle")
                .webLink(url: foundWord.wiktionaryLink)
                .buttonStyle(.borderless)
        }
        .font(.headline)
        .foregroundColor(.primary)
    }
}


//MARK: - Previews
struct FoundWordView_Previews: PreviewProvider {
    static var previews: some View {
        FoundWordView(foundWord: Found(NewWord.example))
    }
}
