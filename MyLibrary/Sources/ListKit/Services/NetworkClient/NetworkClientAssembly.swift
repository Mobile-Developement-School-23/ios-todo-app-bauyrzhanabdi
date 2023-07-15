import Alamofire
import Foundation
import Swinject

public struct NetworkClientAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(NetworkClient.self) { _ in
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 15
            
            let session = Session(configuration: configuration)
            
            return NetworkClientImpl(session: session)
        }.inObjectScope(.weak)
    }
}
