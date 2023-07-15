import Swinject

public struct FileCacheAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(FileCacheProvider.self) { r in
            return FileCacheImpl(
                networkClient: r.resolve(NetworkClient.self)!,
                coreDataStorage: r.resolve(CoreDataStorage.self)!,
                sqliteDataStorage: r.resolve(SQLiteDataStorage.self)!
            )
        }.inObjectScope(.weak)
    }
}
