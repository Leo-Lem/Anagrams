//
//  CD-fetchObject.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 08.01.22.
//

import CoreData

public func fetchObject<T: NSManagedObject>(_ object: T, from context: NSManagedObjectContext) -> T {
    guard let contextObject = context.object(with: object.objectID) as? T else {
        context.insert(object)
        return object
    }
    
    return contextObject
}
