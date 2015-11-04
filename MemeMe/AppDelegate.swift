//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/17/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?	
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Define a tab bar with two tabs
        // Each tab is a navigation controller representing a table view of sent Meme and a collection view of sent Meme responsively
        let tabBarController = UITabBarController()
        
        // set bar item attributes
        let tabBarItemAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "Helvetica", size: 20)!,
            NSStrokeWidthAttributeName : 7.0]
        
        // Set table view of sent memes
        let sentMemesTableVC = SentMemesTableViewController()
        let sentMemesTableNavigationController = UINavigationController(rootViewController: sentMemesTableVC)
        sentMemesTableNavigationController.tabBarItem = UITabBarItem(title: "Table View",image: nil,tag: 1)
        sentMemesTableNavigationController.tabBarItem.setTitleTextAttributes(tabBarItemAttributes, forState: .Normal)

        // Set collection view of sent memes
        let sentMemesCollectionVC = SentMemesCollectionViewController()
        let sentMemesCollectionNavigationController = UINavigationController(rootViewController: sentMemesCollectionVC)
        sentMemesCollectionNavigationController.tabBarItem = UITabBarItem(title: "Collection View", image: nil, tag:2)
        sentMemesCollectionNavigationController.tabBarItem.setTitleTextAttributes(tabBarItemAttributes, forState: .Normal)
        
        tabBarController.viewControllers = [sentMemesTableNavigationController, sentMemesCollectionNavigationController]
        
        // Set root view controller as tab bar controller
        self.window!.rootViewController = tabBarController
        self.window!.makeKeyAndVisible()
                
        return true
    }
    
}
