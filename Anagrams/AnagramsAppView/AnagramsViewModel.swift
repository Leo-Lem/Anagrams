//
//  AnagramsViewModel.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 14.01.22.
//

import Foundation
import Combine
import CombineFeedback

final class AnagramsViewModel: ObservableObject {
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
        
        //online = ConnectionManager.publisher()
            //.sink { self.send(event: .onConnectionChange($0 == .on, false)) }
    }
    
    deinit { bag.removeAll() }
    func send(event: Event) { input.send(event) }
}

extension AnagramsViewModel {
    enum State {
        case idle,
             //loggingIn,
             game
             //board
    }
    
    enum Event {
        case onAppear
             //onConnectionChange(_ online: Bool, _ auth: Bool),
             //onLogin(_ auth: Bool) //background actions
        case onClickLogin, onClickBoard //user actions
    }
}

extension AnagramsViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch (state, event) {
        case (.idle, .onAppear):
            return .game
        default: return state
        }
    }
}

//MARK: feedback for events
extension AnagramsViewModel {
    static func userInput(_ input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        return Feedback { _ in input }
    }
}
