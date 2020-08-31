//
//  SHHederView.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/2/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SHHeaderView: UIView {
    
    let label = SHPageLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
       
    private func configure() {
        addSubview(label)
        label.numberOfLines = 0
        
        let labelGradient = CAGradientLayer()
        labelGradient.frame = self.bounds
        labelGradient.colors = [Colors.gradientBlue, Colors.gradientLightBlue].map {$0.cgColor}
        layer.insertSublayer(labelGradient, at: 0)
        
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}
