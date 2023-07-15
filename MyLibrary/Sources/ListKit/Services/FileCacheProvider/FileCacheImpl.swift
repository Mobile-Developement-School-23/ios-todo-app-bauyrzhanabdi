import Alamofire
import CoreData
import Foundation
import Promises

final class FileCacheImpl {
    private(set) var items: [TodoItem] = [] {
        didSet {
            guard items != oldValue else {
                return
            }

            fileCacheProviderObservers.notify {
                $0.fileCacheProvider(self, didChangeTodoItems: items)
            }
            saveInCoreData()
//            saveInSQLite()
        }
    }

    private var revision: Int?
    
    private let fileCacheProviderObservers = ObserversContainer<FileCacheProviderObserver>()

    private let networkClient: NetworkClient
    private let coreDataStorage: CoreDataStorage
    private let sqliteDataStorage: SQLiteDataStorage

    required init(
        networkClient: NetworkClient,
        coreDataStorage: CoreDataStorage,
        sqliteDataStorage: SQLiteDataStorage
    ) {
        self.networkClient = networkClient
        self.coreDataStorage = coreDataStorage
        self.sqliteDataStorage = sqliteDataStorage
    }

    private func insertItem(item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }

    private func saveInCoreData() {
        for item in items {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItemEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", item.id)
            
            do {
                let result = try coreDataStorage.context.fetch(fetchRequest)
                if let existingObject = result.first as? TodoItemEntity {
                    existingObject.configureProperties(with: item)
                } else {
                    let newObject = TodoItemEntity(context: coreDataStorage.context)
                    newObject.configureProperties(with: item)
                }
            } catch {
                fatalError("Failed to fetch Core Data objects: \(error)")
            }
        }
        
        coreDataStorage.saveRecords()
    }
    
    private func saveInSQLite() {
        sqliteDataStorage.saveItems(items: items)
    }
    
    private func loadFromCoreData() {
        let fetchedRecords: [TodoItemEntity] = coreDataStorage.getRecords(
            entityName: "TodoItemEntity"
        )
        
        items = fetchedRecords.map { $0.makeTodoItem() }
    }
    
    private func loadFromSQLite() {
        items = sqliteDataStorage.getRecords()
    }
    
    private func addRecordToCoreData(with item: TodoItem) {
        let fetchedRecords: [TodoItemEntity] = coreDataStorage.getRecords(
            entityName: "TodoItemEntity"
        )
        
        guard !fetchedRecords.contains(where: { $0.id == item.id }) else {
            return
        }
        
        let newRecord = TodoItemEntity(context: coreDataStorage.context)
        newRecord.configureProperties(with: item)
        coreDataStorage.addRecord(newRecord)
    }
    
    private func addRecordToSQLite(with item: TodoItem) {
        sqliteDataStorage.addRecord(with: item)
    }
    
    private func updateRecordInCoreData(with item: TodoItem) {
        let fetchedRecords: [TodoItemEntity] = coreDataStorage.getRecords(
            entityName: "TodoItemEntity"
        )
        
        fetchedRecords.first(where: { $0.id == item.id })?.configureProperties(with: item)
        coreDataStorage.updateRecord()
    }
    
    private func updateRecordInSQLite(with item: TodoItem) {
        sqliteDataStorage.updateRecord(with: item)
    }
    
    private func deleteRecordFromCoreData(with id: String) {
        let fetchedRecords: [TodoItemEntity] = coreDataStorage.getRecords(
            entityName: "TodoItemEntity"
        )
        
        guard let record = fetchedRecords.first(where: { $0.id == id }) else {
            return
        }
        
        coreDataStorage.deleteRecord(record)
    }
    
    private func deleteRecordFromSQLite(with id: String) {
        guard let item = items.first(where: { $0.id == id }) else {
            return
        }
        
        sqliteDataStorage.deleteRecord(with: item)
    }
}

extension FileCacheImpl: FileCacheProvider {
    public func addObserver(_ observer: FileCacheProviderObserver) {
        fileCacheProviderObservers.add(observer)
    }

    public func removeObserver(_ observer: FileCacheProviderObserver) {
        fileCacheProviderObservers.remove(observer)
    }

    public func getItems() -> Promise<Empty> {
        let headers: HTTPHeaders = [HTTPHeader.authToken()]
        let promise: Promise<TodoListResponse> = networkClient.get("/list/", headers: headers)

        return promise.then { [weak self] in
            guard let self else {
                return
            }
            
            self.revision = $0.revision
            self.items = $0.list
        }.then {
            return Promise(Empty.value)
        }.catch { [weak self] _ in
            self?.loadFromCoreData()
//            self?.loadFromSQLite()
        }
    }

    @discardableResult
    public func addItem(item: TodoItem) -> Promise<Empty> {
        var headers: HTTPHeaders = [
            HTTPHeader.authToken()
        ]
        
        if let revision {
            headers.add(HTTPHeader.revision(revision.description))
        }
        
        let promise: Promise<TodoItemResponse> = networkClient.post(
            "/list/",
            parameters: TodoItemRequest(element: item),
            headers: headers
        )

        return promise.then { [weak self] in
            guard let self else {
                return
            }
            
            self.revision = $0.revision
            self.insertItem(item: $0.element)
        }.then {
            return Promise(Empty.value)
        }.catch { [weak self] _ in
            self?.insertItem(item: item)
            self?.addRecordToCoreData(with: item)
//            self?.addRecordToSQLite(with: item)
        }
    }
    
    @discardableResult
    public func updateItem(item: TodoItem) -> Promise<Empty> {
        var headers: HTTPHeaders = [
            HTTPHeader.authToken()
        ]
        
        if let revision {
            headers.add(HTTPHeader.revision(revision.description))
        }

        let promise: Promise<TodoItemResponse> = networkClient.put(
            "/list/\(item.id)",
            parameters: TodoItemRequest(element: item),
            headers: headers
        )

        return promise.then { [weak self] in
            guard let self else {
                return
            }
            
            self.revision = $0.revision
            self.insertItem(item: $0.element)
        }.then {
            return Promise(Empty.value)
        }.catch { [weak self] _ in
            self?.insertItem(item: item)
            self?.updateRecordInCoreData(with: item)
//            self?.updateRecordInSQLite(with: item)
        }
    }

    @discardableResult
    public func removeItem(with id: String) -> Promise<Empty> {
        var headers: HTTPHeaders = [
            HTTPHeader.authToken()
        ]
        
        if let revision {
            headers.add(HTTPHeader.revision(revision.description))
        }

        let promise: Promise<TodoItemResponse> = networkClient.delete(
            "/list/\(id)",
            headers: headers
        )

        return promise.then { [weak self] response in
            guard let self else {
                return
            }
            
            self.revision = response.revision
            self.items.removeAll {
                $0.id == response.element.id
            }
        }.then {
            return Promise(Empty.value)
        }.catch { [weak self] _ in
            self?.items.removeAll {
                $0.id == id
            }
            self?.deleteRecordFromCoreData(with: id)
//            self?.deleteRecordFromSQLite(with: id)
        }
    }
}

extension Array where Element == TodoItem {
    mutating func setElementsDirty(_ isDirty: Bool) {
        self = map {
            var item = $0
            item.isDirty = isDirty
            return item
        }
    }
}
