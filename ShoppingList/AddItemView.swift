//
//  AddItemView.swift
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/10/19.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

import UIKit

class AddItemView: UIView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var textFieldBackgroundView: UIView!
    @IBOutlet private weak var accessoryView: UIInputView!
    @IBOutlet private weak var doneButton: UIButton!
    
    var delegate: AddItemHeaderInputAccessoryViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textFieldBackgroundView.backgroundColor = UIColor(white: 0xee / 0xff, alpha: 1.0)
        self.textFieldBackgroundView.layer.cornerRadius = 4.0
        
        self.textField.inputAccessoryView = self.accessoryView
        self.textField.placeholder = NSLocalizedString("Add item", comment: "")
        self.textField.textColor = UIColor(white: 0x55 / 0xff, alpha: 1.0)
        
        self.doneButton.setTitle(NSLocalizedString("Done", comment: ""), forState: .Normal)
    }
    
    @IBAction func doneButtonDidTouch(sender: AnyObject) {
        self.delegate?.addItemHeaderInputAccessoryViewDidTouchDone()
    }
}

protocol AddItemHeaderInputAccessoryViewDelegate {
    func addItemHeaderInputAccessoryViewDidTouchDone()
}