//
//  SectionCell.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 18.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class SectionCell: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = "SectionCell"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
