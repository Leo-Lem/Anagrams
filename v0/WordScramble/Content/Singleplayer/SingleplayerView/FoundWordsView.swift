//
//  FoundWordsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 05.01.22.
//

import SwiftUI

extension SingleplayerView {
    struct FoundWordsView: View {
        let foundWords: [Found]
        
        var body: some View {
            List(foundWords, id: \.self) { foundWord in
                FoundWordView(foundWord: foundWord)
            }
        }
    }
}

//MARK: - Previews
struct FoundWordsView_Previews: PreviewProvider {
    static var previews: some View {
        SingleplayerView.FoundWordsView(foundWords: [])
    }
}
