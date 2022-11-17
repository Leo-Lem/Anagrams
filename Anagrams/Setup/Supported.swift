//
//  Language.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 15.01.22.
//

import Foundation

//MARK: supported languages
typealias Language = SupportedLanguage
enum SupportedLanguage: String, CaseIterable, Codable {
    case english = "en",
         german = "de",
         spanish = "es",
         french = "fr"
}

typealias Mode = SupportedModes
enum SupportedModes: CaseIterable, Codable {
    case single //TODO: implement more modes
}
