import Foundation

public struct TodoListResponse: Decodable {
    public let status: String
    public let list: [TodoItem]
    public let revision: Int
}
