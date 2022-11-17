//
//  Collection-RemoveDuplicates.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 07.01.22.
//

import Foundation
import MyOthers

extension Array where Element: Equatable {
    public mutating func removeDuplicates() {
        self = self.byRemovingDuplicates()
    }
    
    public func byRemovingDuplicates() -> Self {
        var array = self
        
        array = array.reduce([]) { items, nextItem in
            !items.contains(nextItem) ? items + [nextItem] : items
        }
        
        return array
    }
}
