//
//  ItemListViewController.swift
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/09/30.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

import UIKit

class ItemListViewController: UITableViewController, UITextFieldDelegate,
    AddItemHeaderInputAccessoryViewDelegate, RMSwipeTableViewCellDelegate {
    
    private var items: [ShoppingItem]!
    private var itemService: ItemPersistenceService!
    
    private var addItemHeaderView: AddItemView!
    private var itemCountLabel: UILabel!
    
    @IBOutlet weak var itemCountLabelButton: UIBarButtonItem!
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let headerView = AddItemView.loadFromNib()
        self.addItemHeaderView = headerView
        self.addItemHeaderView.textField.delegate = self
        self.addItemHeaderView.delegate = self
        
        let itemCountLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 40.0))
        itemCountLabel.textAlignment = .Center
        itemCountLabel.textColor = UIColor(white: 0x55 / 0xff, alpha: 1.0)
        itemCountLabel.font = UIFont.systemFontOfSize(14.0)
        self.itemCountLabel = itemCountLabel
        
        self.itemCountLabelButton.customView = itemCountLabel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = [ShoppingItem]()
        self.itemService = ItemPersistenceService()
        
        self.tableView.registerClass(ItemListTableViewCell.classForCoder(), forCellReuseIdentifier: "CellIdentifier")
        self.tableView.backgroundColor = UIColor(white: 0xf8 / 0xff, alpha: 1.0)
        self.tableView.separatorColor = UIColor(white: 0xdd / 0xff, alpha: 1.0)
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        self.navigationItem.titleView = self.addItemHeaderView
        
        self.loadItems()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as ItemListTableViewCell
        
        let item = self.items[indexPath.row]
        
        cell.textLabel.text = item.name
        cell.completed = item.completed
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if countElements(self.addItemHeaderView.textField.text) > 0 {
            self.addShoppingItemForName(self.addItemHeaderView.textField.text)
            self.addItemHeaderView.textField.text = nil
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
            self.refreshItemsCount()
        }
        
        return false
    }
    
    // MARK: RMSwipeTableViewCellDelegate 
    
    func swipeTableViewCellWillResetState(swipeTableViewCell: RMSwipeTableViewCell!, fromPoint point: CGPoint, animation: RMSwipeTableViewCellAnimationType, velocity: CGPoint) {
        if point.x <= -ItemListTableViewCell.PanDistanceThreshold.Delete {
            let cell = swipeTableViewCell as ItemListTableViewCell
            
            cell.performRemoveItemAnimationWithCompletion {
                let indexPath = self.tableView.indexPathForCell(swipeTableViewCell)
                if let indexPath = indexPath {
                    let item = self.items[indexPath.row]
                    self.itemService.removeItem(item)
                    self.items.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    self.refreshItemsCount()
                }
            }
        }
    }
    
    func swipeTableViewCellDidResetState(swipeTableViewCell: RMSwipeTableViewCell!, fromPoint point: CGPoint, animation: RMSwipeTableViewCellAnimationType, velocity: CGPoint) {
        let indexPath = self.tableView.indexPathForCell(swipeTableViewCell)
        
        if let indexPath = indexPath {
            let item = self.items[indexPath.row]
            
            if point.x >= ItemListTableViewCell.PanDistanceThreshold.Complete {
                item.completed = !item.completed
                self.itemService.saveItem(item)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
        }
    }
    
    // MARK: XMMMAddItemHeaderInputAccessoryViewDelegate
    
    func addItemHeaderInputAccessoryViewDidTouchDone() {
        if countElements(self.addItemHeaderView.textField.text) > 0 {
            self.addShoppingItemForName(self.addItemHeaderView.textField.text)
            self.addItemHeaderView.textField.text = nil
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
            self.refreshItemsCount()
        }
        
        self.addItemHeaderView.textField.resignFirstResponder()
    }
    
    // MARK: Handler
    
    @IBAction func actionButtonDidTouch(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Add Items from Clipboard", comment: ""), style: .Default) { action in
                self.addShoppingItemsFromPasteboard()
            }
        )
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func removeItemButtonDidTouch(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil))
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Remove All Items", comment: ""), style: .Destructive) { action in
                self.removeAllItems()
            }
        )
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Remove Checked Items", comment: ""), style: .Default) { action in
                self.removeCompletedItems()
            }
        )
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Private
    
    private func loadItems() {
        self.items = self.itemService.fetchItemList() as [ShoppingItem]
        self.tableView.reloadData()
        self.refreshItemsCount()
    }
    
    private func addShoppingItemForName(name: String) {
        let item = ShoppingItem(name: name, createdDate: NSDate())
        self.itemService.saveItem(item)
        self.items.insert(item, atIndex: 0)
    }
    
    private func removeAllItems() {
        if self.items.count == 0 {
            return
        }
        
        self.itemService.removeAllItems()
        
        let indexPaths = (0..<countElements(self.items)).map { NSIndexPath(forRow: $0, inSection: 0) }
        
        self.items.removeAll()
        
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        self.refreshItemsCount()
    }
    
    private func removeCompletedItems() {
        if self.items.count == 0 {
            return
        }
        
        let (completedItems, incompletedItems) = self.items.reduce(([ShoppingItem](), [ShoppingItem]())) { (acc, item) in
            var (completedItems, incompletedItems) = acc
            
            if item.completed {
                completedItems.append(item)
            } else {
                incompletedItems.append(item)
            }
            
            return (completedItems, incompletedItems)
        }
        
        if completedItems.count == 0 {
            return
        }
        
        let indexPaths: [NSIndexPath] = completedItems.map { item in
            let index = find(self.items, item)!
            return NSIndexPath(forRow: index, inSection: 0)
        }
        
        self.itemService.removeItems(completedItems)
        self.items = incompletedItems
        
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        self.refreshItemsCount()
    }
    
    private func refreshItemsCount() {
        let itemString = NSLocalizedString("items", comment: "")
        self.itemCountLabel.text = "\(self.items.count) items \(itemString)"
    }
    
    private func addShoppingItemsFromPasteboard() {
        let pasteboard = UIPasteboard.generalPasteboard()
        
        if let string = pasteboard.string {
        
            let separators = ["\r\n", ",", ".", "、", "。"]
            
            let replacedString = separators.reduce(string) { acc, separator in
                return acc.stringByReplacingOccurrencesOfString(separator, withString: "\n", options: nil, range: nil)
            }
            
            let names = replacedString.componentsSeparatedByString("\n")
                .filter { $0.utf16Count != 0 }
                .map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
            
            names.forEach { self.addShoppingItemForName($0) }
            
            let indexPaths = (0..<names.count).map { NSIndexPath(forRow: $0, inSection: 0) }
            
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            self.refreshItemsCount()
        }
    }
}
