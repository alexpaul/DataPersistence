//
//  DataPersistence.swift
//  NYTBestsellers
//
//  Created by Alex Paul on 12/23/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

public enum PersistenceError: Error {
  case propertyListEncodingError(Error)
  case propertyListDecodingError(Error)
  case writingError(Error)
  case noContentsAtPath(String)
}

public typealias Writeable = Codable & Equatable

public protocol DataPersistenceDelegate: AnyObject {
  func didAddItem<T: Writeable>(_ dataPersistence: DataPersistence<T>, item: T)
  func didRemoveItem<T: Writeable>(_ dataPersistence: DataPersistence<T>, item: T)
}

public final class DataPersistence<T: Writeable> {
  
  private let filename = "items.plist"
  
  private var items = [T]()
  
  public weak var delegate: DataPersistenceDelegate?
  
  public init() {}
  
  public func save(item: T) {
    let _ = try? loadItems() // TODO: handle
    items.append(item)
    try? save()
    delegate?.didAddItem(self, item: item)
  }
  
  private func save() throws {
    do {
      let data = try PropertyListEncoder().encode(items)
      let filepath = FileManager.getPath(with: filename, for: .documentsDirectory)
      try data.write(to: filepath)
      print(filepath)
    } catch PersistenceError.propertyListDecodingError(let error) {
      print("encoding error: \(error)")
    } catch PersistenceError.writingError(let error) {
      print("writing error: \(error)")
    }
  }
  
  public func hasItemBeenSaved(item: T) -> Bool {
    guard let items = try? loadItems() else {
      return false
    }
    self.items = items
    let itemIndex = self.items.firstIndex { $0 == item }
    guard let _ = itemIndex else {
      return false
    }
    return true
  }
  
  public func delete(index: Int) {
    let _ = try? loadItems()
    let item = items[index]
    items.remove(at: index)
    try? save()
    delegate?.didRemoveItem(self, item: item)
  }
  
  public func removeAll() {
    guard let loadedItems = try? loadItems() else {
      return
    }
    items = loadedItems
    items.removeAll()
    try? save()
  }
  
  public func loadItems() throws -> [T]  {
    let filepath = FileManager.getPath(with: filename, for: .documentsDirectory)
    if FileManager.default.fileExists(atPath: filepath.path) {
      guard let data = FileManager.default.contents(atPath: filepath.path) else {
        throw PersistenceError.noContentsAtPath(filepath.path)
      }
      do {
        items = try PropertyListDecoder().decode([T].self, from: data)
      } catch {
        throw PersistenceError.propertyListDecodingError(error)
      }
    } else {
      print("\(filename) does not currently exists")
    }
    return items
  }
  
}
