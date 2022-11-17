//
//  main.swift
//  AnagramsAlgorithm
//
//  Created by Leopold Lemmermann on 13.01.22.
//

import Foundation
import MyOthers

//MARK: Parameters
let base = "perfekt", words = getWordList(language: "de")!, length: Int? = nil

//MARK: result printing
var times = [Double]()
var average: Double {
    let sum = times.reduce(0, +)
    return sum / Double(times.count)
}

_ = maxScore()
print(average)

func maxScore() -> (String, Int) {
    let start = Date()
    let words = words.filter { $0.count <= length ?? 100}
    
    var max = ("", 0)
    
    var i = 0
    while i < words.count {
        let new = (words[i], score(words[i]))
        let condition = max.1 < new.1
        
        if condition { print("\(new)".logPadded()) }
        
        if condition { max = new }
        
        i += 1
        if i % 100 == 0 { print("\(Date().timeIntervalSince(start))") }
    }
    
    times.append(Date().timeIntervalSince(start))
    
    return max
}

func noSolveWords() -> [String] {
    let start = Date()
    
    var matches = [String]()
    
    var i = 0
    while i < words.count {
        let condition = score(words[i]) == 0
        
        print(words[i])
        if condition { print("\(words[i])".logPadded()) }
        
        if condition { matches.append(words[i]) }
        i += 1
    }
    
    times.append(Date().timeIntervalSince(start))
    
    return matches
}

func score(_ base: String) -> Int {
    //findPossibilities(base: base, words: words).reduce(0) { $0 + $1.count } //shortest
    //let start = Date()
    
    var score = 0
    
    var i = 0
    let solved = solve(base)
    while i < solved.count {
        score += solved[i].count
        i += 1
    }
    
    //times.append(Date().timeIntervalSince(start))
    
    return score
}

func solve(_ base: String) -> [String] {
    //words.filter { base.extendedContains($0) && $0 != base } //shortest
    //let start = Date()
    var matches = [String]()
    
    var i = 0
    while i < words.count {
        if extContains(base: base, words[i]) { matches.append(words[i]) }
        i += 1
    }
    
    //times.append(Date().timeIntervalSince(start))
    
    return matches
}

private func extContains(base: String, _ other: String) -> Bool {
    let start = Date()
    var word = base
    
    for char in other {
        if let index = word.firstIndex(of: char) {
            word.remove(at: index)
        } else { return false }
    }
    
    times.append(Date().timeIntervalSince(start))
    
    return true
}

private func getWordList(language: String) -> [String]? {
    let url = URL(fileURLWithPath: "/Users/leolem/Library/Mobile Documents/com~apple~CloudDocs/Projects/Development/iOS/Anagrams Project/AnagramsAlgorithm/AnagramsAlgorithm/word-lists/words-\(language).json")
    let data = try? Data(contentsOf: url)
    let decoded = try? JSONDecoder().decode([String].self, from: data!)
    
    return decoded
}
