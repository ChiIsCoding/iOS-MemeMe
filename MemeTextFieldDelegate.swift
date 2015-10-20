//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/17/15.
//  Copyright © 2015 cz. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // clear placeholder once start editing
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = ""
    }
    
    // resign first responder once hit return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}