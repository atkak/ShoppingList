//
//  XMMMShoppingItem.h
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMMShoppingItem : NSObject <NSCoding>

- (instancetype)initWithName:(NSString *)name
                 createdDate:(NSDate *)createdDate;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic) BOOL completed;

@end
