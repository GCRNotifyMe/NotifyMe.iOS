//
//  GCRButton.swift
//  NotifyMe.iOS
//
//  Created by Voltmeter Amperage on 11/2/16.
//  Copyright © 2016 ReVoltApplications. All rights reserved.
//

import UIKit

@IBDesignable
class GCRButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        
        get {
            return self.layer.cornerRadius
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
