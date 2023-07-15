import Swinject

public final class AssemblerFactory {
    public init() {}

    public func makeAssembler() -> Assembler {
        Assembler(makeCoreServicesAssemblies())
    }

    private func makeCoreServicesAssemblies() -> [Assembly] {
        [
            NetworkClientAssembly(),
            SQLiteDataStorageAssembly(),
            CoreDataStorageAssembly(),
            FileCacheAssembly()
        ]
    }
}
