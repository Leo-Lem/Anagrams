//
//  Handler.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 06.01.22.
//

import CoreData

class Manager {
    let model: Model
    init(model: Model) { self.model = model }
    func updateViews() { model.objectWillChange.send() }
    
    var persistence: PersistenceController { model.persistence }
    var viewContext: NSManagedObjectContext { model.persistence.container.viewContext }
}
