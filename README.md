# DataPersistence

Persists data to documents directory. Performs CRUD operations. Create. Read. Update. Delete.

[Version Releases](https://github.com/alexpaul/DataPersistence/releases)

## Requirements 

* Xcode 10.2+ 
* Swift 5.0+ 

## Installation 

Currently DataPersistence only has support for Swift package manager. 

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

#### 1. Saving an item to the documents directory 
```swift 
import DataPersistence 

dataPersistence.save(item: item)
```

#### 2. Retrieving saved items from the documents directory 
```swift 
import DataPersistence 

savedItems = dataPersistence.items
```
