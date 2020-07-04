//
//  File.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 29.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SHTitleLabel: UILabel {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
		
	
	private func configure() {
		textColor 									= .white
		textAlignment								= .center
		font										= .preferredFont(forTextStyle: .title1)
		adjustsFontForContentSizeCategory 			= true
		adjustsFontSizeToFitWidth					= true
		translatesAutoresizingMaskIntoConstraints 	= false
	}
}
