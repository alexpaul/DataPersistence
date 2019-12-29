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

// Creating a Savable protocol here enables our DataPersistentDelegate to avoid being an associated constraint protocol
// this would not allow the DataPersistence class to have a weak var delegate property
public protocol Savable {
  associatedtype ItemType: Codable
  var items: [ItemType] { get }
}

public protocol DataPersistenceDelegate: AnyObject {
  func didAddItem<T: Codable>(_ dataPersistence: DataPersistence<T>, item: T)
  func didRemoveItem<T: Codable>(_ dataPersistence: DataPersistence<T>, item: T)
}

public final class DataPersistence<T: Codable>: Savable {
  
  private let filename = "items.plist"
  
  public var items: [T] {
      return internalElements
  }
  
  private var internalElements = [T]()
    
  // FIXME: error????
  weak var delegate: DataPersistenceDelegate?
  // https://gist.github.com/jeffreybergier/4482b0ab0357b08558a09501d60b6d1d
  
  // john sundell - swift tips
  // https://github.com/JohnSundell/SwiftTips
  
  // Generic delegate's in Swift
  // https://www.152percent.com/blog/2017/4/11/delegates-in-swift
  
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
