//
//  EditMemeViewController.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/17/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UINavigationControllerDelegate, EditMemeDelegate, UIImagePickerControllerDelegate {
    
    // Singleton instance of saved Memes
    private var sentMemes = SentMemes.sharedInstance
    
    // initialize editMemeView which cast self.view to EditMemeView
    private var editMemeView: EditMemeView! { return self.view as! EditMemeView }
    
    override func loadView() {
        view = EditMemeView(frame: UIScreen.mainScreen().bounds)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set Delegates
        self.editMemeView.delegate = self
        
        self.subscribeToKeyboardNotifications()
        
        // some more checkings in view before view appears
        self.editMemeView.resetTextFieldPlacehoder()
        self.editMemeView.updateUploadButtonStateWithImageState()
        self.editMemeView.addTapRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // set delegates to nil
        self.editMemeView.delegate = nil
        
        self.unsubscribeToKeyboardNotifications()
        
        // some checking of view before view disappears
        self.editMemeView.removeTapRecognizer()
    }
    
    
    // Implemente EditMemeDelegate Methods
    // Delegate method: upload edited Meme (to save or share)
    func uploadEditedMeme() {
        let memedImage = generateMemedImage()
        
        // create activity modal to upload a meme image
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // after completion, save the meme image and dismiss the activity modal
        nextController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                let currView = self.editMemeView
                self.save(currView.topTextField.text!, bottomText: currView.bottomTextField.text!, image: currView.pickedImage.image!, memedImage: memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        // present upload view controller modally with activity view controller
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    // Delegate method: cancel meme editing
    func cancelEditedMeme() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Delegate method: pick an image to edit
    func pickAnImage(type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        
        // pick an image with presenting imagePickercontroller, and set upload button enabled after picking an image
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    // Delegate method: implement UIImagePickerControllerDelegate function didFinishPickingImage
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.editMemeView.loadPickedImage(image)
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
        
        if self.editMemeView.bottomTextField.isFirstResponder() {
            self.editMemeView.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // scroll image view down when keyboard hide during editing bottom text field
    func keyboardWillHide(notification: NSNotification) {
        
        if self.editMemeView.bottomTextField.isFirstResponder() {
            self.editMemeView.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // get height of keyboard
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
        
    }
    
    // Generate Memed Image
    private func generateMemedImage() -> UIImage {
        // Hide tool bar and nav bar
        self.editMemeView.topBottomBarState = EditMemeView.TopBottomBarState.Hidden
        // Generate image from screen
        let memedImage: UIImage = self.editMemeView.generateImage()
        // Show tool bar and nav bar
        self.editMemeView.topBottomBarState = EditMemeView.TopBottomBarState.Displayed
        
        return memedImage
    }
    
    
    // Create and save new Meme
    private func save(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        // create a Meme object and append generated meme to sent meme instance(singleton)
        let meme = Meme(topText: topText, bottomText: bottomText, image: image, memedImage: memedImage)
        sentMemes.appendMeme(meme)
    }
    
}