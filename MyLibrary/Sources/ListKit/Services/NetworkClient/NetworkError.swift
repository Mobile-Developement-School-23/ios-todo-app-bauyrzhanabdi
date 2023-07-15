import Foundation

// MARK: - NetworkError

public struct NetworkError {
    public enum Kind {
        case `default`
        case `internal`
    }

    public let kind: Kind
    public let message: String

    public init(kind: Kind, message: String) {
        self.kind = kind
        self.message = message
    }
}

// MARK: - LocalizedError

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        message
    }
}
