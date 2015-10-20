//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/18/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCollectionCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    // extract shared meme data from AppDelegate
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    // initialize collection view controller with collectionViewLayout
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // specify flow layout
        let flowLayout = UICollectionViewFlowLayout()
        let space:CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.estimatedItemSize = CGSizeMake(dimension, dimension)
        
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        self.view.addSubview(self.collectionView!)
        
        // register cell identifier
        if let collectionView = self.collectionView {
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            NSLog("Collection View not initialized when assigning reuseIdentifier")
        }
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        // initialize nav bar with create new meme button
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = UIColor.blueColor()
        let rightButton = UIBarButtonItem(title: "Create New", style: UIBarButtonItemStyle.Plain, target: self, action: "createNewMeme")
        navigationItem.rightBarButtonItem = rightButton
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    // reload data every time to update collection
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let collectionView = self.collectionView {
            collectionView.reloadData()
        }
        //        self.collectionView!.reloadData()
    }
    
    // implement protocal function: show meme image in collection view cells
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let meme = memes[indexPath.item]
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        
        return cell
    }
    
    
    // show meme image once selected a cell
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let memeImageViewController = MemeImageViewController()
        // pass a meme object to the MemeImageViewController
        memeImageViewController.meme = memes[indexPath.row]
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(memeImageViewController, animated: true)
        }
        
    }
    
    // number of memes
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    // Create new meme
    func createNewMeme() {
        let newMemeVC = EditMemeViewController()
        presentViewController(newMemeVC, animated: true, completion: nil)
    }
    
}