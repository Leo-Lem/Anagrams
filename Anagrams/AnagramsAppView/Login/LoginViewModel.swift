//
//  LoginViewModel.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import Foundation
import Combine
import MyOthers

final class LoginViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    private var bag = Set<AnyCancellable>()
    private var input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.userInput(input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit { bag.removeAll() }
    func send(event: Event) { input.send(event) }
}

extension LoginViewModel {
    enum State {
        case idle,
             name(auth: Bool, alert: String),
             pin(auth: Bool, alert: String),
             reg(auth: Bool, alert: String)
    }
    
    enum Event {
            case onAppear,
                 onNameChecked(_ validated: Bool),
                 onPinChecked(_ validated: Bool),
                 onRegisterSuccess, OnRegisterFail //system events
            case submitName(_ name: String),
                 submitPin(_ pin: String),
                 submitRegister(_ name: String, pin: String? = nil),
                 cancel //user events
    }
}

extension LoginViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch (state, event) {
        default: return state
        }
    }
}

//MARK: feedback for events
extension LoginViewModel {
    static func userInput(_ input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

