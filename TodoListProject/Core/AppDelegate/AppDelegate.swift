import ListKit
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var assembler = AssemblerFactory().makeAssembler()

    private lazy var configurator = AppDelegateConfiguratorFactory.makeConfigurator(
        assembler: assembler
    )

    private var todoListCoordinator: TodoListCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupWindow()

        let result = configurator.application?(application, didFinishLaunchingWithOptions: options) ?? false
        runTodoListFlow()
        return result
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        configurator.applicationDidBecomeActive?(application)
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController()
        window?.makeKeyAndVisible()
    }

    private func runTodoListFlow() {
        guard
            let navigationController = window?.rootViewController as? UINavigationController
        else {
            return
        }

        todoListCoordinator = TodoListCoordinator(
            navigationController: navigationController,
            assembler: assembler
        )
        todoListCoordinator?.start()
    }
}
