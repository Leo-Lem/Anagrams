//
//  LoginView-ViewController.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 01.01.22.
//

import Foundation
import MyOthers
import Combine

final class LoginViewModel: ViewModelProtocol {
    @Published var state = State.idle
    var bag = Set<AnyCancellable>()
    var input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.feedbackUserInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit { bag.removeAll() }
}

extension LoginViewModel {
    enum State {
        case idle,
             name, nameAuth, nameAlert,
             pin, pinAuth, pinAlert,
             reg, regAuth, regAlert
    }
    
    enum Event {
        case onAppear, onNameChecked(_ validated: Bool),
             onPinChecked(_ validated: Bool),
             onRegisterSuccess, OnRegisterFail //system events
        case submitName(_ name: String),
             submitPin(_ pin: String),
             submitRegister(_ name: String, pin: String? = nil) //user events
    }
}

extension LoginViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch (state, event) {
        case (.idle, .onAppear): return .name(.standard)
        case ()
        default: return state
        }
    }
}
