//
//  GameSettings.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 08.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class GameSettings: UIViewController, UITableViewDelegate, UITableViewDataSource {
        private var switchControl: CustomSwitch!
        private var button: UIButton!
        private var buttonArray = [UIButton]()
        private var switchArray = [UISwitch]()
        private var pictureArray = [UIImageView]()
        private var topView: UIView!
        private var bottomView: UIView!
        private var tableView = UITableView()
        fileprivate let cellID = "Cell_ID"
        fileprivate var K = Constants.Ukr.StandartLocations()
        fileprivate var KAdv = Constants.Ukr.AdvancedLocations()
        lazy var sections: [SectionModel] = [
            SectionModel(
                name: "Стандартні локації",
                open: false,
                data: [
                    CellData(locationName: K.hospital , isChosen: true),
                    CellData(locationName: K.church, isChosen: true),
                    CellData(locationName: K.embassy, isChosen: true),
                    CellData(locationName: K.restaurant, isChosen: true),
                    CellData(locationName: K.house, isChosen: true),
                    CellData(locationName: K.cafe, isChosen: true),
                    CellData(locationName: K.factory, isChosen: true),
                    CellData(locationName: K.shop, isChosen: true),
                    CellData(locationName: K.flowersMarker, isChosen: true),
                    CellData(locationName: K.bikeFixer, isChosen: true),
                    CellData(locationName: K.gym, isChosen: true),
                    CellData(locationName: K.bar, isChosen: true),
                    CellData(locationName: K.park, isChosen: true),
                    CellData(locationName: K.garden, isChosen: true),
                    CellData(locationName: K.nightClub, isChosen: true),
                    CellData(locationName: K.castle, isChosen: true),
                    CellData(locationName: K.basement, isChosen: true),
                    CellData(locationName: K.bank, isChosen: true),
                    CellData(locationName: K.policeOffice, isChosen: true),
                    CellData(locationName: K.school, isChosen: true),
                    CellData(locationName: K.bakery, isChosen: true),
                    CellData(locationName: K.market, isChosen: true)
            ]),
            SectionModel(name: "Платні локації",
                         open: false,
                         data: [
                            CellData(locationName: KAdv.archirectureBureau, isChosen: true),
                            CellData(locationName: KAdv.artStudio, isChosen: true),
                            CellData(locationName: KAdv.marineBase, isChosen: true),
                            CellData(locationName: KAdv.museum, isChosen: true),
                            CellData(locationName: KAdv.port, isChosen: true),
                            CellData(locationName: KAdv.prison, isChosen: true),
                            CellData(locationName: KAdv.spaceStation, isChosen: true),
                            CellData(locationName: KAdv.spaSalon, isChosen: true)
            ])]
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.title = "Finally Works"
            tableView.dataSource = self
            tableView.delegate = self
            view.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
            setUpBottomView()
            setupTableView()
            setUpTopView()
            
            
        }
        //Set up top view
        fileprivate func setUpTopView() {
            topView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/11))
            topView.backgroundColor = .clear
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.topViewTapper(_:)))
                   topView.addGestureRecognizer(tapGestureRecognizer)
            
            let headerImage = UIImageView()
            headerImage.image = UIImage(systemName: "bolt")
            topView.addSubview(headerImage)
            let headerLabel = UILabel()
            headerLabel.numberOfLines = 2
            headerLabel.text = "Стань PRO гравцем та відкрий всі локації"
            
            headerLabel.textColor = .black
            headerLabel.textAlignment = .left
            headerLabel.font = .systemFont(ofSize: 20)
            topView.addSubview(headerLabel)
            headerImage.translatesAutoresizingMaskIntoConstraints = false
            headerImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 30).isActive = true
            headerImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
            
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            headerLabel.leadingAnchor.constraint(equalTo: headerImage.trailingAnchor, constant: topView.frame.width/15).isActive = true
            headerLabel.trailingAnchor.constraint(equalTo: topView.leadingAnchor, constant: topView.frame.width).isActive = true
            headerLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true

            tableView.tableHeaderView = topView
            
        }
        
        @objc func topViewTapper(_ sender: UITapGestureRecognizer) {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.impactOccurred()
            print("Works")
            }
        
        //Set up bottom view
        fileprivate func setUpBottomView() {
            bottomView = UIView(frame: CGRect(x: 0, y: view.frame.height/1.2, width: view.frame.width, height: view.frame.height/9))
            bottomView.backgroundColor = .white
            let bottomButton = UIButton()
            bottomView.addSubview(bottomButton)
            bottomButton.setTitle("Дальше", for: .normal)
            bottomButton.setTitleColor(.black, for: .normal)
            bottomButton.titleLabel?.font = .systemFont(ofSize: 20)
            bottomButton.backgroundColor = UIColor.init(displayP3Red: 227/255, green: 66/255, blue: 52/255, alpha: 1)
            bottomButton.layer.cornerRadius = 5
            bottomButton.addTarget(self, action: #selector(bottomButtonPressed(_:)), for: .touchDown)
            
            let margin = CGFloat(50)
            bottomButton.translatesAutoresizingMaskIntoConstraints = false
            bottomButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5).isActive = true
            bottomButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -30).isActive = true
            bottomButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 5).isActive = true
            bottomButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -5).isActive = true
            view.addSubview(bottomView)
           
            bottomView.center = CGPoint(x: view.frame.width / 2,
                                    y: view.frame.height - bottomButton.frame.height / 2 - margin)

            
        }
        
        @objc func bottomButtonPressed(_ sender: UIButton) {
            //vibration when button is pressed
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.impactOccurred()
            sender.pulseAnimation()
            performSegue(withIdentifier: "gameSettingsToFinalGameSettings", sender: self)
            
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSettingsToFinalGameSettings" {
            let destinationVC = segue.destination as! FinalGameSettings
            // Map goes through the sections
            // CompactMap takes only chosen locations
            // FlatMap sets them into one array
            destinationVC.chosenLocations = sections.map {$0.data.compactMap {$0.isChosen ? $0.locationName : nil}}.flatMap {$0}
                
 
            }
            
            
        }
        
    
        fileprivate func setupTableView() {
            view.insertSubview(tableView, aboveSubview: bottomView)
            tableView.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
            tableView.register(UINib(nibName: "AHugeCell", bundle: nil), forCellReuseIdentifier: cellID)
            tableView.allowsSelection = false
            tableView.separatorStyle = .none
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            
            
            
        }
        
        //CELL SET UP
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AHugeCell
            cell.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
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
        
        
        
         func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            let view = UIView()
            view.tag = section
            view.isUserInteractionEnabled = true
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
            view.addGestureRecognizer(tapGestureRecognizer)
            button = UIButton()
            switchControl = CustomSwitch(number: section)
            switchArray.append(switchControl)
            
            buttonArray.append(button)
            //buttonArray.insert(button, at: 0)
            let picrure = UIImageView()
            
            view.addSubview(switchControl!)
            view.addSubview(picrure)
            view.addSubview(button)
            
            //picture settings
            
            picrure.image = UIImage(systemName: "arrow.down")
            picrure.tag = section
            pictureArray.append(picrure)
            picrure.translatesAutoresizingMaskIntoConstraints = false
            picrure.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
            picrure.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            //button settings
            
            button.setTitleColor(.black, for: .normal)
            setButtonTitle(buttonTag: section)
            button.titleLabel?.textAlignment = .left
            button.tag = section
            button.addTarget(self, action: #selector(sectionAction), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leadingAnchor.constraint(equalTo: picrure.trailingAnchor, constant: 25).isActive = true
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            //switch settings
            switchControl.isOn = true
            switchControl.tag = section
            switchControl.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
            switchControl.translatesAutoresizingMaskIntoConstraints = false
            switchControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            switchControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            switchControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            
            return view
        }
        
        //MARK: -  SET BUTTON'S TITLE
        
        func setButtonTitle(buttonTag: Int) {
            buttonArray[buttonTag].setTitle("\(sections[buttonTag].name)  (\(checkHowManyLocationsAreChosen(section: buttonTag)) / \(sections[buttonTag].data.count))", for: .normal)
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
        
        @objc  func switchTapped(_ sender: CustomSwitch) {
            //vibration when switch value is changed
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.impactOccurred()
            //initilize number (section index) from the custom cell
            let section: Int = sender.sectionNumber!
            if sections[section].open {
                let indexPath = IndexPath(row: 0, section: section)
                let cell = tableView.cellForRow(at: indexPath) as! AHugeCell
                //if switch is ON all locations are chosen
                if sender.isOn {
                    for (i, location) in cell.locationsCollection.enumerated() {
                        if i < sections[section].data.count{
                            location.layer.borderWidth = 1.5
                            sections[section].data[i].isChosen = true
                        }
                    }
                    // Set new title
                    setButtonTitle(buttonTag: section)
                    //All locations are chosen, so i is equal to number of locations
                    cell.i = sections[section].data.count
                } else {
                    for (i, location) in cell.locationsCollection.enumerated(){
                        if i < sections[section].data.count{
                            location.layer.borderWidth = 0.5
                            sections[section].data[i].isChosen = false
                        }
                    }
                    //Set new section button title
                    setButtonTitle(buttonTag: section)
                    //none is chosen, so i is equal to zero
                    cell.i = 0
                }
                //change if location is chosen, when section isn't open
            } else {
                if !sender.isOn {
                    for (index, _) in sections[section].data.enumerated() {
                        sections[section].data[index].isChosen = false
                        setButtonTitle(buttonTag: section)
                    }
                } else {
                    for (index, _) in sections[section].data.enumerated() {
                        sections[section].data[index].isChosen = true
                        setButtonTitle(buttonTag: section)
                    }
                }
            }
        }
    }
    //MARK: - Cell Delegate

    extension GameSettings: CellDelegate {
        
        //DELEGATE THAT CHANGES MODEL VALUE AND BORDER WIDTH
        func changeBorderWidthAndModelValue(sender: UIButton, buttonTag: Int, cellTag: Int) {
            //initialize a cell
            
            let indexPath = IndexPath(row: 0, section: cellTag)
            let cell = tableView.cellForRow(at: indexPath) as! AHugeCell
            
            //check for borders and isChosenValue in the CellModel
            sections[cellTag].data[buttonTag].isChosen.toggle()
            if !sections[cellTag].data[buttonTag].isChosen {
                sender.layer.borderWidth = 0.5
                cell.i -= 1
                
                //set UP counter in the title
                setButtonTitle(buttonTag: cellTag)
            } else {
                sender.layer.borderWidth = 1.5
                cell.i += 1
                
                //set UP counter in the title
                setButtonTitle(buttonTag: cellTag)
                
            }
            
            // make sure that if switch is ON all locations are chosen and if OFF at least 1 isn't chosen
            if cell.i == sections[cellTag].data.count {
                switchArray[cellTag].isOn = true
            } else {
                switchArray[cellTag].isOn = false
            }
        }
        
        
        
    }
    //MARK: - Custom UISwitch

    class CustomSwitch: UISwitch {
        var sectionNumber: Int? = nil
        
        convenience init(number: Int) {
            self.init()
            self.sectionNumber = number
        }
    }

