//
//  LogoView.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import SwiftUI
import MyCustomUI

struct TitleScreen: View {
    let spinner: Bool
    
    var body: some View {
        VStack {
            Logo()
            if spinner && startSpinner { Spinner(size: .medium) }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { withAnimation { startSpinner = true } }
        }
    }
    
    @State private var startSpinner = false
}

//MARK: - Previews
struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreen(spinner: true)
    }
}
