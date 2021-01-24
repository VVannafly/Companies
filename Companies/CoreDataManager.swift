//
//  CoreDataManager.swift
//  Companies
//
//  Created by Dmitriy Chernov on 24.01.2021.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    public init() { }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Companies")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
