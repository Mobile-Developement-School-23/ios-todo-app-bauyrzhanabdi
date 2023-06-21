import XCTest
@testable import ToDoList

final class ToDoListTests: XCTestCase {
    private var item: ToDoItem?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        item = ToDoItem(
            id: "1",
            text: "Do workout",
            importance: .regular,
            deadline: .now + 3,
            isCompleted: true,
            createDate: .now,
            modifyDate: .now + 2
        )
    }

    override func tearDownWithError() throws {
        item = nil
    }

    func testParsing() throws {
        guard let item = item else {
            XCTFail("item not filled")
            return
        }
        
        let json = item.json
        guard let parsedItem = ToDoItem.parse(json: json) else {
            XCTFail("item not parsed")
            return
        }
        
        XCTAssertEqual(item.id, parsedItem.id)
        XCTAssertEqual(item.text, parsedItem.text)
        XCTAssertEqual(item.importance, parsedItem.importance)
        XCTAssertEqual(item.deadline, parsedItem.deadline)
        XCTAssertEqual(item.isCompleted, parsedItem.isCompleted)
        XCTAssertEqual(item.createDate, parsedItem.createDate)
        XCTAssertEqual(item.modifyDate, parsedItem.modifyDate)
    }
    
    func testSaving() {
        guard let item = item else {
            XCTFail("item not filled")
            return
        }
        
        let cache = FileCache()
        cache.addTask(item: item)
        
        do {
            let saveResult = try cache.saveTasks()
            XCTAssertTrue(saveResult)
        } catch {
            XCTFail("Error")
        }
    }
    
    func testLoading() {
        guard let item = item else {
            XCTFail("item not filled")
            return
        }
        
        let cache = FileCache()
        cache.addTask(item: item)
        
        do {
            let saveResult = try cache.saveTasks()
            let loadResult = try cache.loadTasks()
            XCTAssertTrue(loadResult)
        } catch {
            XCTFail("Error")
        }
    }
}
