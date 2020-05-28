//
//  SpyCell.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 27.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SpyCell: UITableViewCell {
    
    let spyPic: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let spyName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static let reuseIdentifier: String = "SpyCell"
        
    override init(style: UITableViewCell.CellStyle ,reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        contentView.addSubview(spyPic)
        contentView.addSubview(spyName)
        
        //set Constraints
        NSLayoutConstraint.activate([
            spyPic.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spyPic.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            spyPic.heightAnchor.constraint(equalToConstant: 150),
            spyPic.widthAnchor.constraint(equalToConstant: 150),
            
            spyName.topAnchor.constraint(equalTo: spyPic.bottomAnchor, constant: 20),
            spyName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spyName.heightAnchor.constraint(equalToConstant: 50),
            spyName.widthAnchor.constraint(equalToConstant: 300)
        ])
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}
}
