//
//  UIHelper.swift
//  GHFollowers
//
//  Created by jason on 1/30/20.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

enum UIHelper {
    
    static func createThreeColFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width =  view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 4
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    static func setupBackButton() -> UIBarButtonItem {
        let backItem = UIBarButtonItem()
        backItem.title = StringFiles().back
        return backItem
    }
    
    
    static func presentAlert(title: String, message: String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
}
