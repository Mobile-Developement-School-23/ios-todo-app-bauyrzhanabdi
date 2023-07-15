import ListKit
import Swinject
import UIKit

class TodoListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []

    private var navigationController: UINavigationController
    private let modulesFactory: TodoListModulesFactory

    required init(
        navigationController: UINavigationController,
        assembler: Assembler
    ) {
        self.navigationController = navigationController
        modulesFactory = TodoListModulesFactory(assembler: assembler)
    }

    func start() {
        pushTodoList()
    }

    private func pushTodoList() {
        let todoListViewController = modulesFactory.makeTodoList()
        todoListViewController.didTapAddItem = { [weak self] in
            self?.presentTodoItemDetails(state: .addItem)
        }
        todoListViewController.didTapEditItem = { [weak self] item in
            self?.presentTodoItemDetails(state: .editItem(item))
        }
        navigationController.pushViewController(todoListViewController, animated: false)
    }

    private func presentTodoItemDetails(state: TodoItemDetailsState) {
        let todoItemDetails = modulesFactory.makeTodoItemDetails(state: state)
        todoItemDetails.didTapCancelButton = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        todoItemDetails.didTapSaveButton = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        todoItemDetails.didTapDeletButton = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        navigationController.present(todoItemDetails, animated: true)
    }
}
