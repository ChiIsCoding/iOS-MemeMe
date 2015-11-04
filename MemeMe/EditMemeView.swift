//
//  EditMemeView.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/23/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

// Delegate to pass user interaction to view controller
protocol EditMemeDelegate: UITextFieldDelegate, UIImagePickerControllerDelegate {
    func uploadEditedMeme();
    func cancelEditedMeme();
    func pickAnImage(type: UIImagePickerControllerSourceType);
    func textFieldDidBeginEditing(textField: UITextField);
    func textFieldShouldReturn(textField: UITextField) -> Bool;
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?);
}


class EditMemeView: UIView {
    
    lazy var topTextField = UITextField()
    lazy var bottomTextField = UITextField()
    lazy var pickedImage = UIImageView()
    private var navBar: UIToolbar!
    private var toolBar: UIToolbar!
    
    var tapRecognizer: UITapGestureRecognizer?
    
    var delegate: EditMemeDelegate?
    
    // status of upload button (enabled / disabled)
    enum UploadButtonEnabled {
        case Disabled
        case Enabled
    }
    
    // status of uploadButton
    var uploadButtonStatus: UploadButtonEnabled = UploadButtonEnabled.Disabled {
        didSet {
            setUploadButton()
        }
    }
    
    // set UI status of upload button
    private func setUploadButton() {
        if let items = self.navBar.items {
            let startIndex = items.startIndex
            switch uploadButtonStatus {
            case .Disabled:
                items[startIndex].enabled = false
            case .Enabled:
                items[startIndex].enabled = true
            }
        }
    }
    
    
    // Enum determine whether top bar and bottom bar are displayed
    enum TopBottomBarStatus {
        case Hidden;
        case Displayed;
    }
    
    var topBottomBarDisplay: TopBottomBarStatus = TopBottomBarStatus.Displayed {
        didSet{
            setBarStatus()
        }
    }
    
    private func setBarStatus() {
        switch topBottomBarDisplay {
        case .Displayed:
            self.navBar.hidden = false
            self.toolBar.hidden = false
        case .Hidden:
            self.navBar.hidden = true
            self.toolBar.hidden = true
        }
    }
    
    
    // text attribute for memed text field
    let memeEditTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 7.0
    ]
    

    // initialize custome view
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        // Set image view
        pickedImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pickedImage)
        // Set image constraints
        let pickedImageHorizontalConstraint = pickedImage.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let pickedImageVerticalConstraint = pickedImage.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor)
        let pickedImageHeightConstraint = pickedImage.heightAnchor.constraintLessThanOrEqualToAnchor(self.heightAnchor)
        let pickedImageWidthConstraint = pickedImage.widthAnchor.constraintLessThanOrEqualToAnchor(self.widthAnchor)
        NSLayoutConstraint.activateConstraints([pickedImageHorizontalConstraint, pickedImageVerticalConstraint, pickedImageHeightConstraint, pickedImageWidthConstraint])
        
        
        // Add tool bar at the top
        navBar = UIToolbar()
        navBar.backgroundColor = UIColor.blueColor()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(navBar)
        // Set tool bar constraints
        let navBarWidthConstraint = navBar.widthAnchor.constraintEqualToAnchor(self.widthAnchor)
        let navBarHeightConstraint = navBar.heightAnchor.constraintEqualToAnchor(nil, constant: 50)
        let navBarVerticalConstraint = navBar.topAnchor.constraintEqualToAnchor(self.topAnchor)
        NSLayoutConstraint.activateConstraints([navBarWidthConstraint, navBarHeightConstraint, navBarVerticalConstraint])
        // add upload button and cancel button on nav bar
        let uploadButton = UIBarButtonItem(title: "Upload", style: .Done, target: self, action: "uploadMeme")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: "cancelMeme")
        let navFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil);
        navBar.items = [uploadButton, navFlexibleSpace, cancelButton]

        
        // Add bottom tool bar
        toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor.blueColor()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toolBar)
        // Set bottom tool bar constraints
        let toolBarWidthConstraint = toolBar.widthAnchor.constraintEqualToAnchor(self.widthAnchor)
        let toolBarHeightConstraint = toolBar.heightAnchor.constraintEqualToAnchor(nil, constant: 50)
        let toolBarVerticalConstraint = toolBar.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor)
        NSLayoutConstraint.activateConstraints([toolBarWidthConstraint, toolBarHeightConstraint, toolBarVerticalConstraint])
        // add picking image from album and camera buttons on tool bar
        let albumButton = UIBarButtonItem(title: "Album", style: .Done, target: self, action: "pickAlbumImage")
        let cameraButton = UIBarButtonItem(title: "Camera", style: .Done, target: self, action: "pickCameraImage")
        // disable camera button if camera not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        let toolFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil);
        toolBar.items = [albumButton, toolFlexibleSpace, cameraButton]
        
        
        // Add top text field
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        topTextField.defaultTextAttributes = memeEditTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.adjustsFontSizeToFitWidth = true
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        topTextField.placeholder = "TOP"
        self.addSubview(topTextField)
        // Set top text field contraint
        let topTFHorizontalConstraint = topTextField.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let topTFVerticalConstraint = topTextField.topAnchor.constraintGreaterThanOrEqualToAnchor(self.navBar.bottomAnchor, constant: 20)
        let topTFWidthConstraint = topTextField.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -10)
        NSLayoutConstraint.activateConstraints([topTFHorizontalConstraint, topTFVerticalConstraint, topTFWidthConstraint])
        
        
        // Set bottom text field
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomTextField.defaultTextAttributes = memeEditTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomTextField.placeholder = "BOTTOM"
        self.addSubview(bottomTextField)
        // Set bottom text field contraints
        let bottomTFHorizontalConstraint = bottomTextField.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let bottomTFVerticalConstraint = bottomTextField.bottomAnchor.constraintGreaterThanOrEqualToAnchor(self.toolBar.topAnchor, constant: -20)
        let bottomTFWidthConstraint = bottomTextField.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -10)
        NSLayoutConstraint.activateConstraints([bottomTFHorizontalConstraint, bottomTFVerticalConstraint, bottomTFWidthConstraint])
        
        // Initialize tap recognizer to handle tap to resign keyboard
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1

    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // functino to handle single tap
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    
    // upload meme when clicking upload button on nav bar
    func uploadMeme() {
        dismissAnyVisibleKeyboards()

        if let delegate = self.delegate {
            delegate.uploadEditedMeme()
        } else {
            NSLog("Delegate function for uploading Meme Image is not ready")
        }
    }
    
    // cancel meme editing when clicking upload button on nav bar
    func cancelMeme() {
        dismissAnyVisibleKeyboards()

        if let delegate = self.delegate {
            delegate.cancelEditedMeme()
        } else {
            NSLog("Delegate function for canceling edit Meme page is not ready")
        }
    }
    
    // pick photo from album when cliking Album button on tool bar
    func pickAlbumImage() {
        dismissAnyVisibleKeyboards()

        if let delegate = self.delegate {
            delegate.pickAnImage(.PhotoLibrary)
        } else {
            NSLog("Delegate for picking an image for Meme Editing is not ready")
        }
    }
    
    // pick photo from album when cliking Camera button on tool bar
    func pickCameraImage() {
        dismissAnyVisibleKeyboards()
        
        if let delegate = self.delegate {
            delegate.pickAnImage(.Camera)
        } else {
            NSLog("Delegate for picking an image for Meme Editing is not ready")
        }
    }
    
    // load picked image for editing
    func loadPickedImage(image: UIImage?) {
        if let image = image {
            self.pickedImage.image = image
            self.pickedImage.contentMode = .ScaleAspectFit
        }
    }
    
    private func dismissAnyVisibleKeyboards() {
        if topTextField.isFirstResponder() || bottomTextField.isFirstResponder() {
            self.endEditing(true)
        }
    }
    
    
    // check and update status when view will appear
    func viewWillAppearCheck() {
        self.topTextField.placeholder = "TOP"
        self.bottomTextField.placeholder = "BOTTOM"
        if let _ = self.pickedImage.image {
            uploadButtonStatus = UploadButtonEnabled.Enabled
        } else {
            uploadButtonStatus = UploadButtonEnabled.Disabled
        }
        self.addGestureRecognizer(tapRecognizer!)
    }
    
    
    // remove gesture recognizer when view disappears
    func viewWillDisappearCheck() {
        self.removeGestureRecognizer(tapRecognizer!)
    }

}



