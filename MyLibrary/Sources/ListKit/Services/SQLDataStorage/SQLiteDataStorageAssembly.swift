import Swinject

public struct SQLiteDataStorageAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(SQLiteDataStorage.self) { r in
            return SQLiteDataStorageImpl()
        }.inObjectScope(.weak)
    }
}
