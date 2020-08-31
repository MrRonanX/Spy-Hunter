//
//  SHCircleButton.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/9/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SHCircleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.04, height: UIScreen.main.bounds.width * 0.04))
        setTitle(title, for: .normal)
    }
    
    
    private func configure() {
        setTitleColor(.white, for: .normal)
        backgroundColor       = Colors.circleButtonColor
        layer.borderWidth     = 1
        layer.masksToBounds   = false
        clipsToBounds         = true
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
