//
//  RankView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import SwiftUI

struct EntryView: View {
    let entry: Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(NSLocalizedString(entry.rUsername, comment: ""))")
                    .font(.headline)
                
                if entry.rTime != nil {
                    Text("took-seconds-label \(localizeIntWithLabel(entry.rTime!, label: .seconds))").font(.subheadline)
                }
                
                Text("with-word-label \(entry.rWord) \(entry.rLanguage)")
                    .font(.subheadline)
                
                Text("date-time-label \(entry.rTimestamp.formatted(date: .abbreviated, time: .omitted)) \(entry.rTimestamp.formatted(date: .omitted, time: .shortened))")
                    .font(.footnote)
            }
            
            Spacer()
            
            VStack {
                Text("\(entry.rScore)").font(.title).bold()
                Text(entry.rScore == 1 ? "point-label" : "points-label").font(.footnote)
            }
        }
    }
}

struct RankView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: .example)
    }
}
