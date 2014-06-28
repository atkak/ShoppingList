//
//  NSObject+KVO.m
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>

@implementation NSObject (KVO)

- (NSArray *)allKeys
{
    Class clazz = self.class;
    return [self allKeysForClass:clazz];
}

- (NSArray *)allKeysForClass:(Class)clazz
{
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        const char *propertyName = property_getName(property);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    
    free(properties);
    
    return [NSArray arrayWithArray:propertyArray];
}

@end
