//
//  LoginViewController.swift
//  NotifyMe.iOS
//
//  Created by Voltmeter Amperage on 12/7/16.
//  Copyright © 2016 ReVoltApplications. All rights reserved.
//

import UIKit
import UserNotifications

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var firstLoad = true

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // You know, the view with all the login stuff (username, pword, button)
    @IBOutlet weak var loginStuff: UIView!
    @IBOutlet weak var usernameTextField: GCRTextField!
    @IBOutlet weak var passwordTextField: GCRTextField!
    @IBOutlet weak var centerLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var loginView: GCRView!
    @IBOutlet weak var loginViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: GCRButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    var deviceNameTextField: GCRTextField?
    
    var defaultEasyTip: EasyTipView?
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
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(recognizer)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Set text field delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        outputLabel.text = ""
        outputLabel.numberOfLines = 0
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
    
    // MARK: Text Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            loginButtonPushed(loginButton)
        } else {
            // Called from name device text field
        }
        
        return true
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
                DispatchQueue.main.async {
                    self.outputLabel.text = "Please use the email sent to you to verify your account."
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            } else if reply == "-2" {
                // User does not exist
                DispatchQueue.main.async {
                    self.outputLabel.text = "Your username/password are incorrect. Please try again."
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            } else {
                // Logged in
                
                // Parse the return. Multiple lines means we have a device name for this device.
                let items = reply!.components(separatedBy: "\n")
                
                if items.count == 1 {
                    // Display a field to enter the device name
                    DispatchQueue.main.async {
                        self.createAccountButton.alpha = 0
                        self.createAccountButton.isUserInteractionEnabled = false
                        
                        var origin = self.loginView.frame.origin
                        origin.x += self.view.frame.width
                        
                        let size = self.loginView.frame.size
                        
                        let nameView = UIView(frame: CGRect(origin: origin, size: size))
                        
                        let textField = GCRTextField(frame: CGRect(x: 0, y: 0, width: nameView.frame.width, height: 41))
                        textField.backgroundColor = UIColor.white
                        textField.leftImage = UIImage(named: "id card.png")!
                        textField.cornerRadius = 10
                        textField.placeholder = "Give this device a name"
                        textField.clipsToBounds = true
                        textField.returnKeyType = .go
                        
                        self.deviceNameTextField = textField
                        
                        nameView.addSubview(textField)
                        
                        let defaultSwitch = UISwitch()
                        defaultSwitch.frame.origin.x = nameView.frame.width - defaultSwitch.frame.width
                        defaultSwitch.frame.origin.y = nameView.frame.height - defaultSwitch.frame.height
                        defaultSwitch.isOn = false
                        
                        nameView.addSubview(defaultSwitch)
                        
                        let defaultLabel = UILabel()
                        defaultLabel.font = UIFont(name: "Avenir Next", size: 17)!
                        defaultLabel.textColor = .white
                        defaultLabel.text = "Default device:"
                        defaultLabel.sizeToFit()
                        defaultLabel.center = defaultSwitch.center
                        defaultLabel.frame.origin.x = defaultSwitch.frame.origin.x - 8 - defaultLabel.frame.width
                        
                        nameView.addSubview(defaultLabel)
                        
                        // Add an image for help about what the default device(s) are
                        // Should provide a popup text view to display the help
                        let questionButton = UIButton()
                        questionButton.frame.size = CGSize(width: 16, height: 16)
                        questionButton.center.y = defaultSwitch.center.y
                        questionButton.frame.origin.x = defaultLabel.frame.origin.x - 8 - questionButton.frame.width
                        
                        let questionImage = UIImage(named: "Question mark.png")?.withRenderingMode(.alwaysTemplate)
                        
                        questionButton.setImage(questionImage, for: [.normal])
                        questionButton.tintColor = UIColor.white
                        
                        questionButton.addTarget(self, action: #selector(self.showDefaultDeviceHelp(_:)), for: .touchUpInside)
                        
                        nameView.addSubview(questionButton)
                        
                        self.loginStuff.addSubview(nameView)
                        
                        self.loginButton.setTitle("Lets go!", for: [])
                        self.loginButton.removeTarget(nil, action: nil, for: .allEvents)
                        self.loginButton.addTarget(self, action: #selector(self.createDevice), for: .touchUpInside)
                        
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                            self.loginViewLeftConstraint.constant -= self.view.frame.width
                            self.loginViewRightConstraint.constant += self.view.frame.width
                            self.view.layoutIfNeeded()
                            
                            nameView.frame.origin.x -= self.view.frame.width
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
    
    func createDevice() {
        dismissKeyboard()
        
        (UIApplication.shared.delegate as! AppDelegate).deviceName = deviceNameTextField?.text
        
        loginButton.setTitle("", for: [])
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.center = loginButton.frame.centerPoint
        loginButton.addSubview(activity)
        
        self.view.isUserInteractionEnabled = false
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    @IBAction func createAccountButtonPushed(_ sender: Any) {
        self.performSegue(withIdentifier: "SegueToCreateAccount", sender: self)
    }
    
    func showDefaultDeviceHelp(_ button: UIButton) {
        defaultEasyTip?.dismiss()
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.cornerRadius = 10
        preferences.drawing.backgroundColor = UIColor(netHex: 0xc6c5c5)
        preferences.drawing.borderColor = UIColor(netHex: 0xb8c4bb)
        preferences.drawing.borderWidth = 1
        preferences.drawing.font = UIFont(name: "Avenir Next", size: 17)!
        
        defaultEasyTip = EasyTipView(text: "All defualt devices on an account recieve messages when no specific device is specified.",
                                     preferences: preferences,
                                     delegate: nil)
        
        defaultEasyTip?.show(animated: true, forView: button)//, withinSuperview: self.view)
        
//        EasyTipView.show(aimated: true, forView: gesture, withinSuperview: self.view, text: "Testing!", preferences: preferences, delegate: nil)
    }
    
    func backgroundTap() {
        dismissKeyboard()
        defaultEasyTip?.dismiss()
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
