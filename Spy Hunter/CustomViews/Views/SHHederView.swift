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
        label.frame = self.bounds
        label.pinToEdges(of: self)
        
        let labelGradient = CAGradientLayer()
        labelGradient.frame = self.bounds
        labelGradient.colors = [Colors.gradientBlue, Colors.gradientLightBlue].map {$0.cgColor}
        layer.insertSublayer(labelGradient, at: 0)
        
    }
}
