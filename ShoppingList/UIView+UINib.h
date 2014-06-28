//
//  UIView+UINib.h
//  ShoppingList
//
//  Created by kakegawa.atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UINib)

+ (instancetype)loadFromNib;

+ (instancetype)loadFromNibWithOwner:(id)owner;

@end
