//
//  EditMemeViewController.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/17/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // A nav bar(at top), a tool bar, two text field (top, bottom), original image and memed image
    private lazy var pickedImage = UIImageView()
    private lazy var memedImage = UIImage()
    
    private lazy var topTextField = UITextField()
    private lazy var bottomTextField = UITextField()
    private lazy var navBar = UIToolbar()
    private lazy var toolBar = UIToolbar()
    
    private let memeTopTextFieldDelegate = MemeTextFieldDelegate()
    private let memeBottomTextFieldDelegate = MemeTextFieldDelegate()
    
    // text attribute for memed text field
    private let memeEditTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 7.0
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // initialize picked image and add constraints
        let pickedImage = UIImageView()
        self.pickedImage = pickedImage
        pickedImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickedImage)
        
        let pickedImageHorizontalConstraint = pickedImage.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let pickedImageVerticalConstraint = pickedImage.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
        let pickedImageHeightConstraint = pickedImage.heightAnchor.constraintLessThanOrEqualToAnchor(view.heightAnchor)
        let pickedImageWidthConstraint = pickedImage.widthAnchor.constraintLessThanOrEqualToAnchor(view.widthAnchor)
        NSLayoutConstraint.activateConstraints([pickedImageHorizontalConstraint, pickedImageVerticalConstraint, pickedImageHeightConstraint, pickedImageWidthConstraint])
        
        
        // initialize nav bar and add constraints
        let navBar = UIToolbar()
        self.navBar = navBar
        navBar.backgroundColor = UIColor.blueColor()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        
        let navBarWidthConstraint = navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor)
        let navBarHeightConstraint = navBar.heightAnchor.constraintEqualToAnchor(nil, constant: 50)
        let navBarVerticalConstraint = navBar.topAnchor.constraintEqualToAnchor(view.topAnchor)
        NSLayoutConstraint.activateConstraints([navBarWidthConstraint, navBarHeightConstraint, navBarVerticalConstraint])
        
        // add upload button and cancel button on nav bar
        let uploadButton = UIBarButtonItem(title: "Upload", style: .Done, target: self, action: "uploadMeme")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: "cancelMeme")
        let navFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil);
        navBar.items = [uploadButton, navFlexibleSpace, cancelButton]
        
        
        // initialize tool bar and add constraints
        let toolBar = UIToolbar()
        self.toolBar = toolBar
        toolBar.backgroundColor = UIColor.blueColor()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        
        let toolBarWidthConstraint = toolBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor)
        let toolBarHeightConstraint = toolBar.heightAnchor.constraintEqualToAnchor(nil, constant: 50)
        let toolBarVerticalConstraint = toolBar.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        NSLayoutConstraint.activateConstraints([toolBarWidthConstraint, toolBarHeightConstraint, toolBarVerticalConstraint])
        
        // add picking image from album and camera buttons on tool bar
        let albumButton = UIBarButtonItem(title: "Album", style: .Done, target: self, action: "pickAlbumImage")
        let cameraButton = UIBarButtonItem(title: "Camera", style: .Done, target: self, action: "pickCameraImage")
        // disable camera button if camera not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        let toolFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil);
        toolBar.items = [albumButton, toolFlexibleSpace, cameraButton]
        
        
        // initialize and constrain top text field
        let topTextField = UITextField()
        self.topTextField = topTextField
        self.topTextField.delegate = memeTopTextFieldDelegate
        
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        topTextField.defaultTextAttributes = memeEditTextAttributes
        self.topTextField.textAlignment = .Center
        self.topTextField.adjustsFontSizeToFitWidth = true
        self.topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        view.addSubview(topTextField)
        
        let topTFHorizontalConstraint = topTextField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let topTFVerticalConstraint = topTextField.topAnchor.constraintGreaterThanOrEqualToAnchor(navBar.bottomAnchor, constant: 20)
        let topTFWidthConstraint = topTextField.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10)
        NSLayoutConstraint.activateConstraints([topTFHorizontalConstraint, topTFVerticalConstraint, topTFWidthConstraint])
        
        
        // bottom text field
        let bottomTextField = UITextField()
        self.bottomTextField = bottomTextField
        self.bottomTextField.delegate = memeBottomTextFieldDelegate
        
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomTextField.defaultTextAttributes = memeEditTextAttributes
        self.bottomTextField.textAlignment = .Center
        self.bottomTextField.adjustsFontSizeToFitWidth = true
        self.bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        view.addSubview(bottomTextField)
        
        let bottomTFHorizontalConstraint = bottomTextField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let bottomTFVerticalConstraint = bottomTextField.bottomAnchor.constraintGreaterThanOrEqualToAnchor(toolBar.topAnchor, constant: -20)
        let bottomTFWidthConstraint = bottomTextField.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10)
        NSLayoutConstraint.activateConstraints([bottomTFHorizontalConstraint, bottomTFVerticalConstraint, bottomTFWidthConstraint])
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        
        // determine whether disable the upload button or not
        if let items = self.navBar.items {
            let startIndex = items.startIndex
            if let _ = self.pickedImage.image {
                items[startIndex].enabled = true
            } else {
                items[startIndex].enabled = false
            }
        }
        
        // Setup placeholder one view will appear
        self.topTextField.placeholder = "TOP"
        self.bottomTextField.placeholder = "BOTTOM"
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
        
    }
    
    
    // when clicking upload button
    func uploadMeme() {
        if let _ = self.pickedImage.image {
            let memedImage = generateMemedImage()
            self.memedImage = memedImage
            
            // create activity modal to upload a meme image
            let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            
            // after completion, save the meme image and dismiss the activity modal
            nextController.completionWithItemsHandler = {
                (activity, success, items, error) in
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            self.presentViewController(nextController, animated: true, completion: nil)
        }
        
    }
    
    
    func cancelMeme() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func pickAlbumImage() {
        self.pickAnImage(.PhotoLibrary)
    }
    
    func pickCameraImage() {
        self.pickAnImage(.Camera)
    }
    
    
    @objc private func pickAnImage(type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        
        // pick an image with presenting imagePickercontroller, and set upload button enabled after picking an image
        self.presentViewController(imagePicker, animated: true, completion: {() -> Void in
            
            // Enable upload button after picking an image (upload is first item in navBar.items)
            if let items = self.navBar.items {
                let startIndex = items.startIndex
                items[startIndex].enabled = true
            }
        })
    }
    
    
    // implement UIImagePickerControllerDelegate function didFinishPickingImage
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.pickedImage.image = image
        self.pickedImage.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // subscribe to keyboard show and hide
    private func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // unsubscribe to keyboard show and hide
    private func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // scroll image view up when keyboard shows during editing bottom text field
    func keyboardWillShow(notification: NSNotification) {
        
        if self.bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // scroll image view down when keyboard hide during editing bottom text field
    func keyboardWillHide(notification: NSNotification) {
        
        if self.bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // get height of keyboard
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
        
    }
    
    // Generate memed image without nav bar and tool bar
    private func generateMemedImage() -> UIImage {
        // Hide tool bar and nav bar
        self.toolBar.hidden = true
        self.navBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show tool bar and nav bar
        self.toolBar.hidden = false
        self.navBar.hidden = false
        
        return memedImage
    }
    
    
    // Create and save new Meme
    func save() {
        // create a Meme object
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, image: self.pickedImage.image!, memedImage: self.memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
}
