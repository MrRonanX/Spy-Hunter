//
//  GameSettings.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 08.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift
import StoreKit
import SwiftKeychainWrapper
import RealmSwift

class GameSettings: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    private let realm               = try! Realm()
    private let names               = Strings()
    private var locations           = Locations()
    
    private var topView             = SHHeaderViewWithImage()
    private var bottomView          = NextButtonView()
    private var tableView           = UITableView()
    
    private var myProduct           : SKProduct?
    private var productIdentifiers  = [String]()
    var players                     : Results<PlayerModel>?
    
    private var realmSections       : Results<RealmSectionModel>?
    private var canMakeCustomLocs   = false
    private var arrowIsDown         = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicSetup()
        checkIfPurchased()
        setUpBottomView()
        setupTableView()
        setUpTopView()
        setupProductArray()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSections()
    }
    
    
    private func setupProductArray() {
        productIdentifiers.append("section 1")
        productIdentifiers.append(Products.unusualLocs)
        productIdentifiers.append(Products.hpLocs)
        productIdentifiers.append(Products.lotrLocs)
        productIdentifiers.append(Products.gotLocs)
        productIdentifiers.append(Products.customLocs)
        productIdentifiers.append(Products.proVersion)
    }
    
    
    //MARK: - VIEW SETUP
    
    private func basicSetup() {
        navigationItem.title                = names.locations
        navigationItem.backBarButtonItem    = UIHelper.setupBackButton()
        navigationItem.rightBarButtonItem   = .init(title: names.restore, style: .plain, target: self, action: #selector(restoreButtonTapped))
        view.backgroundColor                = Colors.backgroundColor
    }
    
    
    fileprivate func setUpTopView() {
        topView = SHHeaderViewWithImage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/11))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(topViewTapped))
        topView.addGestureRecognizer(tapGestureRecognizer)
        
        topView.label.text  = names.becomePro
        topView.image.image = Images.boltImage
        
        tableView.tableHeaderView = topView
    }
    
    
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
        let chosenLocations = locations.sections.map {$0.data.compactMap {$0.isChosen ? $0.locationName : nil}}.flatMap {$0}
        
        guard chosenLocations != [] else {
            presentAlert(title: names.error, message: names.chooseOneLocation)
            return
        }
        
        destVC.chosenLocations  = chosenLocations
        destVC.players          = players
        navigationController?.pushViewController(destVC, animated: true)
        
    }
    
    //MARK: - TABLEVIEW SETUP
    
    
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.insertSubview(tableView, aboveSubview: bottomView)
        tableView.backgroundColor = Colors.backgroundColor
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseID)
        tableView.register(SectionCell.self, forHeaderFooterViewReuseIdentifier: SectionCell.reuseIdentifier)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.reloadData()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])      
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height = ceilf(Float(locations.sections[indexPath.section].data.count) / 3)
        if section > 4 {
            height += 1.2
        }
        return CGFloat(height * 77)
    }
    
    //CELL SET UP
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var numberOfItems = ceilf(Float(locations.sections[indexPath.section].data.count) / 3)
        let section = indexPath.section
        if section > 4 {
            numberOfItems += 1.2
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseID, for: indexPath) as! LocationCell
        
        let height = CGFloat(numberOfItems * 77)
        let size = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        
        
        cell.configure(frame: size, layout: UIHelper.createThreeColFlowLayoutForLocation(in: view))
        cell.section = section
        cell.delegate = self
        cell.updateData(on: locations.sections[section].data, section: section)
        cell.setCell(purchased: locations.sections[section].purchased)
        
        return cell
    }
    
    //MARK: - SECTIONS AND ROWS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < locations.sections.count else { return 0 }
        if !locations.sections[section].open {
            return 0
        }
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return locations.sections.count + 1
    }
    
    
    //MARK: - HEADER SET UP
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height/13
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionCell.reuseIdentifier) as! SectionCell
        header.tag = section
        header.delegate = self
        
        guard section < locations.sections.count else {
            header.setCustomLocs(with: section)
            return header 
        }
        header.setSectionCell(with: locations.sections[section], section: section, and: locations.sections.count)

        return header
    }
    
    //MARK: -  SET BUTTON'S TITLE
    
    func setButtonTitle(sectionTag: Int) {
        let sectionCell         = tableView.headerView(forSection: sectionTag) as! SectionCell
        let chosenLocation      = checkHowManyLocationsAreChosen(section: sectionTag)
        sectionCell.label.text  = ("\(locations.sections[sectionTag].name)  (\(chosenLocation) / \(locations.sections[sectionTag].data.count))")
        
        guard sectionCell.switchControl?.isOn == checkIfSwitchIsOn(section: sectionTag) else {
            sectionCell.switchControl?.isOn = checkIfSwitchIsOn(section: sectionTag)
            return
        }
    }
    
    
    func checkHowManyLocationsAreChosen(section: Int) -> Int {
        // If location is chosen adds 1, if not - adds zero.
        return locations.sections[section].data.map { $0.isChosen ? 1 : 0}.reduce(0, +)
    }
    
    
    func checkIfSwitchIsOn(section: Int) -> Bool {
        let chosenLocation = checkHowManyLocationsAreChosen(section: section)
        
        return chosenLocation < locations.sections[section].data.count ? false : true
    }
    
    
    //MARK: - OPEN AND CLOSE SECTION
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        if let section = sender.view?.tag {
            locations.sections[section].open.toggle()
            let indexPaths = IndexPath(row: 0, section: section)
            !locations.sections[section].open ? sectionIsClosed(indexPaths: indexPaths) : sectionIsOpened(indexPaths: indexPaths)
        }
    }
    
    
    private func sectionIsOpened(indexPaths: IndexPath) {
        tableView.insertRows(at: [indexPaths], with: .fade)
        flipArrow(in: indexPaths.section)
        tableView.scrollToRow(at: indexPaths, at: .top, animated: true)
        
    }
    
    
    private func sectionIsClosed(indexPaths: IndexPath) {
        tableView.deleteRows(at: [indexPaths], with: .fade)
        tableView.reloadSections([indexPaths.section], with: .automatic)
        flipArrow(in: indexPaths.section)
    }
    
    
    private func flipArrow(in sectionNumber: Int) {
        guard let section = tableView.headerView(forSection: sectionNumber) as? SectionCell else { return }
        section.sectionWasTapped = locations.sections[sectionNumber].open
    }
    
    //MARK: - SWITCH VALUE CHANGED
    
    @objc  func switchTapped(_ sender: CustomSwitch) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        
        //initilize number (section index) from the custom cell
        let section: Int    = sender.sectionNumber!
        let indexPath       = IndexPath(row: 0, section: section)
        
        sender.isOn ? setValueToAllLocations(section: section, value: true) : setValueToAllLocations(section: section, value: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? LocationCell else { return }
        cell.updateData(on: locations.sections[section].data, section: indexPath.section)
    }
    
    
    private func setValueToAllLocations(section: Int, value: Bool) {
        for (i, _) in locations.sections[section].data.enumerated() {
            locations.sections[section].data[i].isChosen = value
        }
        setButtonTitle(sectionTag: section)
    }
    
    
    //MARK: - PROCEED PAYMENT
    
    
    @objc private func lockPicTapped(_ sender: UITapGestureRecognizer) {

        guard let section   = sender.view?.tag else { return }
        
        let createSectionVC = CreateNewSectionAndLocVC(title: "Name Your Locations", buttonTitle: "Save", sectionName: nil, placeholder: "Locations are ...", delegate: self, sectionNumber: section)
        createSectionVC.modalPresentationStyle = .overFullScreen
        createSectionVC.modalTransitionStyle = .crossDissolve
        present(createSectionVC, animated: true)
//                let request         = SKProductsRequest(productIdentifiers: [productIdentifiers[section]])
//                request.delegate    = self
//                request.start()
    }
    
    
    @objc func topViewTapped() {
        //        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        //        feedbackGenerator.impactOccurred()
        //
        //        let request           = SKProductsRequest(productIdentifiers: [productIdentifiers.last!])
        //        request.delegate      = self
        //        request.start()
        let alertVC = BecomeProVC(title: "Become Pro", message: "Get Access to all the locations and make multiple sections", buttonTitle: "Get It", delegate: self)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product   = response.products.first else { return }
        myProduct           = product
        doPayment()
    }
    
    
    private func doPayment() {
        guard SKPaymentQueue.canMakePayments(), let myProduct = myProduct else { return }
        
        let payment = SKPayment(product: myProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let productIdentifier   = transaction.payment.productIdentifier
            let section             = productIdentifiers.firstIndex(of: productIdentifier)!
            
            switch transaction.transactionState {
            case .purchasing:
                // nothing
                break
            case .purchased:
                switch section {
                case 1...4:
                    paymentSuccessful(in: section)
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                case 5:
                    createCustomSection(in: section)
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                case 6:
                    becomePro()
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                default:
                    print("error")
                }
            case .restored:
                switch section {
                case 1...4:
                    presentAlert(title: names.done, message: names.restore, delegate: self, section: section)
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                case 5:
                    presentAlert(title: names.done, message: names.restore, delegate: self, section: section)
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                case 6:
                    becomePro()
                    SKPaymentQueue.default().finishTransaction(transaction)
                    SKPaymentQueue.default().remove(self)
                    presentAlert(title: names.done, message: names.restoted)
                default:
                    print("error")
                }
            case .failed, .deferred:
                if (transaction.error as? SKError)?.code != .paymentCancelled {
                    presentAlert(title: names.error, message: transaction.error?.localizedDescription)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            default:
                print("something's wrong")
            }
        }
    }
    
    
    private func paymentSuccessful(in section: Int) {
        locations.sections[section].purchased = true
        
        KeychainWrapper.standard.set(true, forKey: "Section \(section) purchased")
        tableView.reloadSections([section], with: .automatic)
    }
    
    
    @objc private func restoreButtonTapped() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    private func checkIfPurchased() {
        print(locations.sections.count)
        for section in 1..<(locations.sections.count) {
            let purchased   = KeychainWrapper.standard.bool(forKey: "Section \(section) purchased")
            if purchased == true {
                locations.sections[section].purchased = true
                //KeychainWrapper.standard.set(false, forKey: "Section \(section) purchased")
            }
        }
        tableView.reloadData()
    }
    
    
    private func becomePro() {
        for section in 1..<(locations.sections.count) {
            locations.sections[section].purchased = true
            
            KeychainWrapper.standard.set(true, forKey: "Section \(section) purchased")
            print("Section is \(section)")
            tableView.reloadSections([section], with: .automatic)
        }
        createCustomSection(in: locations.sections.count)
    }
    //MARK: - CREATE CUSTOM SECTION
    
    
    private func createCustomSection(in section: Int) {
        let createSectionVC = CreateNewSectionAndLocVC(title: "Name Your Locations", buttonTitle: "Save", sectionName: nil, placeholder: "Locations are ...", delegate: self, sectionNumber: section)
        createSectionVC.modalPresentationStyle = .overFullScreen
        createSectionVC.modalTransitionStyle = .crossDissolve
        present(createSectionVC, animated: true)
    }
    
    
    private func fetchData() {
        for section in realm.objects(RealmSectionModel.self) {
            var customLocations     = [CellData]()
            
            for location in section.data {
                let newLocation = CellData(locationName: location.locationName!, isChosen: location.isChosen)
                customLocations.append(newLocation)
            }
            
            let newSection  = SectionModel(name: section.name!, open: section.open, purchased: section.purchased, data: customLocations)
            
            
            locations.sections.append(newSection)
            canMakeCustomLocs = true
            print(locations.sections.count)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func loadSections() {
        realmSections = realm.objects(RealmSectionModel.self)
    }
}
//MARK: - Cell Delegate


extension GameSettings: LocationCellDelegate {
    
    func updateSectionName(section: Int, item: Int) {
        locations.sections[section].data[item].isChosen.toggle()
        setButtonTitle(sectionTag: section)
        
        let indexPath  = IndexPath(row: 0, section: section)
        guard let cell = tableView.cellForRow(at: indexPath) as? LocationCell else { return }
        cell.updateData(on: locations.sections[section].data, section: section)
        
    }
    
    
    func addMoreLocs(to section: Int) {
        let realmSectionIndex = section - 5
        guard let section = realmSections else { return }
        
        let createLocationVC = CreateNewSectionAndLocVC(title: "Name The Location", buttonTitle: "SAVE", sectionName: nil, placeholder: "Location is ...", delegate: self, sectionCreated: true, section: section[realmSectionIndex], sectionNumber: realmSectionIndex + 5)
        
        createLocationVC.modalPresentationStyle = .overFullScreen
        createLocationVC.modalTransitionStyle = .crossDissolve
        
        present(createLocationVC, animated: true)
    }
    
    
    func updateSectionData(in section: Int) -> SectionModel? {
        loadSections()
        
        guard let dummySection = realmSections else { return nil }
        let realmSection = dummySection[section - 5]
        
        var customLocations     = [CellData]()
        
        realmSection.data.forEach {
            let newLocation = CellData(locationName: $0.locationName!, isChosen: $0.isChosen)
            customLocations.append(newLocation)
        }
        
        let newSection  = SectionModel(name: realmSection.name!, open: true, purchased: realmSection.purchased, data: customLocations)
        return newSection
    }
}


extension GameSettings: BecomeProDelegate {
    func buyButtonPressed() {
        print("delegate called")
    }
}


extension GameSettings: CreateSectionDelegate {
    func createLocation(sectionName: String, in section: RealmSectionModel, sectionNumber: Int) {
        let createLocationVC = CreateNewSectionAndLocVC(title: "Enter The Locations", buttonTitle: "Save", sectionName: sectionName, placeholder: "Location is ...", delegate: self, section: section, sectionNumber: sectionNumber)
        createLocationVC.modalPresentationStyle = .overFullScreen
        createLocationVC.modalTransitionStyle   = .crossDissolve
        
        present(createLocationVC, animated: true)
    }
    
    
    func updateData(in section: Int) {
        loadSections()
        
        guard let newSection = updateSectionData(in: section) else { return }
        
        locations.sections.remove(at: section)
        locations.sections.insert(newSection, at: section)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func addSection(with number: Int) {
        loadSections()
        
        guard let newSection = updateSectionData(in: number) else { return }
        
        locations.sections.append(newSection)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension GameSettings: SectionDelegate {
    func lockedPicTapped(section: Int) {
        let createSectionVC = CreateNewSectionAndLocVC(title: "Name Your Locations", buttonTitle: "Save", sectionName: nil, placeholder: "Locations are ...", delegate: self, sectionNumber: section)
        createSectionVC.modalPresentationStyle = .overFullScreen
        createSectionVC.modalTransitionStyle = .crossDissolve
        present(createSectionVC, animated: true)
    }
    
    
    func viewTapped(section: Int) {
        locations.sections[section].open.toggle()
        let indexPaths = IndexPath(row: 0, section: section)
        !locations.sections[section].open ? sectionIsClosed(indexPaths: indexPaths) : sectionIsOpened(indexPaths: indexPaths)
    }
    
    
    func switchTapped(section: Int, switchIsOn: Bool) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()

        //initilize number (section index) from the custom cell
        
        let indexPath       = IndexPath(row: 0, section: section)
        
        switchIsOn ? setValueToAllLocations(section: section, value: true) : setValueToAllLocations(section: section, value: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? LocationCell else { return }
        cell.updateData(on: locations.sections[section].data, section: indexPath.section)
    }
}


extension GameSettings: SHAlertPaymentSuccessfulDelegate {
    func passPaymentToSection(section: Int) {
        paymentSuccessful(in: section)
    }
}


