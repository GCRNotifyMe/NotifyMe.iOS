//
//  CGRectExtension.swift
//  NotifyMe.iOS
//
//  Created by Voltmeter Amperage on 12/8/16.
//  Copyright © 2016 ReVoltApplications. All rights reserved.
//

import UIKit

extension CGRect {
    var centerPoint: CGPoint {
        get {
            return CGPoint(x: self.width/2, y: self.height/2)
        }
    }
}
