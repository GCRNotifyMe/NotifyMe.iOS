//
//  ViewController.swift
//  NotifyMe.iOS
//
//  Created by Voltmeter Amperage on 11/2/16.
//  Copyright © 2016 ReVoltApplications. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var usernameTextField: GCRTextField!
    @IBOutlet weak var emailTextField: GCRTextField!
    @IBOutlet weak var passwordTextField: GCRTextField!
    @IBOutlet weak var confirmPasswordTextField: GCRTextField!
    @IBOutlet weak var createButton: GCRButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        logoView.center = self.view.center
        usernameTextField.alpha = 0
        emailTextField.alpha = 0
        passwordTextField.alpha = 0
        confirmPasswordTextField.alpha = 0
        createButton.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {() in
            self.logoView.frame.origin.y = 50
        }, completion: {(completed) in
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {() in
            self.createButton.alpha = 1
        }, completion: {(completed) in
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut, animations: {() in
            self.confirmPasswordTextField.alpha = 1
        }, completion: {(completed) in
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.4, options: .curveEaseInOut, animations: {() in
            self.passwordTextField.alpha = 1
        }, completion: {(completed) in
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.6, options: .curveEaseInOut, animations: {() in
            self.emailTextField.alpha = 1
        }, completion: {(completed) in
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.8, options: .curveEaseInOut, animations: {() in
            self.usernameTextField.alpha = 1
        }, completion: {(completed) in
            
        })
    }
    
    @IBAction func textFieldEditingBegan(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {() in
            self.logoView.frame.size = CGSize(width: 0, height: 0)
        }, completion: {(completed) in
            
        })
    }

}

