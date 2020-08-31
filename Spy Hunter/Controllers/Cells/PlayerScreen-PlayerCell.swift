//
//  PlayerScreen-PlayerCell.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 15.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class PlayerScreen_PlayerCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "CollectionViewPlayerCell"
    
    var playerPic   = UIImageView()
    var playerName  = SHBodyLabel(textAlignment: .center, fontSize: .body)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(playerPic)
        addSubview(playerName)
        playerPic.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            playerPic.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            playerPic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            playerPic.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            playerPic.heightAnchor.constraint(equalTo: playerPic.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playerName.topAnchor.constraint(equalTo: playerPic.bottomAnchor, constant: 10),
            playerName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            playerName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            playerName.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    
    func setCell(with player: PlayerModel) {
        playerName.text = player.name
        playerPic.image = UIHelper.loadImageFromDocumentDirectory(path: player.picture)?.circleMask()
    }
}

