import UIKit

extension NSObject {
    static var identifier: String {
        return String(describing: self)
    }
}
