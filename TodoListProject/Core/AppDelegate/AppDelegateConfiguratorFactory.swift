import ListKit
import Swinject

final class AppDelegateConfiguratorFactory {
    static func makeConfigurator(
        assembler: Assembler,
        configurators: [AppDelegateConfigurator] = []
    ) -> AppDelegateConfigurator {
        let defaultConfigurators: [AppDelegateConfigurator] = [
            ThirdPartyLibrariesAppDelegeateConfigurator()
        ]
        
        return CompositeAppDelegateConfigurator(
            configurators: [
                defaultConfigurators,
                configurators
            ].flatMap { $0 }
        )
    }
}


