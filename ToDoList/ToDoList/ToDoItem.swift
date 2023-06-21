import Foundation

struct ToDoItem {
    private enum Format {
        static let id = "id"
        static let text = "text"
        static let importance = "importance"
        static let deadline = "deadline"
        static let isCompleted = "isCompleted"
        static let createDate = "createDate"
        static let modifyDate = "modifyDate"
    }
    
    enum Importance: String {
        case low = "неважная"
        case regular = "обычная"
        case high = "важная"
    }
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let createDate: Date
    let modifyDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isCompleted: Bool,
        createDate: Date,
        modifyDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createDate = createDate
        self.modifyDate = modifyDate
    }
}

extension ToDoItem {
    var json: Any {
        var object: [String: Any] = [
            Format.id: self.id,
            Format.text: self.text,
            Format.isCompleted: self.isCompleted,
            Format.createDate: self.createDate
        ]
        
        switch importance {
        case .low, .high:
            object[Format.importance] = importance.rawValue
        default:
            break
        }
        
        if let deadline = deadline {
            object[Format.deadline] = deadline.simplified
        }
        
        if let modifyDate = modifyDate {
            object[Format.modifyDate] = modifyDate.simplified
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: object)
            if let json = String(data: data, encoding: .utf8) {
                return json
            }
        } catch {
            print(SystemError.jsonConversion)
        }
        
        return object
    }
    
    static func parse(json: Any) -> ToDoItem? {
        
        do {
            guard
                let object = try JSONSerialization.jsonObject(with: Data((json as! String).utf8)) as? [String: Any],
                let id = object[Format.id] as? String,
                let text = object[Format.text] as? String,
                let isCompleted = object[Format.isCompleted] as? Bool,
                let createDate = (object[Format.createDate] as? Double)?.toDate
            else {
                return nil
                
            }
                        
            var importance: Importance = .regular
            if let rawValue = object[Format.importance] as? String,
               let importanceType = Importance(rawValue: rawValue) {
                importance = importanceType
            }
            
            let deadline = (object[Format.deadline] as? Double)?.toDate
            let modifyDate = (object[Format.modifyDate] as? Double)?.toDate
            
            return ToDoItem(
                id: id,
                text: text,
                importance: importance,
                deadline: deadline,
                isCompleted: isCompleted,
                createDate: createDate,
                modifyDate: modifyDate
            )
        } catch {
            print(SystemError.jsonParsing)
        }
        
        return nil
    }
}
