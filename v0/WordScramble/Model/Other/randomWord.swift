//
//  randomWord.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 07.01.22.
//

import Foundation

func getRandomWord(language: Language) -> String {
    enum FetchingError: Error { case file, data, decoding }
    do {
        guard let url = Bundle.main.url(forResource: "start-\(language.rawValue)", withExtension: "json") else { throw FetchingError.file }
        guard let data = try? Data(contentsOf: url) else { throw FetchingError.data }
        guard let decoded = try? JSONDecoder().decode([String].self, from: data) else { throw FetchingError.decoding}
        
        return decoded.randomElement() ?? "universal"
    } catch {
        print("Error: Couldn't retrieve start words.")
        return "universal"
    }
}
