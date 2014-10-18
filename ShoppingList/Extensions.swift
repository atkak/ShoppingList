//
//  Array.swift
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/10/18.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

import Foundation

extension Array {
    func forEach(f: (T) -> Void) {
        for element in self {
            f(element)
        }
    }
}
