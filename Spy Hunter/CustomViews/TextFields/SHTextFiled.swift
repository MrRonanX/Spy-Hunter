//
//  SHTextFiled.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/2/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SHTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius          = 10
        layer.borderWidth           = 1
        layer.borderColor           = UIColor.systemGray4.cgColor
        
        textColor                   = .label
        tintColor                   = .label
        textAlignment               = .center
        font                        = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth   = true
        minimumFontSize             = 12
        
        backgroundColor             = Colors.backgroundColor
        autocorrectionType          = .no
        returnKeyType               = .continue
        placeholder                 = "Enter a username"
        keyboardType                = .default
    }
}

