//
//  buttonExtension.swift
//  testTableView
//
//  Created by Roman Kavinskyi on 15.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

extension UIButton {
    
    func pulseAnimation() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 0.09
        animation.fromValue = 1
        animation.toValue = 0.85
        animation.autoreverses = true
        animation.repeatCount = 1
        animation.initialVelocity = 0
        animation.damping = 0
        
        layer.add(animation, forKey: nil)
    }
}
