import Foundation
import CoreData

@objc(TodoItemEntity)
public class TodoItemEntity: NSManagedObject {
    public func configureProperties(with item: TodoItem) {
        id = item.id
        text = item.text
        importance = item.importance.rawValue
        deadline = item.deadline
        done = item.done
        createdAt = item.createdAt
        changedAt = item.changedAt
        color = item.color
        lastUpdatedBy = item.lastUpdatedBy
    }

    public func makeTodoItem() -> TodoItem {
        TodoItem(
            id: id,
            text: text,
            importance: TodoItem.Importance.init(rawValue: self.importance) ?? .basic,
            deadline: deadline,
            done: done,
            createdAt: createdAt,
            changedAt: changedAt,
            color: color,
            lastUpdatedBy: lastUpdatedBy
        )
    }
}

extension TodoItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItemEntity> {
        return NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var text: String
    @NSManaged public var importance: String
    @NSManaged public var deadline: Date?
    @NSManaged public var done: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var changedAt: Date
    @NSManaged public var color: String?
    @NSManaged public var lastUpdatedBy: String

}
