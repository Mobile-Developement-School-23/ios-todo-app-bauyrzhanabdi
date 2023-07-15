@testable import TodoListProject
import XCTest

class TodoItemTests: XCTestCase {
    var sut: TodoItem?

    func testItemFromJSON() {
        let json = """
        {
            "id" : "123",
            "text" : "Сходить в аптеку",
            "isCompleted" : false,
            "createDate" : "12.05.2023 - 21:00:30"
        }
        """

        guard
            let jsonData = json.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
            let todoItem = TodoItem.parse(json: jsonObject)
        else {
            XCTFail("Failed to parse JSON")
            return
        }

        XCTAssertEqual(todoItem.id, "123")
        XCTAssertEqual(todoItem.text, "Сходить в аптеку")
        XCTAssertEqual(todoItem.priority, .medium)
        XCTAssertNil(todoItem.deadline)
        XCTAssertEqual(todoItem.isCompleted, false)
        XCTAssertNotNil(todoItem.createDate)
        XCTAssertNil(todoItem.updateDate)

        guard
            let jsonDict = todoItem.json as? [String: Any],
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted),
            let string = String(data: jsonData, encoding: .utf8),
            let data = string.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let todoItem = TodoItem.parse(json: jsonObject)
        else {
            XCTFail("Failed to parse JSON")
            return
        }

        XCTAssertEqual(todoItem.id, "123")
        XCTAssertEqual(todoItem.text, "Сходить в аптеку")
        XCTAssertEqual(todoItem.priority, .medium)
        XCTAssertNil(todoItem.deadline)
        XCTAssertEqual(todoItem.isCompleted, false)
        XCTAssertNotNil(todoItem.createDate)
        XCTAssertNil(todoItem.updateDate)
    }

    func testItemFromCSV() {
        let csv = "14,Купить продукты,,,FALSE,12.05.2023 - 21:00:30,12.06.2023 - 21:00:30"

        guard
            let todoItem = TodoItem.parse(csv: csv)
        else {
            XCTFail("Failed to parse CSV")
            return
        }

        XCTAssertEqual(todoItem.id, "14")
        XCTAssertEqual(todoItem.text, "Купить продукты")
        XCTAssertEqual(todoItem.priority, .medium)
        XCTAssertNil(todoItem.deadline)
        XCTAssertEqual(todoItem.isCompleted, false)
        XCTAssertNotNil(todoItem.createDate)
        XCTAssertNotNil(todoItem.updateDate)

        XCTAssertEqual(todoItem.csv, "14,Купить продукты,,,FALSE,12.05.2023 - 21:00:30,12.06.2023 - 21:00:30")
    }
}
