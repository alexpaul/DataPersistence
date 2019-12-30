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
  
  public var items: [T] {
      return internalElements
  }
  
  private var internalElements = [T]()
    
  public weak var delegate: DataPersistenceDelegate?
  
  public init() {}
  
  public func save(item: T) {
    try? loadAll() // TODO: handle
    internalElements.append(item)
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
  
  private func hasBeenSaved(item: T) -> Bool {
    //let itemFound = internalElements.firstIndex{ $0 == item }
    
    return false
  }
  
  public func delete(index: Int) {
    try? loadAll() // TODO: handle
    
    let item = internalElements[index]
    
    internalElements.remove(at: index)
    
    // save
    try? save()
    
    delegate?.didRemoveItem(self, item: item)
  }
  
  public func loadAll() throws {
    let filepath = FileManager.getPath(with: filename, for: .documentsDirectory)
    if FileManager.default.fileExists(atPath: filepath.path) {
      guard let data = FileManager.default.contents(atPath: filepath.path) else {
        throw PersistenceError.noContentsAtPath(filepath.path)
      }
      do {
        internalElements = try PropertyListDecoder().decode([T].self, from: data)
      } catch {
        throw PersistenceError.propertyListDecodingError(error)
      }
    } else {
      print("\(filename) does not currently exists")
    }
  }
  
}
