import XCTest
@testable import DataPersistence

final class DataPersistenceTests: XCTestCase {
  func NOT_WWORKING_testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    //XCTAssertEqual(DataPersistence().text, "Hello, World!")
  }
  
  func testSaveItem() {
    // arrange
    struct Person: Codable, Equatable {
      let name: String
      let age: Int
    }
    
    let person = Person(name: "John Appleseed", age: 32)
    let dataPersistence = DataPersistence<Person>()
    let expectedName = "John Appleseed"
  
    // act
    dataPersistence.save(item: person)
    
    // assert
    let results = try? dataPersistence.loadItems()
    XCTAssertEqual(results?.first?.name, expectedName)
  }
  
  
  static var allTests = [
    ("testSaveItem", testSaveItem),
  ]
}
