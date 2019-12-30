import XCTest
@testable import DataPersistence

struct Person: Codable, Equatable {
  let name: String
  let age: Int
}

final class DataPersistenceTests: XCTestCase {
  
  let dataPersistence = DataPersistence<Person>()
  let person = Person(name: "John Appleseed", age: 32)
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testSaveItem() {
    // arrange
    let expectedName = "John Appleseed"
    
    // act
    dataPersistence.save(item: person)
    
    let results = try? dataPersistence.loadItems()
    
    // assert
    XCTAssertEqual(results?.first?.name, expectedName)
  }
  
  func testItemHasBeenSaved() {
    // act
    let itemHasBeenSaved = dataPersistence.hasItemBeenSaved(item: person)
    
    // assert
    XCTAssertEqual(itemHasBeenSaved, true)
  }
  
  func testRemoveAllItems() {
    // act
    dataPersistence.removeAll()
    let items = try? dataPersistence.loadItems()
    
    // assert
    XCTAssertEqual(items?.count ?? 0, 0)
  }
}
