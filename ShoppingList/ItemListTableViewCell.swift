//
//  ItemListTableViewCell.swift
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/10/19.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

import UIKit

class ItemListTableViewCell: RMSwipeTableViewCell {
   
    struct PanDistanceThreshold {
        static let Complete: CGFloat = 50.0
        static let Delete: CGFloat = 60.0
    }
    
    private var _completed: Bool = false
    var completed: Bool {
        get {
            return _completed
        }
        set(completed) {
            _completed = completed
            
            if completed {
                self.textLabel?.textColor = UIColor.lightGrayColor()
                self.imageView?.image = UIImage(named: "check_selected")
            } else {
                self.textLabel?.textColor = UIColor(white: 0x55 / 0xff, alpha: 1.0)
                self.imageView?.image = UIImage(named: "check_normal")
            }
        }
    }
    
    private var actualBackView: ItemListTableViewCellBackView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.imageView?.image = UIImage(named: "check_normal")
        self.backgroundView?.backgroundColor = UIColor(white: 0xf8 / 0xff, alpha: 1.0)
        self.contentView.backgroundColor = UIColor(white: 0xf8 / 0xff, alpha: 1.0)
        self.textLabel?.textColor = UIColor(white: 0x55 / 0xff, alpha: 1.0)
        self.textLabel?.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.hidden = false
        if let actualBackView = self.actualBackView {
            actualBackView.hidden = false
            actualBackView.completeBackgroundView.alpha = 0.0
            actualBackView.deleteBackgroundView.alpha = 0.0
        }
        self.imageView?.image = UIImage(named: "check_normal")
    }
    
    override func animateContentViewForPoint(point: CGPoint, velocity: CGPoint) {
        super.animateContentViewForPoint(point, velocity: velocity)
        
        if let actualBackView = self.actualBackView {
            if point.x > 0 {
                if point.x >= PanDistanceThreshold.Complete {
                    UIView.animateWithDuration(0.15) {
                        actualBackView.completeBackgroundView.alpha = self.completed ? 0.0 : 1.0
                    }
                } else {
                    UIView.animateWithDuration(0.15) {
                        actualBackView.completeBackgroundView.alpha = self.completed ? 1.0 : 0.0
                    }
                }
            } else if point.x < 0 {
                if -point.x >= PanDistanceThreshold.Delete {
                    UIView.animateWithDuration(0.15) {
                        actualBackView.deleteBackgroundView.alpha = 1.0
                    }
                } else {
                    UIView.animateWithDuration(0.15) {
                        actualBackView.deleteBackgroundView.alpha = 0.0
                    }
                }
            }
        }
    }
    
    func backView() -> UIView {
        if self.actualBackView == nil {
            let actualBackView = ItemListTableViewCellBackView.loadFromNib()
            actualBackView.frame = self.contentView.bounds
            actualBackView.backgroundColor = self.backViewbackgroundColor
            self.actualBackView = actualBackView
        }
        
        return self.actualBackView!
    }
    
    override func cleanupBackView() {
        self.actualBackView?.removeFromSuperview()
        self.actualBackView = nil
    }
    
    func performRemoveItemAnimationWithCompletion(completion: Void -> Void) {
        self.shouldAnimateCellReset = false
        self.actualBackView?.hidden = true
        
        let contentViewFrame = self.contentView.frame
        
        UIView.animateWithDuration(0.25,
            delay: 0.0,
            options: .CurveLinear,
            animations: {
                self.contentView.frame = CGRectOffset(self.contentView.bounds, self.contentView.frame.size.width, 0.0)
            }, completion: { finished in
                self.contentView.frame = contentViewFrame
                self.contentView.hidden = true
                completion()
            }
        )
    }
    
}
