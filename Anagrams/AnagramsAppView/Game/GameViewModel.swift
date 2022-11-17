//
//  GameViewModel.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import Foundation
import Combine
import MyOthers

final class GameViewModel: ObservableObject {
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

extension GameViewModel {
    enum State {
        case idle, menu, single //more coming
    }
    
    enum Event {
        case onAppear, onSelectMode(_ mode: Mode)
    }
}

extension GameViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch (state, event) {
        case (.idle, .onAppear): return .menu
        case (.menu, .onSelectMode(let mode)):
            switch mode {
            case .single: return .single
            }
        default: return state
        }
    }
}

//MARK: feedback for events
extension GameViewModel {
    static func userInput(_ input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
