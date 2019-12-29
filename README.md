# DataPersistence

Persists data to documents directory. Performs CRUD operations. Create. Read. Update. Delete.

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
