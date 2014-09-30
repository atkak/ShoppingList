//
//  AppDelegate.swift
//  ShoppingList
//
//  Created by KAKEGAWA Atsushi on 2014/09/30.
//  Copyright (c) 2014年 KAKEGAWA Atsushi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        UIView.appearance().tintColor = UIColor(red: 0xad / 0xff, green: 0xd9 / 0xff, blue: 0x4c / 0xff, alpha: 1.0)
        
        return true
    }
}
