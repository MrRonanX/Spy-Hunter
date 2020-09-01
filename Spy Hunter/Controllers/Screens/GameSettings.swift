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

class GameSettings: DataLoadingVC, UITableViewDelegate, UITableViewDataSource, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
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
        setUpBottomView()
        setupTableView()
        setUpTopView()
        setupProductArray()
        checkIfPurchased()
        checkIfPro()
        fetchData()
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
    
    private func setValueToAllLocations(section: Int, value: Bool) {
        for (i, _) in locations.sections[section].data.enumerated() {
            locations.sections[section].data[i].isChosen = value
        }
        setButtonTitle(sectionTag: section)
    }
    
    
    //MARK: - PROCEED PAYMENT
    
    @objc func topViewTapped() {
        let alertVC = BecomeProVC(title: names.becomeProTitle, message: names.becomeProExplained, buttonTitle: names.getIt, delegate: self)
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
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
                dismissLoadingView()
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
                dismissLoadingView()
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
                dismissLoadingView()
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
        for section in 1..<(locations.sections.count) {
            let purchased   = KeychainWrapper.standard.bool(forKey: "Section \(section) purchased")
            if purchased == true {
                locations.sections[section].purchased = true
                //KeychainWrapper.standard.set(false, forKey: "Section \(section) purchased")
            }
        }
        tableView.reloadData()
    }
    
    
    private func checkIfPro() {
        let pro = KeychainWrapper.standard.bool(forKey: "Pro User")
        if pro == true {
            for section in 1..<(locations.sections.count) {
                locations.sections[section].purchased = true
                
                KeychainWrapper.standard.set(true, forKey: "Section \(section) purchased")
                KeychainWrapper.standard.set(true, forKey: "Pro User")
            }
            
            topView.label.text = names.enjoyTheGame
            topView.label.textAlignment = .center
            topView.isUserInteractionEnabled = false
            canMakeCustomLocs = true
            tableView.reloadData()
        }
        
    }
    
    
    private func becomePro() {
        for section in 1..<(locations.sections.count) {
            locations.sections[section].purchased = true
            
            KeychainWrapper.standard.set(true, forKey: "Section \(section) purchased")
            KeychainWrapper.standard.set(true, forKey: "Pro User")
            
            print("Section is \(section)")
            tableView.reloadSections([section], with: .automatic)
        }
        canMakeCustomLocs = true
        createCustomSection(in: locations.sections.count)
    }
    //MARK: - CREATE CUSTOM SECTION
    
    
    private func createCustomSection(in section: Int) {
        let createSectionVC = CreateNewSectionAndLocVC(title: names.nameYourLocs, buttonTitle: names.save, sectionName: nil, placeholder: names.locationsAre, delegate: self, sectionNumber: section)
        createSectionVC.modalPresentationStyle = .overFullScreen
        createSectionVC.modalTransitionStyle = .crossDissolve
        present(createSectionVC, animated: true)
    }
    
    
    private func fetchData() {
        for section in realm.objects(RealmSectionModel.self) {
            var customLocations = [CellData]()
            
            for location in section.data {
                let newLocation = CellData(locationName: location.locationName!, isChosen: location.isChosen)
                customLocations.append(newLocation)
            }
            
            let newSection  = SectionModel(name: section.name!, open: section.open, purchased: section.purchased, data: customLocations)
            
            
            locations.sections.append(newSection)
            canMakeCustomLocs = true
        }
        tableView.reloadData()
    }
    
    
    private func loadSections() {
        realmSections = realm.objects(RealmSectionModel.self)
    }
    
    
    private func lastOneLocation(to section: Int) -> CellData? {
        loadSections()
        guard let dummySection = realmSections else { return nil }
        
        let lastLocation = dummySection[section - 5].data.last!
        
        return CellData(locationName: lastLocation.locationName!, isChosen: lastLocation.isChosen)
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
        
        let createLocationVC = CreateNewSectionAndLocVC(title: names.setNameForLocation, buttonTitle: names.save.uppercased(), sectionName: nil, placeholder: names.locIs, delegate: self, sectionCreated: true, section: section[realmSectionIndex], sectionNumber: realmSectionIndex + 5)
        
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


//MARK: - BECOME PRO

extension GameSettings: BecomeProDelegate {
    func buyButtonPressed() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        
        let request           = SKProductsRequest(productIdentifiers: [productIdentifiers.last!])
        request.delegate      = self
        request.start()
        showLoadingView()
    }
}


extension GameSettings: SHAlertPaymentSuccessfulDelegate {
    func passPaymentToSection(section: Int) {
        paymentSuccessful(in: section)
    }
}


//MARK: - CREATE SECTION DELEGATE

extension GameSettings: CreateSectionDelegate {
    func createLocation(sectionName: String, in section: RealmSectionModel, sectionNumber: Int) {
        let createLocationVC = CreateNewSectionAndLocVC(title: names.setNameForLocation, buttonTitle: names.save, sectionName: sectionName, placeholder: names.locIs, delegate: self, section: section, sectionNumber: sectionNumber)
        createLocationVC.modalPresentationStyle = .overFullScreen
        createLocationVC.modalTransitionStyle   = .crossDissolve
        
        present(createLocationVC, animated: true)
    }
    
    
    func updateData(in section: Int) {
        let indexPath  = IndexPath(row: 0, section: section)
        guard let locationToUpdate = lastOneLocation(to: section), let cell = tableView.cellForRow(at: indexPath) as? LocationCell else { return }
        
        locations.sections[section].data.append(locationToUpdate)
        
        cell.updateData(on: locations.sections[section].data, section: section)
        setButtonTitle(sectionTag: section)
        
        if locations.sections[section].data.count % 3 == 1 { tableView.reloadData() }
    }
    
    
    func addSection(with number: Int) {
        guard let newSection = updateSectionData(in: number) else { return }
        
        locations.sections.append(newSection)
        tableView.reloadData()
    }
}

//MARK: - SECTION DELEGATE

extension GameSettings: SectionDelegate {
    func lockedPicTapped(section: Int) {
        print(section)
        print(canMakeCustomLocs)
        if section == 5, canMakeCustomLocs == true {
            createCustomSection(in: section)
            return
        }
        
        guard section < 6 else {
            let createSectionVC = CreateNewSectionAndLocVC(title: names.nameYourLocs, buttonTitle: names.save, sectionName: nil, placeholder: names.locationsAre, delegate: self, sectionNumber: section)
            createSectionVC.modalPresentationStyle = .overFullScreen
            createSectionVC.modalTransitionStyle = .crossDissolve
            present(createSectionVC, animated: true)
            return
        }
        
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        
        let request         = SKProductsRequest(productIdentifiers: [productIdentifiers[section]])
        request.delegate    = self
        request.start()
        showLoadingView()
    }
    
    
    func viewTapped(section: Int) {
        locations.sections[section].open.toggle()
        let indexPaths = IndexPath(row: 0, section: section)
        !locations.sections[section].open ? sectionIsClosed(indexPaths: indexPaths) : sectionIsOpened(indexPaths: indexPaths)
    }
    
    
    func switchTapped(section: Int, switchIsOn: Bool) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        
        let indexPath = IndexPath(row: 0, section: section)
        
        switchIsOn ? setValueToAllLocations(section: section, value: true) : setValueToAllLocations(section: section, value: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? LocationCell else { return }
        cell.updateData(on: locations.sections[section].data, section: indexPath.section)
    }
}


