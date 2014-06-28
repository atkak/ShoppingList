//
//  XMMMAddItemHeaderView.m
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMAddItemHeaderView.h"

@interface XMMMAddItemHeaderView ()

@property (weak, nonatomic) IBOutlet UIToolbar *inputAccessoryToolbar;

- (IBAction)doneButtonDidTouch:(id)sender;

@end

@implementation XMMMAddItemHeaderView

- (void)awakeFromNib
{
    self.backgroundView = [UIView new];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    self.textField.inputAccessoryView = self.inputAccessoryToolbar;
}

- (IBAction)doneButtonDidTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addItemHeaderInputAccessoryViewDidTouchDone)]) {
        [self.delegate addItemHeaderInputAccessoryViewDidTouchDone];
    }
}

@end
