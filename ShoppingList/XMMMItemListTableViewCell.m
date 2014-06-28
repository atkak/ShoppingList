//
//  XMMMItemListTableViewCell.m
//  ShoppingList
//
//  Created by kakegawa.atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMItemListTableViewCell.h"
#import "XMMMItemListTableViewCellBackView.h"
#import "UIView+UINib.h"

@interface XMMMItemListTableViewCell ()

@property (weak, nonatomic) UILabel *completeLabel;
@property (weak, nonatomic) UILabel *deleteLabel;
@property (nonatomic) XMMMItemListTableViewCellBackView *actualBackView;

@end

@implementation XMMMItemListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.contentView.hidden = NO;
    self.actualBackView.hidden = NO;
    self.actualBackView.completeBackgroundView.alpha = 0.0f;
    self.actualBackView.deleteBackgroundView.alpha = 0.0f;
}

- (void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity
{
    [super animateContentViewForPoint:point velocity:velocity];
    
    if (point.x > 0) {
        if (point.x >= PanDistanceThresholdComplete) {
            [UIView animateWithDuration:0.15 animations:^{
                self.actualBackView.completeBackgroundView.alpha = self.completed ? 0.0f : 1.0f;
            } completion:nil];
        } else {
            [UIView animateWithDuration:0.15 animations:^{
                self.actualBackView.completeBackgroundView.alpha = self.completed ? 1.0f : 0.0f;
            } completion:nil];
        }
    } else if (point.x < 0) {
        if (-point.x >= PanDistanceThresholdDelete) {
            [UIView animateWithDuration:0.15 animations:^{
                self.actualBackView.deleteBackgroundView.alpha = 1.0f;
            } completion:nil];
        } else {
            [UIView animateWithDuration:0.15 animations:^{
                self.actualBackView.deleteBackgroundView.alpha = 0.0f;
            } completion:nil];
        }
    }
}

- (UIView *)backView
{
    if (!self.actualBackView) {
        self.actualBackView = [XMMMItemListTableViewCellBackView loadFromNib];
        self.actualBackView.frame = self.contentView.bounds;
        self.actualBackView.backgroundColor = self.backViewbackgroundColor;
    }
    
    return self.actualBackView;
}

- (void)cleanupBackView
{
    [self.actualBackView removeFromSuperview];
    self.actualBackView = nil;
}

#pragma mark - Accessor

- (void)setCompleted:(BOOL)completed
{
    _completed = completed;
    
    if (completed) {
        self.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.textLabel.textColor = [UIColor darkTextColor];
    }
}

#pragma mark - Public

- (void)performRemoveItemAnimationWithCompletion:(void (^)())completion
{
    self.shouldAnimateCellReset = NO;
    self.actualBackView.hidden = YES;
    
    CGRect contentViewFrame = self.contentView.frame;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.contentView.frame = CGRectOffset(self.contentView.bounds, self.contentView.frame.size.width, 0.0f);
                     }
                     completion:^(BOOL finished) {
                         self.contentView.frame = contentViewFrame;
                         self.contentView.hidden = YES;
                         completion();
                     }];
}

@end
