import CocoaLumberjackSwift
import ListKit

final class ThirdPartyLibrariesAppDelegeateConfigurator: AppDelegateConfigurator {
    private let fileLogger: DDFileLogger = .init()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupLogger()
        
        return true
    }
    
    private func setupLogger() {
        DDLog.add(DDOSLogger.sharedInstance)
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger, with: .info)
    }
}
