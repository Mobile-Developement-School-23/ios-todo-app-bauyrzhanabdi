import Swinject
import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }

    init(
        navigationController: UINavigationController,
        assembler: Assembler
    )

    func start()
}
