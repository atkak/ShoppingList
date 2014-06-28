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

@interface XMMMListViewController () <UITextFieldDelegate, XMMMAddItemHeaderInputAccessoryViewDelegate>

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
    self.addItemHeaderView.delegate = self;
    
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"
                                                                 forIndexPath:indexPath];
    
    XMMMShoppingItem *item = self.items[indexPath.row];
    
    cell.textLabel.text = item.name;
    if (item.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMMMShoppingItem *item = self.items[indexPath.row];
    item.completed = !item.completed;
    [self.itemService saveItem:item];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.addItemHeaderView.textField.text.length > 0) {
        [self addShoppingItemForName:self.addItemHeaderView.textField.text];
        self.addItemHeaderView.textField.text = nil;
        [self.tableView reloadData];
    }
    
    return NO;
}

#pragma mark - XMMMAddItemHeaderInputAccessoryViewDelegate

- (void)addItemHeaderInputAccessoryViewDidTouchDone
{
    if (self.addItemHeaderView.textField.text.length > 0) {
        [self addShoppingItemForName:self.addItemHeaderView.textField.text];
        self.addItemHeaderView.textField.text = nil;
        [self.tableView reloadData];
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
