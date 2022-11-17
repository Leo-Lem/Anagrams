//
//  AnagramsApp.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import SwiftUI

@main
struct AnagramsApp: App {
    var body: some Scene {
        WindowGroup {
            SingleView(vm: SingleViewModel())
            //AnagramsView(vm: AnagramsViewModel())
        }
    }
}
