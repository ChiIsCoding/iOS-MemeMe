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
    
    // Defined data model shared within the app
    var memes = [Meme]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Define a tab bar with two tabs
        // Each tab is a navigation controller representing a table of sent Meme and a collection of sent Meme responsively
        let tabBarController = UITabBarController()
        
        let vc1 = SentMemesTableViewController()
        let vc2 = SentMemesCollectionViewController()
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        
        tabBarController.viewControllers = [nav1, nav2]
        
        // set bar item attributes
        let tabBarItemAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "Helvetica", size: 20)!,
            NSStrokeWidthAttributeName : 7.0]
        
        // set title and assign text attributes
        nav1.tabBarItem = UITabBarItem(title: "Table View",image: nil,tag: 1)
        nav1.tabBarItem.setTitleTextAttributes(tabBarItemAttributes, forState: .Normal)
        
        nav2.tabBarItem = UITabBarItem(title: "Collection View", image: nil, tag:2)
        nav2.tabBarItem.setTitleTextAttributes(tabBarItemAttributes, forState: .Normal)
        
        // Set root view controller as tab bar controller
        self.window!.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
