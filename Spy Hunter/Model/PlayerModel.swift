//
//  PlayerModel.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 27.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation
import RealmSwift
class PlayerModel: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var picture: String = ""
    @objc dynamic var isPlaying: Bool = true
    @objc dynamic var isSpy: Bool = false
}
