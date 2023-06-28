import Foundation

extension Double {
    var toDate: Date {
        Date(timeIntervalSince1970: self)
    }
}
