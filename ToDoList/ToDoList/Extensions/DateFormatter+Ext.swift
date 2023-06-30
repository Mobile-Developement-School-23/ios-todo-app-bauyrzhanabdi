import UIKit

extension DateFormatter {
    static func format(date: Date, dateFormat: String = "d MMMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ru")
        return formatter.string(from: date)
    }
}
