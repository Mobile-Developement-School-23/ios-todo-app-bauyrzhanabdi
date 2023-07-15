import Swinject

public struct CoreDataStorageAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(CoreDataStorage.self) { r in
            return CoreDataStorageImpl()
        }.inObjectScope(.weak)
    }
}
