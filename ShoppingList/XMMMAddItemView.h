//
//  XMMMAddItemView.h
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMMMAddItemView;

@protocol XMMMAddItemHeaderInputAccessoryViewDelegate <NSObject>

@optional
- (void)addItemHeaderInputAccessoryViewDidTouchDone;

@end

@interface XMMMAddItemView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) id <XMMMAddItemHeaderInputAccessoryViewDelegate> delegate;

@end
