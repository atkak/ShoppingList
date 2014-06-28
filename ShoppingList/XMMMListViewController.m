//
//  XMMMListViewController.m
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/06/28.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

#import "XMMMListViewController.h"
#import "XMMMItemPersistenceService.h"
#import "XMMMShoppingItem.h"
#import "XMMMAddItemHeaderView.h"
#import "XMMMItemListTableViewCell.h"

@interface XMMMListViewController () <UITextFieldDelegate, XMMMAddItemHeaderInputAccessoryViewDelegate, RMSwipeTableViewCellDelegate>

@property (nonatomic) NSMutableArray *items;
@property (nonatomic) XMMMItemPersistenceService *itemService;

@property (weak, nonatomic) IBOutlet XMMMAddItemHeaderView *addItemHeaderView;

@end

@implementation XMMMListViewController

- (void)loadView
{
    [super loadView];
    
    XMMMAddItemHeaderView *headerView = [[UINib nibWithNibName:@"XMMMAddItemHeaderView"
                                                       bundle:nil] instantiateWithOwner:self options:nil][0];
    self.tableView.tableHeaderView = headerView;
    self.addItemHeaderView = headerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = [NSMutableArray new];
    self.itemService = [XMMMItemPersistenceService new];
    
    self.addItemHeaderView.textField.delegate = self;
    self.addItemHeaderView.textField.placeholder = NSLocalizedString(@"Add item here", nil);
    self.addItemHeaderView.delegate = self;
    
    [self.tableView registerClass:XMMMItemListTableViewCell.class forCellReuseIdentifier:@"CellIdentifier"];
    
    [self loadItems];
}

#pragma mark - UITableViewDelegate

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

#pragma mark - Private

- (void)loadItems
{
    NSArray *itemList = [self.itemService fetchItemList];
    self.items = [itemList mutableCopy];
    [self.tableView reloadData];
}

- (void)addShoppingItemForName:(NSString *)name
{
    XMMMShoppingItem *item = [[XMMMShoppingItem alloc] initWithName:name
                                                        createdDate:[NSDate date]];
    [self.itemService saveItem:item];
    [self.items insertObject:item atIndex:0];
}

@end
