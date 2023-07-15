import Foundation

public struct TodoItemResponse: Decodable {
    public let status: String
    public let element: TodoItem
    public let revision: Int
}
