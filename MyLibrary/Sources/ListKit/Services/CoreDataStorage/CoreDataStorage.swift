import CoreData

public protocol CoreDataStorage: AnyObject {
    var context: NSManagedObjectContext { get }
    
    func saveRecords()
    func getRecords<T: NSManagedObject>(entityName: String) -> [T]
    func addRecord<T: NSManagedObject>(_ record: T)
    func updateRecord()
    func deleteRecord<T: NSManagedObject>(_ record: T)
}
