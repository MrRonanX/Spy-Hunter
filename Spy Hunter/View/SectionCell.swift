//
//  SectionCell.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 18.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SectionCell: UITableViewHeaderFooterView {
    var switchControl: CustomSwitch!
    var button: UIButton!
    //i - index of the button
    //var i is a Index value to track Switch Controll. When i = sections[section].data.count than Switch is on.
    var i = 0
    
    static let reuseIdentifier: String = "SectionCell"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        button = UIButton()
        switchControl = CustomSwitch(number: self.tag)
       
        let picrure = UIImageView()
        contentView.addSubview(switchControl!)
        contentView.addSubview(picrure)
        contentView.addSubview(button)
        
        //picture settings
        
        picrure.image = UIImage(systemName: "arrow.down")
        picrure.translatesAutoresizingMaskIntoConstraints = false
        picrure.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        picrure.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        //button settings
        let relativeFontConstant:CGFloat = 0.02
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(UIScreen.main.bounds.height * relativeFontConstant)
        button.titleLabel?.textAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: picrure.trailingAnchor, constant: 25).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        switchControl.isOn = true
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        switchControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
//        switchControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

//MARK: - Custom UISwitch

class CustomSwitch: UISwitch {
    var sectionNumber: Int? = nil
    
    convenience init(number: Int) {
        self.init()
        self.sectionNumber = number
    }
}
