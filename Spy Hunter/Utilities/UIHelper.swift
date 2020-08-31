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
    
    
    static func createThreeColFlowLayoutForLocation(in view: UIView) -> UICollectionViewFlowLayout {
        let width =  view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 65)
        
        return flowLayout
    }
    
    static func setupBackButton() -> UIBarButtonItem {
        let backItem = UIBarButtonItem()
        backItem.title = Strings().back
        return backItem
    }
    
    
    static func loadImageFromDocumentDirectory(path: String) -> UIImage? {
           do {
               let imageData = try Data(contentsOf: URL(string: path)!)
               return UIImage(data: imageData)
           } catch {}
           return nil
       }
}
