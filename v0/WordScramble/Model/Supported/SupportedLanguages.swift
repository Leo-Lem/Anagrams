//
//  SupportedLanguages.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import Foundation

//MARK: supported languages
typealias Language = Model.SupportedLanguage
extension Model {
    enum SupportedLanguage: String, CaseIterable, Codable {
        case english = "en",
             german = "de",
             spanish = "es",
             french = "fr"
    }
}
