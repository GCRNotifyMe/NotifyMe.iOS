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
    
    // You know, the view with all the login stuff (username, pword, button)
    @IBOutlet weak var loginStuff: UIView!
    
    @IBOutlet weak var loginView: GCRView!
    @IBOutlet weak var loginButton: GCRButton!
    
    var logoViewInitialSize: CGSize!
    var logoViewInitialOrigin: CGPoint!
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
        
        logoViewInitialSize = logoView.frame.size
        logoViewInitialOrigin = logoView.frame.origin
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
        
        let duration = Double(userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as? NSNumber ?? 0.5)
        
        let useableSize = self.view.frame.height - keyboardHeight
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.15,
                       options: .curveLinear,
                       animations: {
                        self.loginStuff.frame.origin.y = useableSize/2 - self.loginStuff.frame.height/2
                        self.logoView.frame.size = CGSize(width: 0, height: 0)
                        self.logoView.frame.origin.x = self.view.frame.midX
        }, completion: nil)
    }
    
    func keyboardWillHide(notification:NSNotification)
    {
        print("Keyboard hidden")
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let duration = Double(userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as? NSNumber ?? 0.5)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.15, options: .curveLinear, animations: { 
            self.loginStuff.frame.origin = self.loginStuffInitialOrigin
            self.logoView.frame.size = self.logoViewInitialSize
            self.logoView.frame.origin = self.logoViewInitialOrigin
        }, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Buttons
    
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
