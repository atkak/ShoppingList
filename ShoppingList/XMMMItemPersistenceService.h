//
//  XMMMItemPersistenceService.h
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMMShoppingItem.h"

@interface XMMMItemPersistenceService : NSObject

- (NSArray *)fetchItemList;

- (void)saveItem:(XMMMShoppingItem *)item;

@end
