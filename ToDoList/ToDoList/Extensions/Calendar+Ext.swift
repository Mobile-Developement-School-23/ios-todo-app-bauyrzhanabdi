import UIKit

extension Calendar {
    static var iso8601Calendar: Calendar {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "ru")
        return calendar
    }
}
