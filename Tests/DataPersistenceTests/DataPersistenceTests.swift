import XCTest
@testable import DataPersistence

final class DataPersistenceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DataPersistence().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
