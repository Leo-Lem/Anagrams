//
//  LeaderboardDetailView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import SwiftUI
import MyOthers

struct EntryDetailView: View {
    let entry: Entry
    
    var body: some View {
        VStack {
            Group {
                Text("name-score-label \(NSLocalizedString(entry.user.name ?? "guest-user", comment: "")) \(localizeWithUnit(entry.score, label: .points))").font(.title).bold()
                
                Text("with-word-label \(entry.settings.root.word) \(entry.settings.language.rawValue)").font(.title)
                
                if entry.time != nil {
                    Text("in-seconds-label \(localizeWithUnit(entry.time!, label: .seconds))").font(.title2)
                }
            }
            
            List(entry.foundWords, id: \.self) { foundWord in
                FoundWordView(foundWord: foundWord)
            }
            
            Text("date-time-label \(entry.timestamp.formatted(date: .abbreviated, time: .omitted)) \(entry.timestamp.formatted(date: .omitted, time: .shortened))").padding(.bottom)
        }
    }
}

struct LeaderboardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailView(entry: Entry.example)
    }
}
