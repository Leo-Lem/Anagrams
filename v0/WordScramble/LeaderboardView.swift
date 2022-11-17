//
//  HighscoreView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI

struct LeaderboardView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Entry.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Entry.score, ascending: false)
        ]
    ) var entries: FetchedResults<Entry>
    
    var body: some View {
        VStack {
            Text("leaderboard-label").font(.largeTitle).bold()
            
            Divider()
            
            List {
                ForEach(entries) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        EntryView(entry: entry)
                    }
                }
            }
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LeaderboardView()
        }
    }
}
