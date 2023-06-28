import Foundation

extension Date {
    var simplified: Double {
        Double(self.timeIntervalSince1970)
    }
}
