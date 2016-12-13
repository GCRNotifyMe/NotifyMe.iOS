//
//  LoginViewController.swift
//  NotifyMe.iOS
//
//  Created by Voltmeter Amperage on 12/7/16.
//  Copyright © 2016 ReVoltApplications. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var firstLoad = true

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // You know, the view with all the login stuff (username, pword, button)
    @IBOutlet weak var loginStuff: UIView!
    @IBOutlet weak var usernameTextField: GCRTextField!
    @IBOutlet weak var passwordTextField: GCRTextField!
    @IBOutlet weak var centerLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginView: GCRView!
    @IBOutlet weak var loginViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: GCRButton!
    
    // Also used with shrinking the logo
//    var logoViewInitialSize: CGSize!
//    var logoViewInitialOrigin: CGPoint!
//    var logoImageInitialSize: CGSize!
    var loginStuffInitialOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Dismiss the keyboard on tap
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(recognizer)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Dont continue with this method if its already been run
        if !firstLoad {
            return
        }
        
        // Setting values needed for the shrinking and expanding of the logo. Not used anymore
//        logoViewInitialSize = logoView.frame.size
//        logoViewInitialOrigin = logoView.frame.origin
//        logoImageInitialSize = logoImageView.frame.size
        loginStuffInitialOrigin = loginStuff.frame.origin
        
        firstLoad = false
        
        // Center the logo and hide the other content
        logoView.center = self.view.center
        loginView.alpha = 0
        loginButton.alpha = 0
        
        // Move the logo
        UIView.animate(withDuration: 1,
                       delay: 0.5,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.15,
                       options: .curveEaseInOut,
                       animations: {() in
                        self.logoView.frame.origin.y = 70
        }, completion: nil)
        
        // Fade in login button
        UIView.animate(withDuration: 0.5,
                       delay: 0.75,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.15,
                       options: .curveLinear,
                       animations: {() in
                        self.loginButton.alpha = 1
        }, completion: nil)
        
        // Fade in view with usernmae and pword
        UIView.animate(withDuration: 0.5,
                       delay: 1.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.15,
                       options: .curveLinear,
                       animations: { 
                        self.loginView.alpha = 1
        }, completion: nil)
    }
    
    // MARK: - Keyboard methods
    
    func keyboardWillChange(notification:NSNotification)
    {
        print("Keyboard size changed")
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        print(self)
        
        let duration = Double(userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as? NSNumber ?? 0.5)
        
//        let useableSize = self.view.frame.height - keyboardHeight
        
        self.centerLayoutConstraint.constant = (keyboardHeight / 2) * -1
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.15,
                       options: .curveLinear,
                       animations: {
//                        self.loginStuff.frame.origin.y = useableSize/2 - self.loginStuff.frame.height/2
                        
                        // This origionally shrank the size of the logo, but fading is so much easier and looks better
//                        self.logoView.frame.size = CGSize(width: 0, height: 0)
//                        self.logoView.frame.origin.x = self.view.frame.midX
//                        
//                        self.logoImageView.frame.size = CGSize(width: 0, height: 0)
//                        self.logoImageView.center = self.logoView.frame.centerPoint
                        
                        self.logoImageView.alpha = 0
                        
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func keyboardWillHide(notification:NSNotification)
    {
        print("Keyboard hidden")
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let duration = Double(userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as? NSNumber ?? 0.5)
        
        self.centerLayoutConstraint.constant = 0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.15, options: .curveLinear, animations: { 
//            self.loginStuff.frame.origin = self.loginStuffInitialOrigin
            
            // This un-shrank the logo. See above
//            self.logoView.frame.size = self.logoViewInitialSize
//            self.logoView.frame.origin = self.logoViewInitialOrigin
//            
//            self.logoImageView.frame.size = self.logoImageInitialSize
//            self.logoImageView.center = self.logoView.frame.centerPoint
            
            self.logoImageView.alpha = 1
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Buttons
    
    @IBAction func loginButtonPushed(_ sender: Any) {
        let defaults = UserDefaults()
        let id = defaults.string(forKey: "DEVICEID") ?? ""
        
        dismissKeyboard()
        
        loginButton.setTitle("", for: [])
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.center = loginButton.frame.centerPoint
        loginButton.addSubview(activity)
        
        self.view.isUserInteractionEnabled = false
        
        Database().login(username: usernameTextField.text!, password: passwordTextField.text!, deviceID: id) { (data, response, error) in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                
                activity.removeFromSuperview()
                self.loginButton.setTitle("Login", for: [])
            }
            
            var reply: String? = nil
            
            if data != nil {
                reply = String(data: data!, encoding: .utf8)
            }
            
            print(reply)
            
            if reply == "-1" {
                // User has not verified their email
            } else if reply == "-2" {
                // User does not exist
            } else {
                // Logged in
                
                // Parse the return. Multiple lines means we have a device name for this device.
                let items = reply!.components(separatedBy: "\n")
                
                if items.count == 1 {
                    // Display a field to enter the device name
                    DispatchQueue.main.async {
                        var origin = self.loginView.frame.origin
                        origin.x += self.view.frame.width
                        
                        let size = CGSize(width: self.loginView.frame.width, height: 41)
                        
                        let textField = GCRTextField(frame: CGRect(origin: origin, size: size))
                        textField.backgroundColor = UIColor.white
                        textField.leftImage = UIImage(named: "id card.png")!
                        textField.cornerRadius = 10
                        textField.placeholder = "Give this device a name"
                        textField.clipsToBounds = true
                        self.loginStuff.addSubview(textField)
                        
                        self.loginButton.setTitle("Name", for: [])
                        
                        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                            self.loginViewLeftConstraint.constant -= self.view.frame.width
                            self.loginViewRightConstraint.constant += self.view.frame.width
                            self.view.layoutIfNeeded()
                            
                            textField.frame.origin.x -= self.view.frame.width
                        }, completion: { (completed) in
                            self.loginView.alpha = 0
                        })
                    }
                    
                } else {
                    // We already have a device name!
                }
            }
        }
    }
    
    @IBAction func createAccountButtonPushed(_ sender: Any) {
        self.performSegue(withIdentifier: "SegueToCreateAccount", sender: self)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToLoginView(segue: UIStoryboardSegue) {
        
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
