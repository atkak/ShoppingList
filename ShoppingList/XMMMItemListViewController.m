//
//  XMMMListViewController.m
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMItemListViewController.h"
#import "XMMMItemPersistenceService.h"
#import "XMMMShoppingItem.h"
#import "XMMMAddItemView.h"
#import "XMMMItemListTableViewCell.h"
#import "UIView+UINib.h"
#import <UIActionSheet+Blocks/UIActionSheet+Blocks.h>

@interface XMMMItemListViewController () <UITextFieldDelegate, XMMMAddItemHeaderInputAccessoryViewDelegate, RMSwipeTableViewCellDelegate>

@property (nonatomic) NSMutableArray *items;
@property (nonatomic) XMMMItemPersistenceService *itemService;

@property (nonatomic) XMMMAddItemView *addItemHeaderView;
@property (weak, nonatomic) UILabel *itemCountLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemCountLabelButton;

- (IBAction)removeItemButtonDidTouch:(id)sender;
- (IBAction)actionButtonDidTouch:(id)sender;

@end

@implementation XMMMItemListViewController

#pragma mark - Lifecycle

- (void)loadView
{
    [super loadView];
    
    XMMMAddItemView *headerView = [XMMMAddItemView loadFromNib];
    self.addItemHeaderView = headerView;
    self.addItemHeaderView.textField.delegate = self;
    self.addItemHeaderView.delegate = self;
    
    UILabel *itemCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 44.0f)];
    itemCountLabel.textAlignment = NSTextAlignmentCenter;
    itemCountLabel.textColor = [UIColor colorWithWhite:(float)0x55 / 0xff alpha:1.0f];
    itemCountLabel.font = [UIFont systemFontOfSize:14.0f];
    self.itemCountLabel = itemCountLabel;
    
    self.itemCountLabelButton.customView = itemCountLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = [NSMutableArray new];
    self.itemService = [XMMMItemPersistenceService new];
    
    self.title = NSLocalizedString(@"Items", nil);
    
    [self.tableView registerClass:[XMMMItemListTableViewCell class]
           forCellReuseIdentifier:@"CellIdentifier"];
    self.tableView.backgroundColor = [UIColor colorWithWhite:(float)0xf8 / 0xff alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:(float)0xdd / 0xff alpha:1.0f];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.navigationItem.titleView = self.addItemHeaderView;
    
    [self loadItems];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMMMItemListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"
                                                                           forIndexPath:indexPath];
    
    XMMMShoppingItem *item = self.items[indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.completed = item.completed;
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.addItemHeaderView.textField.text.length > 0) {
        [self addShoppingItemForName:self.addItemHeaderView.textField.text];
        self.addItemHeaderView.textField.text = nil;
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    return NO;
}

#pragma mark - RMSwipeTableViewCellDelegate

- (void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell
                               fromPoint:(CGPoint)point
                               animation:(RMSwipeTableViewCellAnimationType)animation
                                velocity:(CGPoint)velocity
{
    if (point.x <= -PanDistanceThresholdDelete) {
        XMMMItemListTableViewCell *cell = (XMMMItemListTableViewCell *)swipeTableViewCell;
        
        [cell performRemoveItemAnimationWithCompletion:^{
            NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
            XMMMShoppingItem *item = self.items[indexPath.row];
            [self.itemService removeItem:item];
            [self.items removeObject:item];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

- (void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell
                              fromPoint:(CGPoint)point
                              animation:(RMSwipeTableViewCellAnimationType)animation
                               velocity:(CGPoint)velocity
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
    XMMMShoppingItem *item = self.items[indexPath.row];
    
    if (point.x >= PanDistanceThresholdComplete) {
        item.completed = !item.completed;
        [self.itemService saveItem:item];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - XMMMAddItemHeaderInputAccessoryViewDelegate

- (void)addItemHeaderInputAccessoryViewDidTouchDone
{
    if (self.addItemHeaderView.textField.text.length > 0) {
        [self addShoppingItemForName:self.addItemHeaderView.textField.text];
        self.addItemHeaderView.textField.text = nil;
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.addItemHeaderView.textField resignFirstResponder];
}

#pragma mark - Handler

- (IBAction)removeItemButtonDidTouch:(id)sender
{
    UIActionSheet *actionSheet = [UIActionSheet showInView:self.view
                                                  withTitle:nil
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:NSLocalizedString(@"Remove All Items", nil)
                                          otherButtonTitles:@[NSLocalizedString(@"Remove Completed Items", nil)]
                                                   tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                                                       switch (buttonIndex) {
                                                           case 0:
                                                               [self removeAllItems];
                                                               break;
                                                           case 1:
                                                               [self removeCompletedItems];
                                                               break;
                                                           default:
                                                               break;
                                                       }
                                                   }];
}

- (IBAction)actionButtonDidTouch:(id)sender
{
    
}

#pragma mark - Private

- (void)loadItems
{
    NSArray *itemList = [self.itemService fetchItemList];
    self.items = [itemList mutableCopy];
    [self.tableView reloadData];
    self.itemCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%zd items", nil), self.items.count];
}

- (void)addShoppingItemForName:(NSString *)name
{
    XMMMShoppingItem *item = [[XMMMShoppingItem alloc] initWithName:name
                                                        createdDate:[NSDate date]];
    [self.itemService saveItem:item];
    [self.items insertObject:item atIndex:0];
}

- (void)removeAllItems
{
    [self.itemService removeAllItems];
    [self.items removeAllObjects];
    
    [self.tableView reloadData];
}

- (void)removeCompletedItems
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        XMMMShoppingItem *item = evaluatedObject;
        return item.completed;
    }];
    
    NSArray *completedItems = [self.items filteredArrayUsingPredicate:predicate];
    
    [self.itemService removeItems:completedItems];
    
    for (XMMMShoppingItem *item in completedItems) {
        [self.items removeObject:item];
    }
    
    [self.tableView reloadData];
}

@end