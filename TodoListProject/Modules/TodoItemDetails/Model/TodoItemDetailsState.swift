import ListKit

enum TodoItemDetailsState: Equatable {
    case addItem
    case editItem(TodoItem)
}
