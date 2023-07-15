import UIKit

public typealias AppDelegateConfigurator = UIResponder & UIApplicationDelegate

public final class CompositeAppDelegateConfigurator: AppDelegateConfigurator {
    private let configurators: [AppDelegateConfigurator]

    public init(configurators: [AppDelegateConfigurator]) {
        self.configurators = configurators
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configurators
            .compactMap { $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
            .allSatisfy { $0 }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        configurators.forEach { $0.applicationDidBecomeActive?(application) }
    }
}
