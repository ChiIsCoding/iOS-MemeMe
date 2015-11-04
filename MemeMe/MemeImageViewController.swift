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
        
        if let meme = self.meme {
            self.view = UIImageView(image: meme.memedImage)
        }
        
    }
}
