//
//  MemeImageViewController.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/18/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

class MemeImageViewController: UIViewController {
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // single image view that displays the memed image
        let memeImageView = UIImageView()
        if let meme = self.meme {
            memeImageView.image = meme.memedImage
        }
        memeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(memeImageView)
        
        let horizontalConstraint = memeImageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        let verticalConstraint = memeImageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor)
        let heightConstraint = memeImageView.heightAnchor.constraintLessThanOrEqualToAnchor(view.heightAnchor)
        let widthConstraint = memeImageView.widthAnchor.constraintLessThanOrEqualToAnchor(view.widthAnchor)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
        
    }
}
