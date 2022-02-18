//
//  StorageManager.swift
//  SpaceImage
//
//  Created by Михаил Иванов on 18.02.2022.
//

import CoreData
import UIKit

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - SpaceLoadObject
    
    func fetchData() -> [SpaceLoadObject] {
        let fetchReRequest = SpaceLoadObject.fetchRequest()
        var spaceLoads: [SpaceLoadObject] = []
        
        do {
            spaceLoads = try viewContext.fetch(fetchReRequest)
        } catch {
            print("Failed to fetch data", error)
        }
        
        return spaceLoads
    }
    
    func saveSpace(_ space: SpaceObject, _ completion: (SpaceLoadObject) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "SpaceLoadObject", in: viewContext) else {
            return
        }
        guard let spaceLoad = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? SpaceLoadObject else {
            return
        }
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let formatteddate = formatter.string(from: date as Date)

        spaceLoad.hdurl = space.hdurl
        spaceLoad.date = space.date
        spaceLoad.title = space.title
        spaceLoad.dateLoad = formatteddate
        
        saveContext()
        completion(spaceLoad)
    }
    
    func saveImage(_ space: SpaceLoadObject, imageData: Data) {
        space.image = imageData
        saveContext()
    }
}
