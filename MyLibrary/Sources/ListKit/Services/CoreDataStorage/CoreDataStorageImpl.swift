import CoreData

final class CoreDataStorageImpl: CoreDataStorage {
    private lazy var container: NSPersistentContainer? = {
        guard
            let modelURL = Bundle.module.url(
                forResource: "TodoItemDataModel",
                withExtension: "momd"
            )
        else {
            return  nil
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            return nil
        }

        let container = NSPersistentContainer(
            name: "TodoListContainer",
            managedObjectModel: model
        )
        container.loadPersistentStores{ (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return container!.viewContext
    }
    
    func saveRecords() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save Core Data records: \(error)")
            }
        }
    }
    
    func getRecords<T: NSManagedObject>(entityName: String) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            fatalError("Failed to fetch Core Data objects: \(error)")
        }
    }
    
    func addRecord<T: NSManagedObject>(_ record: T) {
        context.insert(record)
        saveRecords()
    }
    
    func updateRecord() {
        saveRecords()
    }
    
    func deleteRecord<T: NSManagedObject>(_ record: T) {
        context.delete(record)
        saveRecords()
    }
}
