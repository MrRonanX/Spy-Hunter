//
//  SHButton.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 29.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SHButton: UIButton {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		// init code
		configure()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
		// Storyboard initialization
	}
	
	
	convenience init(backgroundColor: UIColor, title: String) {
		self.init(frame: .zero)
		self.backgroundColor = backgroundColor
		self.setTitle(title, for: .normal)
	}
	
	
	private func configure() {
		layer.cornerRadius 	= 10
		titleLabel?.font 	= UIFont.preferredFont(forTextStyle: .title2)
    
		translatesAutoresizingMaskIntoConstraints		= false
		titleLabel!.adjustsFontForContentSizeCategory 	= true
		setTitleColor(.white, for: .normal)
	}
    
    
    func set(backgroundColor: UIColor, title: String, cornerRadius: CGFloat, borderWidth: CGFloat) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        layer.cornerRadius  = cornerRadius
        layer.borderWidth   = borderWidth
        layer.borderColor   = UIColor.white.cgColor
        contentEdgeInsets   = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func setShowSpiesButton() {
        titleLabel?.numberOfLines   = 0
        titleLabel?.font            = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel?.textAlignment   = .center
        
        layer.borderColor           = Colors.flamingRed.cgColor
        layer.borderWidth           = 1
        
        alpha                       = 0
        contentEdgeInsets           = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        setTitleColor(Colors.flamingRed, for: .normal)
    }
    
    
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
