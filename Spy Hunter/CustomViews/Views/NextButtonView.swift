//
//  NextButtonView.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/2/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class NextButtonView: UIView {
    
    let button = SHButton(backgroundColor: Colors.buttonColor, title: Strings().next)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = Colors.backgroundColor
        addSubview(button)
        translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 13
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        button.setShadow()
    }
}
