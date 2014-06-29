//
//  XMMMItemListTableViewCellBackView.m
//  ShoppingList
//
//  Created by kakegawa.atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMItemListTableViewCellBackView.h"

@interface XMMMItemListTableViewCellBackView ()

@end

@implementation XMMMItemListTableViewCellBackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureSubviews];
}

- (void)configureSubviews
{
    self.completeBackgroundView.alpha = 0.0f;
    self.completeBackgroundView.backgroundColor = [UIColor colorWithRed:0xad / 255.0 green:0xd9 / 255.0 blue:0x4c / 255.0 alpha:1.0];
    self.deleteBackgroundView.alpha = 0.0f;
    self.deleteBackgroundView.backgroundColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
}

@end
