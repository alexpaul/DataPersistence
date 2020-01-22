//
//  DataPersistence.swift
//  NYTBestsellers
//
//  Created by Alex Paul on 12/23/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

public enum DataPersistenceError: Error {
  case propertyListEncodingError(Error)
  case propertyListDecodingError(Error)
  case writingError(Error)
  case deletingError
  case noContentsAtPath(String)
}

public protocol DataPersistenceDelegate: AnyObject {
  func didSaveItem<T: Codable>(_ persistenceHelper: DataPersistence<T>, item: T)
  func didDeleteItem<T: Codable>(_ persistenceHelper: DataPersistence<T>, item: T)
}

public typealias Writeable = Codable & Equatable

public final class DataPersistence<T: Writeable> {
  
  private let filename: String
  
  private var items: [T]
  
  public weak var delegate: DataPersistenceDelegate?
    
  public init(filename: String) {
    self.filename = filename
    self.items = []
  }
  
  private func saveItemsToDocumentsDirectory() throws {
    do {
      let url = FileManager.getPath(with: filename, for: .documentsDirectory)
      let data = try PropertyListEncoder().encode(items)
      try data.write(to: url, options: .atomic)
    } catch {
      throw DataPersistenceError.writingError(error)
    }
  }
  
  // Create
  public func createItem(_ item: T) throws {
    _ = try? loadItems()
    items.append(item)
    do {
      try saveItemsToDocumentsDirectory()
      delegate?.didSaveItem(self, item: item)
    } catch {
      throw DataPersistenceError.writingError(error)
    }
  }
  
  // Read
  public func loadItems() throws -> [T] {
    let path = FileManager.getPath(with: filename, for: .documentsDirectory).path
     if FileManager.default.fileExists(atPath: path) {
       if let data = FileManager.default.contents(atPath: path) {
         do {
           items = try PropertyListDecoder().decode([T].self, from: data)
         } catch {
          throw DataPersistenceError.propertyListDecodingError(error)
         }
       }
     }
    return items
  }
  
  // for re-ordering, and keeping date in sync
  public func synchronize(_ items: [T]) {
    self.items = items
    try? saveItemsToDocumentsDirectory()
  }
  
  // Update
  @discardableResult
  public func update(_ item: T, at index: Int) -> Bool {
    items[index] = item
    try? saveItemsToDocumentsDirectory()
    return true
  }
  
  @discardableResult
  public func update(_ oldItem: T, with newItem: T) -> Bool {
    if let index = items.firstIndex(of: oldItem) {
      update(newItem, at: index)
      return true
    }
    return false
  }
  
  // Delete
  public func deleteItem(at index: Int) throws {
    let deletedItem = items[index]
    items.remove(at: index)
    do {
      try saveItemsToDocumentsDirectory()
      delegate?.didDeleteItem(self, item: deletedItem)
    } catch {
      throw DataPersistenceError.deletingError
    }
  }
  
  public func hasItemBeenSaved(_ item: T) -> Bool {
    guard let items = try? loadItems() else {
      return false
    }
    self.items = items
    if let _ = self.items.firstIndex(of: item) {
      return true
    }
    return false
  }
  
  public func removeAll() {
    guard let loadedItems = try? loadItems() else {
      return
    }
    items = loadedItems
    items.removeAll()
    try? saveItemsToDocumentsDirectory()
  }
}
