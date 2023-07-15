import Foundation

public final class ObserversContainer<Observer> {
    public var isEmpty: Bool {
        observers.allObjects.isEmpty
    }

    private let lock: NSLocking
    private let observers: NSHashTable<AnyObject>

    public init() {
        lock = UnfairLock(name: "ObserversContainer")
        observers = .weakObjects()
    }

    public func add(_ observer: Observer) {
        lock.critical {
            guard !unsafeContains(observer) else {
                return
            }

            observers.add(observer as AnyObject)
        }
    }

    public func remove(_ observer: Observer) {
        lock.critical {
            guard unsafeContains(observer) else {
                return
            }

            observers.remove(observer as AnyObject)
        }
    }

    public func notify(with closure: (Observer) -> Void) {
        allObservers().forEach { closure($0) }
    }

    private func unsafeContains(_ observer: Observer) -> Bool {
        observers.contains(observer as AnyObject)
    }

    private func allObservers() -> [Observer] {
        lock.critical { observers.allObjects as! [Observer] } // swiftlint:disable:this force_cast
    }
}
