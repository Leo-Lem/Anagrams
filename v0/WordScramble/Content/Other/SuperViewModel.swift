//
//  SuperViewModel.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 08.01.22.
//

import Foundation
import Combine

class SuperViewModel: ObservableObject {
    let model = Model.shared
    lazy var observer: AnyCancellable? = {
        return model.objectWillChange.sink { _ in
            DispatchQueue.main.async { self.objectWillChange.send() }
        }
    }()
    init() { self.observer = observer }
}
