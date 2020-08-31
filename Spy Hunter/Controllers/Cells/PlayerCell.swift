//
//  PlayerCell.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 08.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import SwipeCellKit

class PlayerCell: SwipeTableViewCell {
    
    static let reuseID = "reuseID"
    
    var playerName      = SHBodyLabel(textAlignment: .left, fontSize: .title3)
    var playerPicture   = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubviews(playerName, playerPicture)
        
        playerPicture.translatesAutoresizingMaskIntoConstraints = false
        let size: CGFloat = 60
        
        NSLayoutConstraint.activate([
            playerPicture.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            playerPicture.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playerPicture.widthAnchor.constraint(equalToConstant: size),
            playerPicture.heightAnchor.constraint(equalToConstant: size),
            
            playerName.leadingAnchor.constraint(equalTo: playerPicture.trailingAnchor, constant: 15),
            playerName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playerName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            playerName.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    
    func set(player: PlayerModel) {
        
        playerName.text = player.name
        if let photo = UIHelper.loadImageFromDocumentDirectory(path: player.picture) {
            playerPicture.image = photo.circleMask()
        }
        self.accessoryType = player.isPlaying ? .checkmark : .none
    }
    
    
}
