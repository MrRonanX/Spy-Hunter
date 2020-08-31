//
//  Locations.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/7/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation


struct Locations {
    
    private let names = Strings()
    
    lazy var sections: [SectionModel] = [
    SectionModel(
        name        : names.standardLocations,
        open        : false,
        purchased   : true,
        data        : [
            CellData(locationName: names.hospital , isChosen: true),
            CellData(locationName: names.church, isChosen: true),
            CellData(locationName: names.embassy, isChosen: true),
            CellData(locationName: names.restaurant, isChosen: true),
            CellData(locationName: names.house, isChosen: true),
            CellData(locationName: names.cafe, isChosen: true),
            CellData(locationName: names.factory, isChosen: true),
            CellData(locationName: names.shop, isChosen: true),
            CellData(locationName: names.flowersMarker, isChosen: true),
            CellData(locationName: names.bikeFixer, isChosen: true),
            CellData(locationName: names.gym, isChosen: true),
            CellData(locationName: names.bar, isChosen: true),
            CellData(locationName: names.park, isChosen: true),
            CellData(locationName: names.garden, isChosen: true),
            CellData(locationName: names.nightClub, isChosen: true),
            CellData(locationName: names.castle, isChosen: true),
            CellData(locationName: names.basement, isChosen: true),
            CellData(locationName: names.bank, isChosen: true),
            CellData(locationName: names.policeOffice, isChosen: true),
            CellData(locationName: names.school, isChosen: true),
            CellData(locationName: names.bakery, isChosen: true),
            CellData(locationName: names.market, isChosen: true),
            CellData(locationName: names.appleStore, isChosen: true),
            CellData(locationName: names.mainSquare, isChosen: true)
    ]),
    SectionModel(
        name        : names.unusualLocations,
        open        : false,
        purchased   : false,
        data        : [
            CellData(locationName: names.architectureBureau, isChosen: false),
            CellData(locationName: names.artStudio, isChosen: false),
            CellData(locationName: names.marineBase, isChosen: false),
            CellData(locationName: names.museum, isChosen: false),
            CellData(locationName: names.port, isChosen: false),
            CellData(locationName: names.prison, isChosen: false),
            CellData(locationName: names.spaceStation, isChosen: false),
            CellData(locationName: names.spaSalon, isChosen: false),
            CellData(locationName: names.orphanage, isChosen: false),
            CellData(locationName: names.parliament, isChosen: false),
            CellData(locationName: names.metro, isChosen: false),
            CellData(locationName: names.skyScrapper, isChosen: false),
            CellData(locationName: names.polarStation, isChosen: false),
            CellData(locationName: names.gameCenter, isChosen: false),
            CellData(locationName: names.university, isChosen: false),
            CellData(locationName: names.plane, isChosen: false),
            CellData(locationName: names.mine, isChosen: false),
            CellData(locationName: names.island, isChosen: false),
            CellData(locationName: names.zoo, isChosen: false),
            CellData(locationName: names.submarine, isChosen: false),
            CellData(locationName: names.observationDeck, isChosen: false),
            CellData(locationName: names.cave, isChosen: false),
            CellData(locationName: names.beach, isChosen: false),
            CellData(locationName: names.festival, isChosen: false)
    ]),
    SectionModel(
        name        : names.harryPotterLocs,
        open        : false,
        purchased   : false,
        data        : [
            CellData(locationName: names.theBurrow, isChosen: false),
            CellData(locationName: names.godricHollow, isChosen: false),
            CellData(locationName: names.littleHangleton, isChosen: false),
            CellData(locationName: names.littleWhinging, isChosen: false),
            CellData(locationName: names.malfoyManor, isChosen: false),
            CellData(locationName: names.number12, isChosen: false),
            CellData(locationName: names.beauxbatons, isChosen: false),
            CellData(locationName: names.durmstrang, isChosen: false),
            CellData(locationName: names.hogwarts, isChosen: false),
            CellData(locationName: names.ilvermorny, isChosen: false),
            CellData(locationName: names.diagonAlley, isChosen: false),
            CellData(locationName: names.gringotts, isChosen: false),
            CellData(locationName: names.ollivanders, isChosen: false),
            CellData(locationName: names.hogsmeade, isChosen: false),
            CellData(locationName: names.threeBroomsticks, isChosen: false),
            CellData(locationName: names.hogsHead, isChosen: false),
            CellData(locationName: names.hogsmeadeStation, isChosen: false),
            CellData(locationName: names.azkaban, isChosen: false),
            CellData(locationName: names.ministry, isChosen: false),
            CellData(locationName: names.magicalHospital, isChosen: false),
            CellData(locationName: names.nurmengard, isChosen: false),
            CellData(locationName: names.platform, isChosen: false),
            CellData(locationName: names.privetDrive, isChosen: false),
            CellData(locationName: names.willow, isChosen: false)
    ]),
    SectionModel(
        name        : names.lotrPlaces,
        open        : false,
        purchased   : false,
        data        : [
            CellData(locationName: names.shire, isChosen: false),
            CellData(locationName: names.eriador, isChosen: false),
            CellData(locationName: names.rivendell, isChosen: false),
            CellData(locationName: names.bree, isChosen: false),
            CellData(locationName: names.amonsul, isChosen: false),
            CellData(locationName: names.valinor, isChosen: false),
            CellData(locationName: names.moria, isChosen: false),
            CellData(locationName: names.fangorn, isChosen: false),
            CellData(locationName: names.isengard, isChosen: false),
            CellData(locationName: names.rohan, isChosen: false),
            CellData(locationName: names.gondor, isChosen: false),
            CellData(locationName: names.anduin, isChosen: false),
            CellData(locationName: names.minasTirith, isChosen: false),
            CellData(locationName: names.mordor, isChosen: false),
            CellData(locationName: names.baradDur, isChosen: false),
            CellData(locationName: names.erebor, isChosen: false),
            CellData(locationName: names.mistyMountains, isChosen: false),
            CellData(locationName: names.helmsDeep, isChosen: false),
            CellData(locationName: names.lorian, isChosen: false),
            CellData(locationName: names.mountDoom, isChosen: false),
            CellData(locationName: names.harad, isChosen: false),
            CellData(locationName: names.cirithUngol, isChosen: false),
            CellData(locationName: names.angmar, isChosen: false),
            CellData(locationName: names.dolGuldur, isChosen: false)
    ]),
    SectionModel(
        name        : names.gameOfThrones,
        open        : false,
        purchased   : false,
        data        : [
            CellData(locationName: names.bravos, isChosen: false),
            CellData(locationName: names.theEyrie, isChosen: false),
            CellData(locationName: names.casterly, isChosen: false),
            CellData(locationName: names.kingsLanding, isChosen: false),
            CellData(locationName: names.dragonstone, isChosen: false),
            CellData(locationName: names.theIronIslands, isChosen: false),
            CellData(locationName: names.meereen, isChosen: false),
            CellData(locationName: names.oldTown, isChosen: false),
            CellData(locationName: names.qarth, isChosen: false),
            CellData(locationName: names.riverrun, isChosen: false),
            CellData(locationName: names.hardhome, isChosen: false),
            CellData(locationName: names.theTwins, isChosen: false),
            CellData(locationName: names.dothrak, isChosen: false),
            CellData(locationName: names.winterfell, isChosen: false),
            CellData(locationName: names.valyria, isChosen: false),
            CellData(locationName: names.theWall, isChosen: false),
            CellData(locationName: names.valantis, isChosen: false),
            CellData(locationName: names.hallOfFaces, isChosen: false),
            CellData(locationName: names.highgarden, isChosen: false),
            CellData(locationName: names.walkOfShame, isChosen: false),
            CellData(locationName: names.castleBlack, isChosen: false),
            CellData(locationName: names.whiteHarbor, isChosen: false),
            CellData(locationName: names.naath, isChosen: false),
            CellData(locationName: names.dorne, isChosen: false),
    ])
        
    ]
    
    
}

