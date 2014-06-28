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
    UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
    UIView *view = [[nib instantiateWithOwner:owner options:nil] firstObject];
    
    return view;
}

@end
