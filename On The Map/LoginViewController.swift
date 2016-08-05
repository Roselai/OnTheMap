//
//  LoginViewController.swift
//  On The Map
//
//  Created by Shukti Shaikh on 7/26/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    
    var keyboardHidden = true
    
    
    override func viewWillAppear(animated: Bool) {
        
        if (usernameTextField.text! .isEmpty || passwordTextfield.text! .isEmpty) {
            loginButton.enabled = false
        }
        loginButton.enabled = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugLabel.text = nil
        usernameTextField.delegate = self
        passwordTextfield.delegate = self
        
        if usernameTextField.text == nil || passwordTextfield.text == nil {
            loginButton.enabled = false
        } else {
            loginButton.enabled = true
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        // unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func login(sender: UIButton) {
        
        loginButton.enabled = false
        
        UdacityClient.sharedInstance().logInToUdacity(usernameTextField.text!, password: passwordTextfield.text!) { (success, errorString) in
            
           performUIUpdatesOnMain{
                if let error = errorString {
                    
                    let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: {self.loginButton.enabled = true})
                    
                } else {
                    self.performSegueWithIdentifier("loggedIn", sender: self)
                }
            }
            
            
        }
        
    }
    
    @IBAction func signUpPressed(sender: UIButton) {
        
        if let signUpURL = NSURL(string: "https://www.udacity.com/account/auth#!/signup")  {
            UIApplication.sharedApplication().openURL(signUpURL)
        }
        
    }
    
    
    
    
    // MARK: Textfield Delegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        
        textField.text = ""
        
        if textField .isEqual(passwordTextfield) {
            passwordTextfield.secureTextEntry =  true
        }
        
        //subscribeToKeyboardNotifications()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField .isEqual(usernameTextField) {
            let email: String = textField.text!
            if !isValidEmail(email){
                textField.text = "Enter a valid E-mail"
                textField.textColor = UIColor.redColor()
                
            }
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: KEYBOARD FUNCTIONS
    func keyboardWillShow(notification: NSNotification) {
        let keyboardOrigin = getKeyboardHeight(notification)
        let textFieldOrigin = passwordTextfield.frame.origin.y + passwordTextfield.frame.height
        
        if textFieldOrigin  > -keyboardOrigin {
            passwordTextfield.frame.origin.y = passwordTextfield.frame.origin.y - (textFieldOrigin - keyboardOrigin)
            keyboardHidden = false
        }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        view.frame.origin.y = 0
        keyboardHidden = true
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        //return keyboardSize.CGRectValue().height
        return keyboardSize.CGRectValue().origin.y
    }
    
    //MARK: SUBSCRIPTIONS
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow)    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide)    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Private functions
    
    private func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
}