//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/18/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeTableCell"

class SentMemesTableViewController: UITableViewController {
    
    // extract [Meme] shared meme data from AppDelegate
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = 80
        
        // initialize navigation bar and Create New button
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = UIColor.blueColor()
        let rightButton = UIBarButtonItem(title: "Create New", style: UIBarButtonItemStyle.Plain, target: self, action: "createNewMeme")
        navigationItem.rightBarButtonItem = rightButton
        
    }
    
    // reload data every time to update table
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    // implement table view controller protocol functions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memeImageViewController = MemeImageViewController()
        memeImageViewController.meme = memes[indexPath.row]
        
        self.navigationController?.pushViewController(memeImageViewController, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // dequeue a reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)! as UITableViewCell
        
        let meme = memes[indexPath.row]
        
        // set cell name and image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
        
    }
    
    
    // Create new meme
    func createNewMeme() {
        let createNewMemeVC = EditMemeViewController()
        presentViewController(createNewMemeVC, animated: true, completion: nil)
    }
    
}
