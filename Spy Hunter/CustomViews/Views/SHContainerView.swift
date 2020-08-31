//
//  SHContainerView.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 8/11/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SHContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor       = .systemBackground
        layer.cornerRadius    = 16
        layer.borderWidth     = 2
        layer.borderColor     = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
