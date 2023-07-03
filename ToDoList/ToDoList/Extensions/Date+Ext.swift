import Foundation

public extension Date {
    public var simplified: Double {
        Double(self.timeIntervalSince1970)
    }
}
