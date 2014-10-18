//
//  UIView+UINib.m
//  ShoppingList
//
//  Created by kakegawa.atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "UIView+UINib.h"

@implementation UIView (UINib)

#pragma mark - Public methods

+ (instancetype)loadFromNib
{
    return [self loadFromNibWithOwner:nil];
}

+ (instancetype)loadFromNibWithOwner:(id)owner
{
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *nibNames = [nibName componentsSeparatedByString:@"."];
    
    NSString *name;
    if (nibNames.count == 2) {
        name = nibNames[1];
    } else if (nibNames.count == 1) {
        name = nibNames[0];
    } else {
        NSAssert(NO, @"Invalid");
    }
    UINib *nib = [UINib nibWithNibName:name bundle:[NSBundle mainBundle]];
    UIView *view = [[nib instantiateWithOwner:owner options:nil] firstObject];
    
    return view;
}

@end
