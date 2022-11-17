//
//  ContentView-VM.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 11.01.22.
//

import Foundation
import MyOthers
import Combine
import Network

final class ContentViewModel: ViewModelProtocol {
    @Published var state = State.idle
    var bag = Set<AnyCancellable>()
    var input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenConnecting(),
                Self.onConnectionChange(),
                Self.feedbackUserInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit { bag.removeAll() }
}

extension ContentViewModel {
    enum State {
        case idle, connecting, loggingIn, inGame(online: Bool), board
    }
    
    enum Event {
        case onAppear, onConnect(_ status: Bool), onConnectionChange(_ status: Bool) //background actions
        case onClickLogin, onClickBoard //user actions
    }
}

extension ContentViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch (state, event) {
        case (.idle, .onAppear): return .connecting
        case (.connecting, .onConnect(let status)):
            return (status ? .loggingIn : .inGame(online: status))
        case (_, .onConnectionChange(let status)): return .inGame(online: status)
        default: return state
        }
    }
}

//MARK: feedback for system events
extension ContentViewModel {
    static func whenConnecting() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .connecting = state else { return Empty().eraseToAnyPublisher() }

            return PersistenceController.initialConnectionStatus
                .map(Event.onConnect)
                .eraseToAnyPublisher()
        }
    }
    
    static func onConnectionChange() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            if case .connecting = state { return Empty().eraseToAnyPublisher() }
                
            return PersistenceController.connectionStatus
                .map(Event.onConnectionChange)
                .eraseToAnyPublisher()
        }
    }
}
