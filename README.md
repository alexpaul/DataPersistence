# DataPersistence

Persists data to documents directory. Performs CRUD operations. Create. Read. Update. Delete.

[Version Releases](https://github.com/alexpaul/DataPersistence/releases)

## Requirements 

* Xcode 10.2+ 
* Swift 5.0+ 

## Swift Package Installation 

To install copy this github url
```https://github.com/alexpaul/DataPersistence```  
Navigate to Xcode and do the following: 
 - select **File -> Swift Packages -> Add Package Dependency** 
 - paste the copied url above into the search field in the presented dialog
 - In the **Choose Package Options** select the Version Rules option (default option). Version rules will update Swift packages based on their relesase versions e.g 1.0.1
 
 Click Next then Finish. 
 At this point the package should have been installed successfully 🥳 

## Swift Package Dependencies 

* None 


## Usage 

#### 1. Creating a DataPersistence instance 

> DataPersistence takes a generic type. The generic has two protocol contraints: **Codable** and **Equatable**

```swift 
let dataPersistence = DataPersistence<Person>()
```

#### 2. Saving an item to the documents directory 
```swift 
import DataPersistence 

dataPersistence.save(item: item)
```

#### 3. Retrieving saved items from the documents directory 
```swift 
import DataPersistence 

savedItems = try? dataPersistence.loadItems()
```

#### 4. Deleting a saved item from the documents directory 
```swift 
import DataPersistence 

dataPersistence.delete(index: index)
```

#### 5. Remove all saved items from the documents directory 
```swift 
import DataPersistence 

dataPersistence.removeAll()
```

#### 6. Check if a particular item has already been saved to the documents directory 
```swift 
import DataPersistence 

let itemHasBeenSaved = dataPersistence.hasItemBeenSaved(item: person) // true or false 
```

## License

DataPersistence is released under the MIT license. See [LICENSE](https://github.com/alexpaul/DataPersistence/blob/master/LICENSE) for details.

