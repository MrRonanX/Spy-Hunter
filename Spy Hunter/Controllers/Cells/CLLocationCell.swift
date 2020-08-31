//
//  CLLocationCell.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/6/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit


class CLLocationCell: UICollectionViewCell {
    
    static let reuseID  = "reuseID"
    
    let label           = SHBodyLabel(textAlignment: .center, fontSize: .callout)
    let plusImage       = UIImageView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(label)
        backgroundColor = Colors.locationBackground
        layer.cornerRadius  = 5
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
    
    
    func set(location: CellData) {
        label.textColor     = .black
        label.text = location.locationName
        if location.isChosen == true { layer.borderWidth = 2 } else { layer.borderWidth = 0.5 }
    }
    
    
    func setAddButton() {
        label.removeFromSuperview()
        addSubview(plusImage)
        
        plusImage.image = Images.add
        plusImage.tintColor = .black
        
        layer.borderWidth = 0.5
        
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                   plusImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                   plusImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                   plusImage.widthAnchor.constraint(equalToConstant: 30),
                   plusImage.heightAnchor.constraint(equalToConstant: 30)
               ])
        
       
    }
}
