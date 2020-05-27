//
//  SpyView.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SpyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        StylishSpy.drawCanvas1(frame: frame, resizing: .aspectFit)
    }
}
