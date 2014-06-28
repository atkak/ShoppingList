//
//  XMMMAddItemHeaderView.m
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMAddItemHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface XMMMAddItemHeaderView ()

@property (weak, nonatomic) IBOutlet UIToolbar *inputAccessoryToolbar;
@property (weak, nonatomic) IBOutlet UIView *textFieldBackgroundView;

- (IBAction)doneButtonDidTouch:(id)sender;

@end

@implementation XMMMAddItemHeaderView

- (void)awakeFromNib
{
    self.backgroundView = [UIView new];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    
    self.textFieldBackgroundView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.textFieldBackgroundView.layer.cornerRadius = 4.0f;
    
    self.textField.inputAccessoryView = self.inputAccessoryToolbar;
    self.textField.placeholder = NSLocalizedString(@"Enter item", nil);
}

- (IBAction)doneButtonDidTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addItemHeaderInputAccessoryViewDidTouchDone)]) {
        [self.delegate addItemHeaderInputAccessoryViewDidTouchDone];
    }
}

@end
