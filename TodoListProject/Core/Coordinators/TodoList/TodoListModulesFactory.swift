import ListKit
import Swinject
import UIKit

final class TodoListModulesFactory {
    private var assembler: Assembler

    init(assembler: Assembler) {
        self.assembler = assembler
    }

    func makeTodoList() -> UIViewController & TodoListOutput {
        let viewController = TodoListViewController(
            fileCache:  assembler.resolver.resolve(FileCacheProvider.self)!
        )
        return viewController
    }

    func makeTodoItemDetails(state: TodoItemDetailsState) -> UIViewController & TodoItemDetailsOutput {
        let viewController = TodoItemDetailsViewController(
            state: state,
            fileCache: assembler.resolver.resolve(FileCacheProvider.self)!
        )
        return viewController
    }
}
