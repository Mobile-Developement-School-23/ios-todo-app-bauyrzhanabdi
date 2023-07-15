import Foundation
import SQLite3

public final class SQLiteDataStorageImpl: SQLiteDataStorage {
    enum Constants {
        static let databasePath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("database.sqlite").absoluteString

        static let createTableQuery = """
        CREATE TABLE IF NOT EXISTS TodoItems (
            id TEXT PRIMARY KEY,
            text TEXT,
            importance TEXT,
            deadline TEXT,
            done INTEGER,
            createdAt TEXT,
            changedAt TEXT,
            color TEXT,
            lastUpdatedBy TEXT
        );
        """
    }
    
    private var db: OpaquePointer?
    
    public init() {
        if sqlite3_open(Constants.databasePath, &db) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error opening database: \(errorMessage)")
        }
        
        if sqlite3_exec(db, Constants.createTableQuery, nil, nil, nil) == SQLITE_OK {
            print("Successfully created table.")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error creating table: \(errorMessage)")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    public func saveItems(items: [TodoItem]) {
        let selectQuery = "SELECT id FROM TodoItems WHERE id = ?;"
        let insertQuery = """
            INSERT INTO TodoItems (id, text, importance, deadline, done, createdAt, changedAt)
            VALUES (?, ?, ?, ?, ?, ?, ?);
            """
        let updateQuery = """
            UPDATE TodoItems
            SET text = ?, importance = ?, deadline = ?, done = ?, createdAt = ?, changedAt = ?
            WHERE id = ?;
            """
        
        var selectStatement: OpaquePointer?
        var insertStatement: OpaquePointer?
        var updateStatement: OpaquePointer?
        
        for item in items {
            if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(selectStatement, 1, item.id, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                
                if sqlite3_step(selectStatement) == SQLITE_ROW {
                    // Record already exists, perform update
                    print("Record already exists, performing update.")
                    if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
                        sqlite3_bind_text(updateStatement, 1, item.text, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                        sqlite3_bind_text(updateStatement, 2, item.importance.rawValue, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                        sqlite3_bind_text(updateStatement, 3, item.deadline?.timeIntervalSince1970.description ?? "NULL", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                        sqlite3_bind_int(updateStatement, 4, item.done ? 1 : 0)
                        sqlite3_bind_text(updateStatement, 5, item.createdAt.timeIntervalSince1970.description, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                        sqlite3_bind_text(updateStatement, 6, item.changedAt.timeIntervalSince1970.description, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                        sqlite3_bind_text(updateStatement, 7, item.id, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                        
                        if sqlite3_step(updateStatement) == SQLITE_DONE {
                            print("Successfully updated record.")
                        } else {
                            let errorMessage = String(cString: sqlite3_errmsg(db))
                            print("Error updating record: \(errorMessage)")
                        }
                        
                        sqlite3_finalize(updateStatement)
                    }
                } else {
                    // Record doesn't exist, perform insert
                    print("Record doesn't exist, performing insert.")
                    if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
                        sqlite3_bind_text(insertStatement, 1, item.id, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                        sqlite3_bind_text(insertStatement, 2, item.text, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                        sqlite3_bind_text(insertStatement, 3, item.importance.rawValue, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                        sqlite3_bind_int(insertStatement, 4, Int32(item.deadline?.timeIntervalSince1970 ?? 0))
                        sqlite3_bind_int(insertStatement, 5, item.done ? 1 : 0)
                        sqlite3_bind_int(insertStatement, 6, Int32(item.createdAt.timeIntervalSince1970))
                        sqlite3_bind_int(insertStatement, 7, Int32(item.changedAt.timeIntervalSince1970))
                        
                        if sqlite3_step(insertStatement) == SQLITE_DONE {
                            print("Successfully inserted record.")
                        } else {
                            let errorMessage = String(cString: sqlite3_errmsg(db))
                            print("Error inserting record: \(errorMessage)")
                        }
                        
                        sqlite3_finalize(insertStatement)
                    }
                }
                
                sqlite3_finalize(selectStatement)
            }
        }
    }
    
    public func getRecords() -> [TodoItem] {
        var records: [TodoItem] = []
        
        let selectQuery = "SELECT id, text, importance, deadline, done, createdAt, changedAt, color, lastUpdatedBy FROM TodoItems;"
        
        var selectStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                let id = String(cString: sqlite3_column_text(selectStatement, 0))
                let text = String(cString: sqlite3_column_text(selectStatement, 1))
                let importance = String(cString: sqlite3_column_text(selectStatement, 2))
                let deadline = sqlite3_column_type(selectStatement, 3) != SQLITE_NULL ? String(cString: sqlite3_column_text(selectStatement, 7)) : nil
                let done = Int(sqlite3_column_int(selectStatement, 4))
                let createdAt = Int(sqlite3_column_int(selectStatement, 5))
                let changedAt = Int(sqlite3_column_int(selectStatement, 6))
                let color = sqlite3_column_type(selectStatement, 7) != SQLITE_NULL ? String(cString: sqlite3_column_text(selectStatement, 7)) : nil
                let lastUpdatedBy = String(cString: sqlite3_column_text(selectStatement, 8))
                let item = TodoItem(
                    id: id,
                    text: text,
                    importance: TodoItem.Importance.init(rawValue: importance) ?? .basic,
                    deadline: deadline != nil ? Date(timeIntervalSince1970: TimeInterval(Int(deadline!)!)) : nil,
                    done: done == 0 ? false : true,
                    createdAt: Date(timeIntervalSince1970: TimeInterval(createdAt)),
                    changedAt: Date(timeIntervalSince1970: TimeInterval(changedAt)),
                    color: color,
                    lastUpdatedBy: lastUpdatedBy
                )
                records.append(item)
            }
            
            sqlite3_finalize(selectStatement)
        }
        
        return records
    }
    
    public func addRecord(with item: TodoItem) {
        let selectQuery = "SELECT id FROM TodoItems WHERE id = ?;"
        let insertQuery = item.insertQuery

        var selectStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(selectStatement, 1, item.id, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))

            if sqlite3_step(selectStatement) == SQLITE_ROW {
                // Record already exists, perform update
                print("Record already exists, performing update.")
            } else {
                // Record doesn't exist, perform insert
                print("Record doesn't exist, performing insert.")
                if sqlite3_exec(db, insertQuery, nil, nil, nil) == SQLITE_OK {
                    print("Successfully inserted or updated record.")
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("Error inserting or updating record: \(errorMessage)")
                }
            }

            sqlite3_finalize(selectStatement)
        }
    }

    public func updateRecord(with item: TodoItem) {
        let updateQuery = item.updateQuery

        if sqlite3_exec(db, updateQuery, nil, nil, nil) == SQLITE_OK {
            print("Successfully updated record.")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error updating record: \(errorMessage)")
        }
    }
    
    public func deleteRecord(with item: TodoItem) {
        let deleteQuery = item.deleteQuery

        if sqlite3_exec(db, deleteQuery, nil, nil, nil) == SQLITE_OK {
            print("Successfully deleted record.")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error deleting record: \(errorMessage)")
        }
    }
}
