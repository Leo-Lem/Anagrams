//
//  GameErrorsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 04.01.22.
//

import SwiftUI

extension SingleplayerView {
    struct NewAlertsView: View {
        let alerts: [NewAlert]
        
        var body: some View {
            ForEach(alerts) { error in
                CustomAlertView(alert: error)
                    .transition(.slide)
            }
        }
    }
}

//MARK: - Previews
struct GameErrorsView_Previews: PreviewProvider {
    static var previews: some View {
        SingleplayerView.NewAlertsView(alerts: [])
    }
}
