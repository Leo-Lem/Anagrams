//
//  GameErrorsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 04.01.22.
//

import SwiftUI

struct CustomAlertsList<A: CustomAlert>: View {
    let alerts: [A], transition: AnyTransition?
    
    var body: some View {
        ForEach(alerts) { alert in
            transition != nil ? customAlertWithTransition(alert) : customAlert(alert)
        }
    }
    
    private func customAlertWithTransition(_ alert: A) -> AnyView {
        customAlert(alert)
            .transition(transition!)
            .eraseToAnyView()
    }
    
    private func customAlert(_ alert: A) -> AnyView {
        VStack {
            Text(LocalizedStringKey(alert.localizedTitle)).font(.headline)
            Text(LocalizedStringKey(alert.localizedDesc)).font(.footnote)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .border(.foreground , width: 5)
        .cornerRadius(10)
        .padding(.horizontal)
        .eraseToAnyView()
    }
    
    init(_ alerts: A..., transition: AnyTransition? = nil) {
        self.alerts = alerts
        self.transition = transition
    }
}

//MARK: - Previews
struct CustomAlertsList_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertsList(NewAlert.example, NewAlert.example)
    }
}
