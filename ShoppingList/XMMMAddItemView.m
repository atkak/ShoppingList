//
//  XMMMAddItemView.m
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMAddItemView.h"
#import <QuartzCore/QuartzCore.h>

@interface XMMMAddItemView ()

@property (weak, nonatomic) IBOutlet UIView *textFieldBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *inputAccessoryView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)doneButtonDidTouch:(id)sender;

@end

@implementation XMMMAddItemView

- (void)awakeFromNib
{
    self.textFieldBackgroundView.backgroundColor = [UIColor colorWithWhite:(float)0xee / 0xff alpha:1.0f];
    self.textFieldBackgroundView.layer.cornerRadius = 4.0f;
    
    UIInputView *inputView = [[UIInputView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 44.0f)
                                                 inputViewStyle:UIInputViewStyleKeyboard];
    [inputView addSubview:self.inputAccessoryView];
    self.textField.inputAccessoryView = inputView;
    self.textField.placeholder = NSLocalizedString(@"Enter item", nil);
    self.textField.textColor = [UIColor colorWithWhite:(float)0x55 / 0xff alpha:1.0f];
    
    [self.doneButton setTitle:NSLocalizedString(@"Done", nil)
                     forState:UIControlStateNormal];
}

- (IBAction)doneButtonDidTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addItemHeaderInputAccessoryViewDidTouchDone)]) {
        [self.delegate addItemHeaderInputAccessoryViewDidTouchDone];
    }
}

@end
