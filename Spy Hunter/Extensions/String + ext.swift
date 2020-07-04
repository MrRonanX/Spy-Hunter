//
//  String + ext.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 6/30/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

extension String {
    
    func width(withConstrainedHeight height: CGFloat, fontSize: UIFont.TextStyle ) -> CGFloat {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.preferredFont(forTextStyle: fontSize)], context: nil)

            return ceil(boundingBox.width)
        }
    

    func size(OfFont fontSize: UIFont.TextStyle) -> CGFloat {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: fontSize)]).width
     }
 
    
}
