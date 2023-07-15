import Foundation

public final class DataTaskHolder: @unchecked Sendable {
    public enum State {
        case empty
        case processing(URLSessionDataTask)
        case cancelled
    }
    
    private var state: State = .empty
    private var mutex = NSLock()
    
    public func store(_ dataTask: URLSessionDataTask) -> Bool {
        return mutex.withLock {
            switch state {
            case .empty:
                state = .processing(dataTask)
                return true
            case .processing:
                assertionFailure()
                return false
            case .cancelled:
                return false
            }
        }
    }
    
    public func cancel() {
        return mutex.withLock {
            switch state {
            case .empty:
                state = .cancelled
            case let .processing(dataTask):
                dataTask.cancel()
                state = .cancelled
            case .cancelled:
                break
            }
        }
    }
}
