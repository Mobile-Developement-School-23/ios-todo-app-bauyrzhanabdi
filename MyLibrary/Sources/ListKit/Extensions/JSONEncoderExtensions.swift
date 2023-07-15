import Foundation

extension JSONEncoder {
    static var `default`: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }
}
