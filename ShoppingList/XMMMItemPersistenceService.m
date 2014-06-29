//
//  XMMMItemPersistenceService.m
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMItemPersistenceService.h"
#import <Objective-LevelDB/LevelDB.h>

@interface XMMMItemPersistenceService ()

@property (nonatomic) LevelDB *db;

@end

@implementation XMMMItemPersistenceService

- (id)init
{
    self = [super init];
    
    if (self) {
        _db = [LevelDB databaseInLibraryWithName:@"list.ldb"];
    }
    
    return self;
}

- (NSArray *)fetchItemList
{
    NSMutableArray *itemList = [NSMutableArray new];
    
    [self.db
     enumerateKeysAndObjectsBackward:YES
     lazily:NO
     startingAtKey:nil
     filteredByPredicate:nil
     andPrefix:nil
     usingBlock:^(LevelDBKey * key, id value, BOOL *stop) {
         [itemList addObject:value];
     }];
    
    return itemList;
}

- (void)saveItem:(XMMMShoppingItem *)item
{
    NSString *key = [NSString stringWithFormat:@"%f", item.createdDate.timeIntervalSince1970];
    [self.db setObject:item forKey:key];
}

- (void)removeItem:(XMMMShoppingItem *)item
{
    NSString *key = [NSString stringWithFormat:@"%f", item.createdDate.timeIntervalSince1970];
    [self.db removeObjectForKey:key];
}

- (void)removeItems:(NSArray *)items
{
    NSMutableArray *keys = [NSMutableArray new];
    
    for (XMMMShoppingItem *item in items) {
        NSString *key = [NSString stringWithFormat:@"%f", item.createdDate.timeIntervalSince1970];
        [keys addObject:key];
    }
    
    [self.db removeObjectsForKeys:keys];
}

- (void)removeAllItems
{
    [self.db removeAllObjects];
}

@end
