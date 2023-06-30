import UIKit

extension DateComponents {
    static func defaultDate(_ defaultDeadline: Date) -> DateComponents {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: defaultDeadline
        )
        return dateComponents
    }
}
