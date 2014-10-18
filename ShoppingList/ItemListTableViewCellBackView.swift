//
//  ItemListTableViewCellBackView.swift
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/10/19.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

import UIKit

class ItemListTableViewCellBackView: UIView {

    @IBOutlet weak var completeBackgroundView: UIView!
    @IBOutlet weak var deleteBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.completeBackgroundView.alpha = 0.0
        self.completeBackgroundView.backgroundColor = UIColor(red: 0xad / 0xff, green: 0xd9 / 0xff, blue: 0x4c / 0xff, alpha: 1.0)
        self.deleteBackgroundView.alpha = 0.0
        self.deleteBackgroundView.backgroundColor = UIColor(red: 232.0 / 255.0, green: 61.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
    }
}
