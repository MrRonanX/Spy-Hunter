//
//  AHugeCell.swift
//  testTableView
//
//  Created by Roman Kavinskyi on 11.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
protocol CellDelegate {
    func changeBorderWidthAndModelValue(sender: UIButton, buttonTag: Int, cellTag: Int)
    
}

class AHugeCell: UITableViewCell {
    
    @IBOutlet var locationsCollection: [UIButton]!
    var delegate: CellDelegate?
    @IBOutlet weak var stackView: UIStackView!
    
    var cellData: [CellData]! {
        didSet {
            // , location - button
            let relativeFontConstant:CGFloat = 0.018
            for (i, location) in locationsCollection.enumerated() {
                if i < cellData.count {
                    location.setTitle(cellData[i].locationName, for: .normal)
                    location.backgroundColor = UIColor(displayP3Red: 244/255, green: 238/255, blue: 235/255, alpha: 1)
                    location.isHidden = false
                    location.setTitleColor(.black, for: .normal)
                    location.titleLabel?.font = location.titleLabel?.font.withSize(UIScreen.main.bounds.height * relativeFontConstant)
                    location.titleLabel?.textAlignment = .center
                    location.titleLabel?.numberOfLines = 0
                    location.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
                    location.layer.cornerRadius = 5
                    location.layer.borderWidth = 1.5
                    if !cellData[i].isChosen {
                        location.layer.borderWidth = 0.5
                    }
                    location.tag = i
                
                    
                } else {
                    location.isHidden = true
                }
            }
        }
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func locaitonPressed(_ sender: UIButton) {
        delegate?.changeBorderWidthAndModelValue(sender: sender, buttonTag: sender.tag, cellTag: self.tag)
        
    }
    
    
}
