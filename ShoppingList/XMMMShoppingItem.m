//
//  XMMMShoppingItem.m
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMShoppingItem.h"
#import "NSObject+KVO.h"

@implementation XMMMShoppingItem

- (instancetype)initWithName:(NSString *)name
                 createdDate:(NSDate *)createdDate
{
    self = [super init];
    
    if (self) {
        _name = name;
        _createdDate = createdDate;
    }
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    
    if (self) {
        NSDictionary *valueMap = [[NSDictionary alloc] initWithCoder:aDecoder];
        [self setValuesForKeysWithDictionary:valueMap];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSDictionary *valueMap = [self dictionaryWithValuesForKeys:self.allKeys];
    [valueMap encodeWithCoder:aCoder];
}

@end
