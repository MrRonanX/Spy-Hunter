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

    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerPicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
