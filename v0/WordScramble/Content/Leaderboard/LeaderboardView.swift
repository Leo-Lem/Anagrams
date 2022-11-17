//
//  HighscoreView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewmodel = ViewModel()
    
    var body: some View {
        VStack {
            Divider()
            
            Spacer()
            
            if viewmodel.entries.isEmpty {
                LoadingSpinnerView()
                    .frame(maxHeight: 30)
            } else {
                List {
                    ForEach(viewmodel.entries) { entry in
                        NavigationLink {
                            EntryDetailView(entry: entry)
                        } label: {
                            EntryView(entry: entry)
                        }
                    }
                }
                .refreshable { viewmodel.refreshEntries() }
            }
            Spacer()
        }
        .navigationTitle("leaderboard-label")
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LeaderboardView()
        }
    }
}
