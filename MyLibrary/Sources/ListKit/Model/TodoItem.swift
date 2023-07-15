import Foundation
import UIKit

// MARK: - TodoItem

public struct TodoItem: Equatable, Hashable {
    public let id: String
    public var text: String
    public var importance: Importance
    public var deadline: Date?
    public var done: Bool
    public var createdAt: Date
    public var changedAt: Date
    public var color: HEX?
    public let lastUpdatedBy: String

    public var isDirty = false

    public init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .basic,
        deadline: Date? = nil,
        done: Bool = false,
        createdAt: Date = Date(),
        changedAt: Date = Date(),
        color: HEX? = nil,
        lastUpdatedBy: String = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.done = done
        self.createdAt = createdAt
        self.changedAt = changedAt
        self.color = color
        self.lastUpdatedBy = lastUpdatedBy
    }
}

extension TodoItem: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case done
        case createdAt
        case changedAt
        case color
        case lastUpdatedBy
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        importance = try container.decode(Importance.self, forKey: .importance)
        
        if let deadlineTimestamp = try container.decodeIfPresent(Int.self, forKey: .deadline) {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineTimestamp))
        }
        
        done = try container.decode(Bool.self, forKey: .done)
        let createdAtTimestamp = try container.decode(Int.self, forKey: .createdAt)
        createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimestamp))
        let changedAtTimestamp = try container.decode(Int.self, forKey: .changedAt)
        changedAt = Date(timeIntervalSince1970: TimeInterval(changedAtTimestamp))
        color = try container.decodeIfPresent(HEX.self, forKey: .color)
        lastUpdatedBy = try container.decode(String.self, forKey: .lastUpdatedBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(importance, forKey: .importance)
        
        if let deadline {
            let deadlineTimestamp = Int(deadline.timeIntervalSince1970)
            try container.encode(deadlineTimestamp, forKey: .deadline)
        }
        
        try container.encode(done, forKey: .done)
        let createdAtTimestamp = Int(createdAt.timeIntervalSince1970)
        try container.encode(createdAtTimestamp, forKey: .createdAt)
        let changedAtTimestamp = Int(changedAt.timeIntervalSince1970)
        try container.encode(changedAtTimestamp, forKey: .changedAt)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encode(lastUpdatedBy, forKey: .lastUpdatedBy)
    }
}

// MARK: - TodoItem.Importance

public extension TodoItem {
    enum Importance: String, CaseIterable, Codable {
        case low
        case basic
        case important
    }
}

public extension TodoItem {
    var insertQuery: String {
        return """
            INSERT OR REPLACE INTO TodoItems (id, text, importance, deadline, done, createdAt, changedAt, color, lastUpdatedBy)
            VALUES ('\(id)', '\(text)', '\(importance)', \((deadline?.timeIntervalSince1970.description) ?? "NULL"), \(done ? 1 : 0), \(createdAt.timeIntervalSince1970.description), \(changedAt.timeIntervalSince1970.description), \(color != nil ? "'\(color!)'" : "NULL"), '\(lastUpdatedBy)');
            """
    }
    
    var updateQuery: String {
        return """
            UPDATE TodoItems
            SET text = '\(text)', importance = '\(importance)', deadline = \((deadline?.timeIntervalSince1970.description) ?? "NULL"),
            done = \(done ? 1 : 0), createdAt = \(createdAt.timeIntervalSince1970.description), changedAt = \(changedAt.timeIntervalSince1970.description),
            color = \(color != nil ? "'\(color!)'" : "NULL"), lastUpdatedBy = '\(lastUpdatedBy)'
            WHERE id = '\(id)';
            """
    }
    
    var deleteQuery: String {
        return """
            DELETE FROM TodoItems WHERE id = '\(id)';
            """
    }
}
