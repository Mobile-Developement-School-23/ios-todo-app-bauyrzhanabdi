import Foundation

public extension NSLocking {
    func critical<Result>(_ criticalSection: () throws -> Result) rethrows -> Result {
        lock()
        defer { unlock() }
        return try criticalSection()
    }
}
