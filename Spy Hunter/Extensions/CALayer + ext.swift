//
//  CALayer + ext.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/3/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

extension CALayer {
    
    func flash(duration: TimeInterval) {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.beginTime = CACurrentMediaTime() + 3
        flash.fromValue = NSNumber(value: 0)
        flash.toValue = NSNumber(value: 1)
        flash.duration = duration
        flash.autoreverses = true
        flash.repeatCount = 20
        
        removeAnimation(forKey: "flashAnimation")
        add(flash, forKey: "flashAnimation")
        opacity = 0     // Change the actual data value in the layer to the final value
    }
}
