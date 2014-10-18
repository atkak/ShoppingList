//
//  ItemPersistenceService.swift
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/10/19.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

import Foundation

class ItemPersistenceService {
    
    private let db: LevelDB
    
    init() {
        self.db = LevelDB.databaseInLibraryWithName("list.ldb") as LevelDB
    }
    
    func fetchItemList() -> [ShoppingItem] {
        var itemList = [ShoppingItem]()
       
        self.db.enumerateKeysAndObjectsUsingBlock { key, value, stop in
            if let item = value as? NSDictionary {
                itemList.append(ShoppingItem(dictionary: item))
            }
        }
        
        return itemList.reverse()
    }
    
    func saveItem(item: ShoppingItem) {
        let key = String(format: "%f", item.createdDate.timeIntervalSince1970)
        self.db.setObject(item.dictionary(), forKey: key)
    }
    
    func removeItem(item: ShoppingItem) {
        let key = String(format: "%f", item.createdDate.timeIntervalSince1970)
        self.db.removeObjectForKey(key)
    }
    
    func removeItems(items: [ShoppingItem]) {
        let keys = items.map {
            String(format: "%f", $0.createdDate.timeIntervalSince1970)
        }
        
        self.db.removeObjectsForKeys(keys)
    }
    
    func removeAllItems() {
        self.db.removeAllObjects()
    }
}