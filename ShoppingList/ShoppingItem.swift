//
//  ShoppingItem.swift
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/10/19.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

import Foundation

class ShoppingItem: NSObject {
    
    var name: String
    var createdDate: NSDate
    var completed: Bool
    
    init(name: String, createdDate: NSDate) {
        self.name = name
        self.createdDate = createdDate
        self.completed = false
        
        super.init()
    }
    
    convenience init(dictionary: NSDictionary) {
        self.init(name: "", createdDate: NSDate())
        
        self.setValuesForKeysWithDictionary(dictionary)
    }
    
    func dictionary() -> NSDictionary {
        return self.dictionaryWithValuesForKeys(self.allKeys())
    }
}