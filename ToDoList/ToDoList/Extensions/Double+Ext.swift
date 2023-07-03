import Foundation

public extension Double {
    public var toDate: Date {
        Date(timeIntervalSince1970: self)
    }
}
