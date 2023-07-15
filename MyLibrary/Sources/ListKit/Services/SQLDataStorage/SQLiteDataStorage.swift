import SQLite3

public protocol SQLiteDataStorage: AnyObject {
    func saveItems(items: [TodoItem])
    func getRecords() -> [TodoItem]
    func addRecord(with item: TodoItem)
    func updateRecord(with item: TodoItem)
    func deleteRecord(with item: TodoItem)
}
