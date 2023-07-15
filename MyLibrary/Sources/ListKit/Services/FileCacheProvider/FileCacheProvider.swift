import Alamofire
import Foundation
import Promises

public protocol FileCacheProviderObserver: AnyObject {
    func fileCacheProvider(_ provider: FileCacheProvider, didChangeTodoItems items: [TodoItem])
}

public protocol FileCacheProvider: AnyObject {
    var items: [TodoItem] { get }
    
    func addObserver(_ observer: FileCacheProviderObserver)
    func removeObserver(_ observer: FileCacheProviderObserver)
    @discardableResult func getItems() -> Promise<Empty>
    @discardableResult func addItem(item: TodoItem) -> Promise<Empty>
    @discardableResult func updateItem(item: TodoItem) -> Promise<Empty>
    @discardableResult func removeItem(with id: String) -> Promise<Empty>
}
