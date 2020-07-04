//
//  GameSettings.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 08.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift

class GameSettings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let names       = StringFiles()
    private var topView     = SHHeaderViewWithImage()
    private var bottomView  = NextButtonView()
    private var tableView   = UITableView()
    
    fileprivate let cellID = "Cell_ID"
    lazy var sections: [SectionModel] = [
        SectionModel(
            name: names.standardLocations,
            open: false,
            data: [
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
            name: names.unusualLocations,
            open: false,
            data: [
                CellData(locationName: names.architectureBureau, isChosen: true),
                CellData(locationName: names.artStudio, isChosen: true),
                CellData(locationName: names.marineBase, isChosen: true),
                CellData(locationName: names.museum, isChosen: true),
                CellData(locationName: names.port, isChosen: true),
                CellData(locationName: names.prison, isChosen: true),
                CellData(locationName: names.spaceStation, isChosen: true),
                CellData(locationName: names.spaSalon, isChosen: true),
                CellData(locationName: names.orphanage, isChosen: true),
                CellData(locationName: names.parliament, isChosen: true),
                CellData(locationName: names.metro, isChosen: true),
                CellData(locationName: names.skyScrapper, isChosen: true),
                CellData(locationName: names.polarStation, isChosen: true),
                CellData(locationName: names.gameCenter, isChosen: true),
                CellData(locationName: names.university, isChosen: true),
                CellData(locationName: names.plane, isChosen: true),
                CellData(locationName: names.mine, isChosen: true),
                CellData(locationName: names.island, isChosen: true),
                CellData(locationName: names.zoo, isChosen: true),
                CellData(locationName: names.submarine, isChosen: true),
                CellData(locationName: names.observationDeck, isChosen: true),
                CellData(locationName: names.cave, isChosen: true),
                CellData(locationName: names.beach, isChosen: true),
                CellData(locationName: names.festival, isChosen: true)
        ])]
    
    var players: Results<PlayerModel>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title                = names.locations
        navigationItem.backBarButtonItem    = UIHelper.setupBackButton()
        
        view.backgroundColor                = Colors.backgroundColor
        setUpBottomView()
        setupTableView()
        setUpTopView()
    }
    
    //Set up top view
    fileprivate func setUpTopView() {
        topView = SHHeaderViewWithImage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/11))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.topViewTapper(_:)))
        topView.addGestureRecognizer(tapGestureRecognizer)
        
        topView.label.text  = names.becomePro
        topView.image.image = Images.boltImage
        
        tableView.tableHeaderView = topView
    }
    
    
    @objc func topViewTapper(_ sender: UITapGestureRecognizer) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        present(UIHelper.presentAlert(title: names.unavailable), animated: true)
    }
    
    //Set up bottom view
    fileprivate func setUpBottomView() {
        bottomView.button.addTarget(self, action: #selector(bottomButtonPressed(_:)), for: .touchDown)
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 70),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func bottomButtonPressed(_ sender: UIButton) {
        let destVC = FinalGameSettings()
        // Map goes through the sections
        // CompactMap takes only chosen locations
        // FlatMap sets them into one array
        let chosenLocations = sections.map {$0.data.compactMap {$0.isChosen ? $0.locationName : nil}}.flatMap {$0}
        
        guard chosenLocations != [] else {
            present(UIHelper.presentAlert(title: names.error, message: names.chooseOneLocation), animated: true)
            return
        }
        destVC.chosenLocations  = chosenLocations
        destVC.players          = players
        navigationController?.pushViewController(destVC, animated: true)
        
    }
    
    
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.insertSubview(tableView, aboveSubview: bottomView)
        tableView.backgroundColor = Colors.backgroundColor
        tableView.register(UINib(nibName: "AHugeCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.register(SectionCell.self, forHeaderFooterViewReuseIdentifier: "SectionCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])      
    }
    
    //CELL SET UP
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AHugeCell
        cell.backgroundColor = Colors.backgroundColor
        cell.delegate = self
        let section = sections[indexPath.section]
        cell.cellData = section.data
        
        //set TAG to the cell. It should be zero because we always have only 1 cell in the section
        cell.tag = indexPath.section
        
        
        return cell
    }
    
    //MARK: - SECTIONS AND ROWS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !sections[section].open {
            return 0
        }
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    //MARK: - HEADER SET UP
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height/13
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionCell") as! SectionCell
        header.tag = section
        header.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        header.addGestureRecognizer(tapGestureRecognizer)
        header.i = sections[section].data.count
        //button settings
        header.button.setTitle("\(sections[section].name)  (\(checkHowManyLocationsAreChosen(section: section)) / \(sections[section].data.count))", for: .normal)
        header.button.addTarget(self, action: #selector(sectionAction), for: .touchUpInside)
        header.button.tag = section
        
        //switch settings
        header.switchControl.tag = section
        header.switchControl.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
        header.switchControl.sectionNumber = section
        
        return header
    }
    
    //MARK: -  SET BUTTON'S TITLE
    
    func setButtonTitle(sectionTag: Int) {
        let sectionCell = tableView.headerView(forSection: sectionTag) as! SectionCell
        
        sectionCell.button.setTitle("\(sections[sectionTag].name)  (\(checkHowManyLocationsAreChosen(section: sectionTag)) / \(sections[sectionTag].data.count))", for: .normal)
    }
    
    
    func checkHowManyLocationsAreChosen(section: Int) -> Int {
        // If location is chosen adds 1, if not - adds zero.
        return sections[section].data.map { $0.isChosen ? 1 : 0}.reduce(0, +)
    }
    
    //MARK: - OPEN AND CLOSE SECTION
    
    @objc func sectionAction(button: UIButton) {
        let section = button.tag
        sections[section].open.toggle()
        let indexPaths = IndexPath(row: 0, section: section)
        !sections[section].open ? tableView.deleteRows(at: [indexPaths], with: .fade) : tableView.insertRows(at: [indexPaths], with: .fade)
        
    }
    
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        if let section = sender.view?.tag {
            sections[section].open.toggle()
            let indexPaths = IndexPath(row: 0, section: section)
            !sections[section].open ? tableView.deleteRows(at: [indexPaths], with: .fade) : tableView.insertRows(at: [indexPaths], with: .fade)
        }
        
    }
    //MARK: - SWITCH VALUE CHANGED
    
    
    private func chooseAllLocations(cell: AHugeCell, section: Int) {
        for (i, location) in cell.locationsCollection.enumerated() {
            if i < sections[section].data.count{
                location.layer.borderWidth = 1.5
                sections[section].data[i].isChosen = true
            }
        }
    }
    
    private func deselectAllLocations(cell: AHugeCell, section: Int) {
        for (i, location) in cell.locationsCollection.enumerated(){
            if i < sections[section].data.count{
                location.layer.borderWidth = 0.5
                sections[section].data[i].isChosen = false
            }
        }
    }
    
    @objc  func switchTapped(_ sender: CustomSwitch) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        
        //initilize number (section index) from the custom cell
        let section: Int = sender.sectionNumber!
        if sections[section].open {
            let indexPath = IndexPath(row: 0, section: section)
            let sectionCell = tableView.headerView(forSection: section) as! SectionCell
            if let cell = tableView.cellForRow(at: indexPath) as? AHugeCell {
                //if switch is ON all locations are chosen
                if sender.isOn {
                    chooseAllLocations(cell: cell, section: section)
                    setButtonTitle(sectionTag: section)
                    //All locations are chosen, so i is equal to number of locations
                    sectionCell.i = sections[section].data.count
                } else {
                    deselectAllLocations(cell: cell, section: section)
                    setButtonTitle(sectionTag: section)
                    //none is chosen, so i is equal to zero
                    sectionCell.i = 0
                }
            }
                // section is OPEN but cell is out of the screen
            else {
                if sender.isOn {
                    for (index, _) in sections[section].data.enumerated() {
                        sections[section].data[index].isChosen = true
                        setButtonTitle(sectionTag: section)
                    }
                } else {
                    for (index, _) in sections[section].data.enumerated() {
                        sections[section].data[index].isChosen = false
                        setButtonTitle(sectionTag: section)
                    }
                }
            }
            //change if location is chosen, when section isn't open
        } else {
            if !sender.isOn {
                for (index, _) in sections[section].data.enumerated() {
                    sections[section].data[index].isChosen = false
                    setButtonTitle(sectionTag: section)
                }
            } else {
                for (index, _) in sections[section].data.enumerated() {
                    sections[section].data[index].isChosen = true
                    setButtonTitle(sectionTag: section)
                }
            }
        }
    }
}
//MARK: - Cell Delegate

extension GameSettings: CellDelegate {
    
    //DELEGATE THAT CHANGES MODEL VALUE AND BORDER WIDTH
    func changeBorderWidthAndModelValue(sender: UIButton, buttonTag: Int, cellTag: Int) {
        
        let sectionCell = tableView.headerView(forSection: cellTag) as! SectionCell
        
        //check for borders and isChosenValue in the CellModel
        sections[cellTag].data[buttonTag].isChosen.toggle()
        if !sections[cellTag].data[buttonTag].isChosen {
            sender.layer.borderWidth = 0.5
            sectionCell.i -= 1
            
            //set UP counter in the title
            setButtonTitle(sectionTag: cellTag)
        } else {
            sender.layer.borderWidth = 1.5
            sectionCell.i += 1
            
            //set UP counter in the title
            setButtonTitle(sectionTag: cellTag)
            
        }
        
        // make sure that if switch is ON all locations are chosen and if OFF at least 1 isn't chosen
        if sectionCell.i == sections[cellTag].data.count {
            sectionCell.switchControl.isOn = true
        } else {
            sectionCell.switchControl.isOn = false
        }
    }
}

