//
//  LeaderboardDetailView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import SwiftUI

struct EntryDetailView: View {
    let entry: Entry
    
    var body: some View {
        VStack {
            Group {
                Text("name-score-label \(NSLocalizedString(entry.rUsername, comment: "")) \(localizeIntWithLabel(entry.rScore, label: .points))").font(.title).bold()
                
                Text("with-word-label \(entry.rWord) \(entry.rLanguage)").font(.title)
                
                if entry.rTime != nil {
                    Text("in-seconds-label \(localizeIntWithLabel(entry.rTime!, label: .seconds))").font(.title2)
                }
            }
            
            List(entry.rUsedWords, id: \.self) { word in
                UsedWordView(word: word)
            }
            
            Text("date-time-label \(entry.rTimestamp.formatted(date: .abbreviated, time: .omitted)) \(entry.rTimestamp.formatted(date: .omitted, time: .shortened))").padding(.bottom)
        }
    }
}

struct LeaderboardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailView(entry: .example)
    }
}
