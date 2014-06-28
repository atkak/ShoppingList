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

@interface XMMMListViewController ()

@property (nonatomic) NSMutableArray *items;

@end

@implementation XMMMListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = [NSMutableArray new];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.items.count;
    
    if (self.editing) {
        count++;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"
                                                                 forIndexPath:indexPath];
    
    XMMMShoppingItem *item = [self itemForIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

- (XMMMShoppingItem *)itemForIndex:(NSUInteger)index
{
    NSUInteger itemIndex = index;
    
    if (self.editing) {
        itemIndex--;
    }
    
    return self.items[itemIndex];
}

@end
