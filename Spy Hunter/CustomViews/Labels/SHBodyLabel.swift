//
//  SHBodyLabel.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 29.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SHBodyLabel: UILabel {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	convenience init(textAlignment: NSTextAlignment, fontSize: UIFont.TextStyle) {
		self.init(frame: .zero)
		self.textAlignment = textAlignment
		self.font = .preferredFont(forTextStyle: fontSize)
	}
	
	
	private func configure() {
		adjustsFontSizeToFitWidth					= true
		numberOfLines 								= 0
		adjustsFontForContentSizeCategory 			= true
		textColor 									= Colors.rulesTextColor
		translatesAutoresizingMaskIntoConstraints 	= false
	}
}

