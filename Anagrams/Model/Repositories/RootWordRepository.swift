//
//  RootWordRepository.swift
//  Anagrams
//
//  Created by Leopold Lemmermann on 16.01.22.
//

import Foundation

class RootWordRepository {
    
    
    static func randomWord(in language: String) -> String {
        let words = loadWords(in: language)
        let random = words.randomElement() ?? "universal"
        
        return random
    }
    
    static func loadWords(in language: String) -> [String] {
        do {
            let words: [String] = try fetchDecodedData(for: language)
            return words
        } catch {
            //TODO: implement some error handling
            print("Error: Couldn't retrieve start words.")
            return []
        }
    }
    
    private static func getFileName(for language: String) -> String { "words-\(language)" }
    private static let fileExtension = "json"
    
    private static func fetchDecodedData<T: Decodable>(for language: String) throws -> T {
        let fileName = getFileName(for: language)
        let url = try getURL(filename: fileName, extension: fileExtension )
        let data = try getData(from: url)
        let decoded: T = try decodeData(data)
        
        return decoded
    }
    
    enum FetchingError: Error { case file, data, decoding }
    //TODO: move all this into a package
    private static func getURL(filename: String, extension: String) throws -> URL {
        guard let url = Bundle.main.url(forResource: filename, withExtension: `extension`) else { throw FetchingError.file }
        
        return url
    }
    
    private static func getData(from url: URL) throws -> Data {
        guard let data = try? Data(contentsOf: url) else { throw FetchingError.data }
        
        return data
    }
    
    private static func decodeData<T: Decodable>(_ data: Data) throws -> T {
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else { throw FetchingError.decoding }
        
        return decoded
    }
}
