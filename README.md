# DataPersistence

Persists data to documents directory. Performs CRUD operations. Create. Read. Update. Delete.

[Version Releases](https://github.com/alexpaul/DataPersistence/releases)

## Requirements 

* Xcode 10.2+ 
* Swift 5.0+ 

## Installation 

Currently DataPersistence only has support for Swift package manager. To install copy this github url ```https://github.com/alexpaul/DataPersistence``` and navigate to Xcode. Once in Xcode select File -> Swift Packages -> Add Package Dependency and paste the copied url into the search field in the presented dialog. In the Choose Package Options select the Version Rules option which should be the presented default choice and click Next then Finish. At this point the package should have been installed successfully. 

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
