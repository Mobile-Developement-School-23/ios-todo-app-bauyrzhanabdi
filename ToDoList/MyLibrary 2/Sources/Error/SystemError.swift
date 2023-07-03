import Foundation

public enum SystemError: String, Error {
    case jsonParsing = "Could not be parsed"
    case jsonConversion = "Could not be converted into JSON format"
    case saveTask = "Could not be saved into directory"
    case loadTask = "Could not be loaded from directory"
}
