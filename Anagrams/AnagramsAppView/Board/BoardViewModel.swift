//
//  BoardViewModel.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import Foundation
import Combine
import MyOthers

final class BoardViewModel: ObservableObject {
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

extension BoardViewModel {
    enum State {
        case idle
    }
    
    enum Event {
        case onAppear
    }
}

extension BoardViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch (state, event) {
        default: return state
        }
    }
}

//MARK: feedback for events
extension BoardViewModel {
    static func userInput(_ input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
