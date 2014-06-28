//
//  XMMMItemListTableViewCell.h
//  ShoppingList
//
//  Created by kakegawa.atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMSwipeTableViewCell.h>

static const CGFloat PanDistanceThresholdComplete = 60.0f;
static const CGFloat PanDistanceThresholdDelete = 70.0f;

@interface XMMMItemListTableViewCell : RMSwipeTableViewCell

@property (nonatomic) BOOL completed;

- (void)performRemoveItemAnimationWithCompletion:(void (^)())completion;

@end
