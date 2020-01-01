import XCTest
@testable import DataPersistence

struct Person: Codable, Equatable {
  let name: String
  let age: Int
}

final class DataPersistenceTests: XCTestCase {
  
  let dataPersistence = DataPersistence<Person>(with: "podcasts")
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
  
  func testNoDuplicateSaving() {
    // arrange
    let expectedCount = 1
    
    // act
    dataPersistence.save(item: person)
    dataPersistence.save(item: person)
    dataPersistence.save(item: person)
    
    let results = try? dataPersistence.loadItems()
    
    // assert
    XCTAssertEqual(results?.count ?? 0, expectedCount)
  }
  
  func IS_WORKING_testItemHasBeenSaved() {
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
  
  func IS_WORKING_testDeleteItem() {
    // arrange
    let itemIndex = try? dataPersistence.loadItems().firstIndex { $0 == person }
    guard let index = itemIndex else {
      XCTFail("fail to delete index not found")
      return
    }
    
    // act
    dataPersistence.delete(index: index)
    
    // assert
    XCTAssertEqual(dataPersistence.hasItemBeenSaved(item: person), false)
  }
}
