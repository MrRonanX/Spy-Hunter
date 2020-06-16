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
    
    var playerPic: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var playerName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.minimumScaleFactor = 9
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("PlayerScreen-PlayerCell initialized")
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configure() {
        addSubview(playerPic)
        addSubview(playerName)
        
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
            playerName.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func setCell(with player: PlayerModel) {
        playerName.text = player.name
        playerPic.image = loadImageFromDocumentDirectory(path: player.picture)?.circleMask()
    }
    
    private func loadImageFromDocumentDirectory(path: String) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: URL(string: path)!)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
    
}

