//
//  SHPageLabel.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/1/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SHPageLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textColor: UIColor, textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textColor      = textColor
        self.textAlignment  = textAlignment
    }
    
    
    private func configure() {
        textColor                                    = .white
        textAlignment                                = .center
        backgroundColor                              = .clear
        font                                         = .preferredFont(forTextStyle: .title2)
        
        adjustsFontForContentSizeCategory            = true
        adjustsFontSizeToFitWidth                    = true
        translatesAutoresizingMaskIntoConstraints    = false
    }
}
