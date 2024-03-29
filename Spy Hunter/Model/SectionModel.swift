//
//  SectionModel.swift
//  testTableView
//
//  Created by Roman Kavinskyi on 10.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
struct SectionModel {
    
    var name        : String
    var open        : Bool
    var purchased   : Bool
    var data        : [CellData]
}

struct CellData {
    
    var locationName: String
    var isChosen    : Bool
}

extension CellData: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(locationName)
        hasher.combine(isChosen)
    }
}


