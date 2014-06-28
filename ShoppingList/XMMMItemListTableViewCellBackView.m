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
        [self configureSubviews];
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
    self.deleteBackgroundView.alpha = 0.0f;
}

@end
