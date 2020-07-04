//
//  SHHeaderViewWithImage.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/3/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SHHeaderViewWithImage: UIView {
    
    let label = SHPageLabel()
    let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configure() {
        addSubview(label)
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .natural
        
        image.tintColor = .systemYellow

        addGradient()
        setupConstraints()
    }
    
    private func addGradient() {
        let labelGradient = CAGradientLayer()
        labelGradient.frame = self.bounds
        labelGradient.colors = [Colors.gradientBlue, Colors.gradientLightBlue].map {$0.cgColor}
        layer.insertSublayer(labelGradient, at: 0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 20),
            image.widthAnchor.constraint(equalToConstant: 20),
            
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            label.widthAnchor.constraint(equalToConstant: bounds.width - 90)
        ])
    }
}
