//
//  RealmSectionModel.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 8/5/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSectionModel: Object {
    @objc dynamic var name        : String?
    @objc dynamic var open        : Bool  = false
    @objc dynamic var purchased   : Bool  = true
    var data                      = List<RealmCellData>()
}

class RealmCellData: Object {
    @objc dynamic var locationName : String?
    @objc dynamic var isChosen     : Bool = false
    var parentSection              = LinkingObjects(fromType: RealmSectionModel.self, property: "data")
    
}
