//
//  EditMemeView.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/23/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

// Delegate to pass user interaction to view controller
protocol EditMemeDelegate: class {
    func uploadEditedMeme();
    func cancelEditedMeme();
    func pickAnImage(type: UIImagePickerControllerSourceType);
}


class EditMemeView: UIView, UITextFieldDelegate {
    
    lazy var topTextField = UITextField()
    lazy var bottomTextField = UITextField()
    lazy var pickedImage = UIImageView()
    private var navBar: UIToolbar!
    private var toolBar: UIToolbar!
    
    var tapRecognizer: UITapGestureRecognizer?
    
    weak var delegate: EditMemeDelegate?
    
    // status of upload button (enabled / disabled)
    enum UploadButtonState {
        case Disabled
        case Enabled
    }
    
    // status of uploadButton
    var uploadButtonState: UploadButtonState = UploadButtonState.Disabled {
        didSet {
            updateUploadButtonState()
        }
    }
    
    // set UI status of upload button
    private func updateUploadButtonState() {
        if let items = self.navBar.items {
            let startIndex = items.startIndex
            switch uploadButtonState {
            case .Disabled:
                items[startIndex].enabled = false
            case .Enabled:
                items[startIndex].enabled = true
            }
        }
    }
    
    
    // Enum determine whether top bar and bottom bar are displayed
    enum TopBottomBarState {
        case Hidden;
        case Displayed;
    }
    
    var topBottomBarState: TopBottomBarState = TopBottomBarState.Displayed {
        didSet{
            updateTopBottomBarState()
        }
    }
    
    private func updateTopBottomBarState() {
        switch topBottomBarState {
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
        
        // Initialize UI components
        self.setUpAppearance()  // bg color
        self.setUpImageView()
        self.setUpTopToolBar()
        self.setUpBottomToolBar()
        self.setUpTopTextField()
        self.setUpBottomTextField()
        
        // Initialize tap recognizer to handle user tap
        self.setUpTapRecognizer()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    // MARK - Text Field Delegate Implementation
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Dismiss visible keyboard
    private func dismissAnyVisibleKeyboards() {
        if topTextField.isFirstResponder() || bottomTextField.isFirstResponder() {
            self.endEditing(true)
        }
    }
    
    
    // reset text field place holder
    func resetTextFieldPlacehoder() {
        self.topTextField.placeholder = "TOP"
        self.bottomTextField.placeholder = "BOTTOM"
    }
    
    // determine upload button state depending on whether there is image ready
    func updateUploadButtonStateWithImageState() {
        if let _ = self.pickedImage.image {
            uploadButtonState = UploadButtonState.Enabled
        } else {
            uploadButtonState = UploadButtonState.Disabled
        }
    }
    
    // add gesture recogizaer for tap
    func addTapRecognizer() {
        self.addGestureRecognizer(tapRecognizer!)
    }
    
    // remove gesture recognizer when view disappears
    func removeTapRecognizer() {
        self.removeGestureRecognizer(tapRecognizer!)
    }
    
    // Generate image from screen
    func generateImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.frame.size)
        self.drawViewHierarchyInRect(self.frame, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    // MARK: - Set up UI components
    
    private func setUpAppearance() {
        self.backgroundColor = UIColor.whiteColor()
    }
    
    private func setUpImageView() {
        // Add image view
        pickedImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pickedImage)
        // Set image view constraints
        let pickedImageHorizontalConstraint = pickedImage.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let pickedImageVerticalConstraint = pickedImage.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor)
        let pickedImageHeightConstraint = pickedImage.heightAnchor.constraintLessThanOrEqualToAnchor(self.heightAnchor)
        let pickedImageWidthConstraint = pickedImage.widthAnchor.constraintLessThanOrEqualToAnchor(self.widthAnchor)
        NSLayoutConstraint.activateConstraints([pickedImageHorizontalConstraint, pickedImageVerticalConstraint, pickedImageHeightConstraint, pickedImageWidthConstraint])
    }
    
    private func setUpTopToolBar() {
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
    }
    
    private func setUpBottomToolBar() {
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
    }
    
    private func setUpTopTextField() {
        // Add top text field
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        topTextField.defaultTextAttributes = memeEditTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.adjustsFontSizeToFitWidth = true
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        topTextField.placeholder = "TOP"
        topTextField.delegate = self
        self.addSubview(topTextField)
        // Set top text field contraint
        let topTFHorizontalConstraint = topTextField.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let topTFVerticalConstraint = topTextField.topAnchor.constraintGreaterThanOrEqualToAnchor(self.navBar.bottomAnchor, constant: 20)
        let topTFWidthConstraint = topTextField.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -10)
        NSLayoutConstraint.activateConstraints([topTFHorizontalConstraint, topTFVerticalConstraint, topTFWidthConstraint])
    }
    
    private func setUpBottomTextField() {
        // Set bottom text field
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomTextField.defaultTextAttributes = memeEditTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomTextField.placeholder = "BOTTOM"
        bottomTextField.delegate = self
        self.addSubview(bottomTextField)
        // Set bottom text field contraints
        let bottomTFHorizontalConstraint = bottomTextField.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let bottomTFVerticalConstraint = bottomTextField.bottomAnchor.constraintGreaterThanOrEqualToAnchor(self.toolBar.topAnchor, constant: -20)
        let bottomTFWidthConstraint = bottomTextField.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -10)
        NSLayoutConstraint.activateConstraints([bottomTFHorizontalConstraint, bottomTFVerticalConstraint, bottomTFWidthConstraint])
    }
    
    // set up tap recognizer
    private func setUpTapRecognizer() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    // functino to handle single tap
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    

}



