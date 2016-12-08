//
//  GCRTextField.swift
//  NotifyMe.iOS
//
//  Created by Voltmeter Amperage on 11/2/16.
//  Copyright © 2016 ReVoltApplications. All rights reserved.
//

import UIKit

@IBDesignable
class GCRTextField: UITextField {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable
    override var placeholder: String? {
        get {
            return super.placeholder
        }
        set {
            super.placeholder = newValue
            if newValue != nil {
                self.attributedPlaceholder = NSAttributedString(string: newValue!,
                                                                attributes: [NSFontAttributeName : UIFont(name: "Avenir-Book", size: 16)!])
            }
        }
    }
    
    @IBInspectable
    var leftImage: UIImage? {
        didSet {
            if leftImage == nil {
                leftView = nil
                return
            }
            
            let leftImageContainer = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: 41,
                                                      height: 41))
            let leftImageView = UIImageView(frame: CGRect(x: 9,
                                                      y: 9,
                                                      width: 23,
                                                      height: 23))
            
            leftImageView.image = leftImage?.withRenderingMode(.alwaysTemplate)
            leftImageView.contentMode = .scaleAspectFit
            leftImageContainer.addSubview(leftImageView)
            leftImageContainer.backgroundColor = UIColor(white: 0.9, alpha: 1)
            self.leftViewMode = UITextFieldViewMode.always
            self.leftView = leftImageContainer
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
