//
//  CreateAccountViewController.swift
//  NotifyMe.iOS
//
//  Created by Voltmeter Amperage on 12/8/16.
//  Copyright © 2016 ReVoltApplications. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldsView: GCRView!
    @IBOutlet weak var emailTextField: GCRTextField!
    @IBOutlet weak var usernameTextField: GCRTextField!
    @IBOutlet weak var passwordTextField: GCRTextField!
    @IBOutlet weak var passwordConfirmationTextField: GCRTextField!
    
    @IBOutlet weak var createAccountButton: GCRButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        outputLabel.text = ""
        
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Buttons
    
    @IBAction func createButtonPushed(_ sender: Any) {
        // Dismiss the keyboard
        dismissKeyboard()
        
        var errorText:String?
        
        if passwordTextField.text!.characters.count < 8 {
            // Password is too short
            errorText = "Password must be at least 8 characters long."
        }
        
        if passwordTextField.text != passwordConfirmationTextField.text {
            // Passwords dont match
            errorText = "Password fields don't match."
        }
        
        if usernameTextField.text!.characters.count < 1 {
            // Username is too short
            errorText = "Username is required"
        }
        
        if emailTextField.text!.characters.count < 1 {
            // No email
            errorText = "Email is required"
        }
        
        if let error = errorText {
            self.textFieldsView.layer.shake(duration: 1)
            
            // Set ouput label attributes
            self.outputLabel.numberOfLines = 0
            self.outputLabel.text = error
            self.outputLabel.frame.size.height = 0
            
            // Animate expanding output label
            UIView.animate(withDuration: 0.5) {
                self.outputLabel.frame.size.height = 48
            }
            
            return
        }
        
        // Create activity indicator
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.center = createAccountButton.frame.centerPoint
        
        // Set button title to "" and add activity indicator
        createAccountButton.setTitle("", for: [])
        createAccountButton.addSubview(activity)
        
        // Make all items ignore user interaction while waiting for response
        textFieldsView.isUserInteractionEnabled = false
        createAccountButton.isUserInteractionEnabled = false
        cancelButton.isUserInteractionEnabled = false
        
        /*
         This can be used to animate the changing of a labels text
         
         self.outputLabel.text = "Hello"
         self.outputLabel.frame.size.height = 0
         
         UIView.animate(withDuration: 2) {
         self.outputLabel.frame.size.height = 24
         }
         */
        
        
        // Send login items to database
        Database().createAccount(username: usernameTextField.text!,
                                 email: emailTextField.text!,
                                 password: passwordTextField.text!) { (data, response, error) in
                                    var reply: String? = nil
                                    
                                    if data != nil {
                                        reply = String(data: data!, encoding: .utf8)
                                    }
                                    
                                    print(reply)
                                    
                                    // Correctly made account
                                    if reply == "0" {
                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "UnwindToLogin", sender: self)
                                            return
                                        }
                                    }
                                    
                                    var errorText = ""
                                    
                                    // Handle errors...
                                    if reply == nil {
                                        // Network error
                                        errorText = "There was a network error. Please try again."
                                    } else if reply == "-1" {
                                        // Username exists
                                        errorText = "That username already exists."
                                    } else if reply == "-2" {
                                        // Email exists
                                        errorText = "That email is already registered."
                                    } else if reply == "-3" {
                                        // SQL Error
                                        errorText = "There was a server error. Please try again."
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.textFieldsView.layer.shake(duration: 1)
                                        
                                        // Set ouput label attributes
                                        self.outputLabel.numberOfLines = 0
                                        self.outputLabel.text = errorText
                                        self.outputLabel.frame.size.height = 0
                                        
                                        // Listen for user interaction again
                                        self.textFieldsView.isUserInteractionEnabled = true
                                        self.createAccountButton.isUserInteractionEnabled = true
                                        self.cancelButton.isUserInteractionEnabled = true
                                        
                                        // Remove activity viewer from create account button
                                        activity.removeFromSuperview()
                                        
                                        // And set button text back
                                        self.createAccountButton.setTitle("Create Account", for: [])
                                        
                                        // Animate expanding output label
                                        UIView.animate(withDuration: 0.5) {
                                            self.outputLabel.frame.size.height = 48
                                        }
                                    }
                                    
        }
    }
    
    @IBAction func cancelButtonPushed(_ sender: Any) {
        self.performSegue(withIdentifier: "UnwindToLogin", sender: self)
    }
    
    // MARK: - Keyboard
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Text Fields
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            passwordConfirmationTextField.becomeFirstResponder()
        } else if textField === passwordConfirmationTextField {
            createButtonPushed(createAccountButton)
        }
        
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
