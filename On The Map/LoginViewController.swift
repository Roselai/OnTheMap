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
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        if (usernameTextField.text! .isEmpty || passwordTextfield.text! .isEmpty) {
            loginButton.enabled = false
        }
        loginButton.enabled = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextfield.delegate = self
        
        if usernameTextField.text == nil || passwordTextfield.text == nil {
            loginButton.enabled = false
        } else {
            loginButton.enabled = true
        }
        
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
        textField.textColor = UIColor.blackColor()
        textField.text = ""
        
        if textField .isEqual(passwordTextfield) {
            passwordTextfield.secureTextEntry =  true
        }
        
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
    
    
    
    // MARK: Private functions
    
    private func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
}