//
//  Persistence.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 30.12.21.
//

import Foundation
import CoreData
import CloudKit


struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "AnagramsCD")
        
        guard let desc = container.persistentStoreDescriptions.first else {
            print("#####Couldn't get persistent store description")
            return
        }
        
        desc.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.LeoLem.WordScramble")
        desc.cloudKitContainerOptions?.databaseScope = .public
        desc.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        desc.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.persistentStoreDescriptions = [desc]
        
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print("#####CoreData or CloudKit could not be loaded: \(error)")
            }
        }
        
        //do { try container.initializeCloudKitSchema(options: []) } catch { print("Initializing CK-Container failed: \(error)") }
    }
    
    func saveContext() throws {
        if container.viewContext.hasChanges {
            try container.viewContext.save()
        }
    }
}
