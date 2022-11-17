//
//  SingleViewModel.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 16.01.22.
//

import Foundation
import Combine
import MyOthers

final class SingleViewModel: ObservableObject {
    @Published private(set) var state: State
    private var bag = Set<AnyCancellable>()
    private var input = PassthroughSubject<Event, Never>()
    
    init() {
        self.state = .idle
        
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

//MARK: - State and Events
extension SingleViewModel {
    enum State {
        case idle, setup, game(_ settings: Settings)
    }
    
    enum Event {
        //system actions
        case onAppear
        
        //user actions
        case start(_ settings: Settings),
             `continue`,
             save(_ game: Game),
             setup
    }
}

//MARK: - reduce method to manage state and events
extension SingleViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch (state, event) {
        case (.idle, .onAppear): return .setup
        case (_, .start(let settings)):
            return .game(settings)
        case (.game, .save(let game)):
            saveGame(game)
            return state
        case (.game, .setup):
            return .setup
        case (.setup, .continue):
            return .game
        default: return state
        }
    }
}

//MARK: - feedbacks
extension SingleViewModel {
    static func userInput(_ input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
