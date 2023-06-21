import Foundation

class FileCache {
    private var items: [String: ToDoItem] = [:]
    private let path: String = "itemsData.json"
    
    func addTask(item: ToDoItem) {
        items[item.id] = item
    }
    
    func removeTask(item: ToDoItem) {
        items.removeValue(forKey: item.id)
    }
    
    func saveTasks() throws -> Bool {
        let items = items.mapValues({ $0.json })
        do {
             let data = try JSONSerialization.data(withJSONObject: items, options: [])
             let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
             let fileURL = documentDirectoryURL.appendingPathComponent(path)
             try data.write(to: fileURL)
             return true
         } catch {
             throw SystemError.saveTask
         }
    }
    
    func loadTasks() throws -> Bool {
        do {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentDirectoryURL.appendingPathComponent("itemsData.json")
            let data = try Data(contentsOf: fileURL)
            let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            guard let object = object else { return false }
            let items = try object.mapValues { json in
                guard let item = ToDoItem.parse(json: json) else { throw SystemError.loadTask }
                return item
            }
            self.items = items
            return true
        } catch {
            throw SystemError.loadTask
        }
    }
}
