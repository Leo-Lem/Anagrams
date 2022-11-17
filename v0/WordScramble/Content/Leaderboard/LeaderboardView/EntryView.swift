//
//  RankView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import SwiftUI
import MyOthers

struct EntryView: View {
    let entry: Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(NSLocalizedString(entry.user.name ?? "guest-user", comment: ""))")
                    .font(.headline)
                
                if entry.time != nil {
                    Text("took-seconds-label \(localizeWithUnit(entry.time!, label: .seconds))").font(.subheadline)
                }
                
                Text("with-word-label \(entry.settings.root.word) \(entry.settings.language.rawValue)")
                    .font(.subheadline)
                
                Text("date-time-label \(entry.timestamp.formatted(date: .abbreviated, time: .omitted)) \(entry.timestamp.formatted(date: .omitted, time: .shortened))")
                    .font(.footnote)
            }
            
            Spacer()
            
            VStack {
                Text("\(entry.score)").font(.title).bold()
                Text(localizeUnit(entry.score, label: .points)).font(.footnote)
            }
        }
    }
}

struct RankView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: Entry.example)
    }
}
