//
//  FoundWordsList.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 16.01.22.
//

import SwiftUI

struct FoundWordsList: View {
    let foundWords: [FoundWord]
    
    var body: some View {
        List(foundWords, id: \.self) { foundWord in
            foundWordView(foundWord)
        }
    }
        
    private func foundWordView(_ foundWord: FoundWord) -> some View {
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
        .eraseToAnyView()
    }
}

//MARK: - Previews
struct FoundWordsList_Previews: PreviewProvider {
    static var previews: some View {
        FoundWordsList(foundWords: [])
    }
}
