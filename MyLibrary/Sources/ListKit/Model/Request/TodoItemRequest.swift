import Foundation

public struct TodoItemRequest: Encodable {
    public let element: TodoItem
    
    public init(element: TodoItem) {
        self.element = element
    }
}
