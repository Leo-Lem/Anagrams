//
//  Object Examples.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 03.01.22.
//

import CoreData

extension User {
    static let example = User(name: "Leo", pin: "MyAss123", defaults: Defaults.example)
}

extension Defaults {
    static let example = Defaults(language: .english, timer: true, timelimit: 300, autosave: false)
}

extension Entry {
    static let example = Entry(user: User.example, settings: Settings.example, time: 90, foundWords: [Found.example])
}

extension Settings {
    static let example = Settings(root: RootWord.example, timelimit: 300)
}

extension RootWord {
    static let example = RootWord("universal", language: .english)
}

extension NewWord {
    static let example = NewWord("sail", game: Game.example)
}

extension FoundWord {
    static let example = FoundWord(NewWord.example)
}

extension Game {
    static let example = Game(root: RootWord.example, user: User.example, mode: .single)
}

extension LoginAlert {
    static let example = LoginAlert(.connection)
}

extension RootAlert {
    static let example = RootAlert(.notReal, root: RootWord("chubaguak", language: .german))
}

extension NewAlert {
    static let example = NewAlert(.tooShort, new: NewWord.example)
}
