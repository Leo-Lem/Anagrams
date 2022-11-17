//
//  GameErrorView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI

struct CustomAlertView<A: CustomAlert>: View {
    let alert: A
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey(alert.localizedTitle)).font(.headline)
                
            Text(LocalizedStringKey(alert.localizedDesc)).font(.footnote)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .border(.foreground , width: 5)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

//MARK: - Previews
struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(alert: NewAlert(.notNew, new: NewWord.example))
    }
}
