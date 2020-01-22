import XCTest
@testable import DataPersistence

struct Person: Codable, Equatable {
  let name: String
  let age: Int
}

final class DataPersistenceTests: XCTestCase {
  
  let dataPersistence = DataPersistence<Person>(filename: "podcasts.plist")
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
    try? dataPersistence.createItem(person)
    
    let results = try? dataPersistence.loadItems()
    
    // assert
    XCTAssertEqual(results?.first?.name, expectedName)
  }
  
  func NOT_WORKING_testNoDuplicateSaving() {
    // arrange
    let expectedCount = 1
    
    // act
    try? dataPersistence.createItem(person)
    try? dataPersistence.createItem(person)
    try? dataPersistence.createItem(person)

    let results = try? dataPersistence.loadItems()
    
    // assert
    XCTAssertEqual(results?.count ?? 0, expectedCount)
  }
  
  func IS_WORKING_testItemHasBeenSaved() {
    // act
    let itemHasBeenSaved = dataPersistence.hasItemBeenSaved(person)
    
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
  
  func IS_WORKING_testDeleteItem() {
    // arrange
    let itemIndex = try? dataPersistence.loadItems().firstIndex { $0 == person }
    guard let index = itemIndex else {
      XCTFail("fail to delete index not found")
      return
    }
    
    // act
    try? dataPersistence.deleteItem(at: index)
    
    // assert
    XCTAssertEqual(dataPersistence.hasItemBeenSaved(person), false)
  }
}
