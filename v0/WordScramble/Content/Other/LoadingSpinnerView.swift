//
//  LoadingSpinnerView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 08.01.22.
//

import SwiftUI

struct LoadingSpinnerView: View {
    @State private var rotation = Angle.degrees(270)
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            SpinnerCircle(rotation: rotation)
                .onReceive(timer) { _ in
                    withAnimation { rotation += .degrees(90) }
                }
        }
        
        .shadow(color: .primary, radius: 3)
    }
    
    struct SpinnerCircle: View {
        let rotation: Angle
        
        var body: some View {
            Circle()
                .trim(from: 0.1, to: 1)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(rotation)
        }
    }
}

struct LoadingSpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSpinnerView()
            .frame(width: 50, height: 50)
    }
}
