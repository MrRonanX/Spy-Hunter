//
//  SectionCell.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 18.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

protocol SectionDelegate {
    func lockedPicTapped(section: Int)
    func viewTapped(section: Int)
    func switchTapped(section: Int, switchIsOn: Bool)
    
}

class SectionCell: UITableViewHeaderFooterView {
    let picrure         = UIImageView()
    var switchControl   : CustomSwitch?
    var label           = SHPageLabel()
    let lockedPic       = UIImageView()
    let tappingView     = UIView()
    let addView         = UIImageView()
    var section         = Int()
    var delegate        : SectionDelegate?
    var locationIsOpen  = false {
        didSet {
            setArrow(with: locationIsOpen)
        }
    }
    
    var sectionWasTapped = false {
        didSet {
            makeTransition(section: sectionWasTapped)
        }
    }
    
    
    static let reuseIdentifier = "SectionCell"
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.backgroundColor = Colors.backgroundColor
        contentView.addSubview(tappingView)
        tappingView.addSubviews(picrure, label)
        
        tappingView.translatesAutoresizingMaskIntoConstraints   = false
        picrure.translatesAutoresizingMaskIntoConstraints       = false
        
        let relativeFontConstant: CGFloat = 0.020
        
        label.textColor     = .black
        label.font          = .systemFont(ofSize: UIScreen.main.bounds.height * relativeFontConstant)
        label.textAlignment = .left
        
        let size: CGFloat   = 30
        
        NSLayoutConstraint.activate([
            tappingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tappingView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            tappingView.heightAnchor.constraint(equalTo: self.heightAnchor),
            tappingView.trailingAnchor.constraint(equalTo:  self.trailingAnchor, constant: -61),
            
            picrure.leadingAnchor.constraint(equalTo: tappingView.leadingAnchor, constant: 25),
            picrure.centerYAnchor.constraint(equalTo: tappingView.centerYAnchor),
            picrure.widthAnchor.constraint(equalToConstant: size),
            picrure.heightAnchor.constraint(equalToConstant: size),
            
            label.leadingAnchor.constraint(equalTo: picrure.trailingAnchor, constant: 15),
            label.topAnchor.constraint(equalTo: tappingView.topAnchor),
            label.bottomAnchor.constraint(equalTo: tappingView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: tappingView.trailingAnchor),
        ])
    }
    
    
    func setSectionCell(with location: SectionModel, section: Int, and numberOfSections: Int) {
        cellBasicSetup()
        self.section = section
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tappingView.addGestureRecognizer(tapGestureRecognizer)
        tappingView.tag  = section
        
        label.text = "\(location.name) (\(checkHowManyLocationsAreChosen(in: location)) / \(location.data.count)"
        
        locationIsOpen = location.open
        setSection(purchased: location.purchased, location: location)
        
        
    }
    
    
    private func cellBasicSetup() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.backgroundColor = Colors.backgroundColor
        contentView.addSubview(tappingView)
        tappingView.addSubviews(picrure, label)
        
        tappingView.translatesAutoresizingMaskIntoConstraints   = false
        picrure.translatesAutoresizingMaskIntoConstraints       = false
        
        let relativeFontConstant: CGFloat = 0.020
        
        label.textColor     = .black
        label.font          = .systemFont(ofSize: UIScreen.main.bounds.height * relativeFontConstant)
        label.textAlignment = .left
        
        let size: CGFloat   = 30
        
        NSLayoutConstraint.activate([
            tappingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tappingView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            tappingView.heightAnchor.constraint(equalTo: self.heightAnchor),
            tappingView.trailingAnchor.constraint(equalTo:  self.trailingAnchor, constant: -61),
            
            picrure.leadingAnchor.constraint(equalTo: tappingView.leadingAnchor, constant: 25),
            picrure.centerYAnchor.constraint(equalTo: tappingView.centerYAnchor),
            picrure.widthAnchor.constraint(equalToConstant: size),
            picrure.heightAnchor.constraint(equalToConstant: size),
            
            label.leadingAnchor.constraint(equalTo: picrure.trailingAnchor, constant: 15),
            label.topAnchor.constraint(equalTo: tappingView.topAnchor),
            label.bottomAnchor.constraint(equalTo: tappingView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: tappingView.trailingAnchor),
        ])
    }
    
    
    @objc private func lockPicTapped(_ sender: UITapGestureRecognizer) {
        delegate?.lockedPicTapped(section: self.section)
    }
    
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.viewTapped(section: self.section)
    }
    
    
    @objc private func switchTapped(_ sender: CustomSwitch) {
        delegate?.switchTapped(section: self.section, switchIsOn: sender.isOn)
    }
    
    
    private func checkHowManyLocationsAreChosen(in section: SectionModel) -> Int {
        // If location is chosen adds 1, if not - adds zero.
        return section.data.map { $0.isChosen ? 1 : 0}.reduce(0, +)
    }
    
    
    func setArrow(with location: Bool) {
        location == true ? setArrowUp() : setArrowDown()
        
    }
    
    
    private func setArrowDown() {
        picrure.image = nil
        picrure.image = Images.arrowDown?.withTintColor(.systemBlue)
    }
    
    
    private func setArrowUp() {
        let arrowUp = Images.arrowUp?.withTintColor(.systemBlue)
        picrure.image = arrowUp
    }
    
    
    func makeTransition(section open: Bool) {
        open ? transitionToOpen() : transitionToClosed()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.71) {
            self.locationIsOpen = open
        }
    }
    
    
    private func transitionToOpen() {
        UIView.transition(with: picrure, duration: 0.7, options: .transitionFlipFromTop, animations: {
            self.picrure.image = Images.arrowUp
        })
    }
    
    
    private func transitionToClosed() {
        UIView.transition(with: picrure, duration: 0.7, options: .transitionFlipFromTop, animations: {
            self.picrure.image = Images.arrowDown
        })
    }
    
    
    func setSection(purchased: Bool, location: SectionModel) {
        purchased ? setSwitchControl(with: location) : setLockedPic()
    }
    
    
    private func setSwitchControl(with location: SectionModel) {
        switchControl?.removeFromSuperview()
        lockedPic.removeFromSuperview()
        switchControl = CustomSwitch(number: self.tag)
        contentView.addSubview(switchControl!)
        
        switchControl?.tag = section
        switchControl?.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
        switchControl?.sectionNumber = section
        setSwitchValue(locations: checkIfSwitchIsOn(section: location))
        
        NSLayoutConstraint.activate([
            switchControl!.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -61),
            switchControl!.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    
    func checkIfSwitchIsOn(section: SectionModel) -> Bool {
        let chosenLocation = checkHowManyLocationsAreChosen(in: section)
        
        return chosenLocation < section.data.count ? false : true
    }
    
    
    func setSwitchValue(locations selected: Bool) {
        selected ? switchControl?.setOn(true, animated: false) : switchControl?.setOn(false, animated: false)
    }
    
    
    private func setLockedPic() {
        lockedPic.removeFromSuperview()
        switchControl?.removeFromSuperview()
        
        contentView.addSubview(lockedPic)
        lockedPic.image = Images.lock
        lockedPic.tintColor = UIColor.systemBlue
        lockedPic.isUserInteractionEnabled = true
        
        lockedPic.tag = section
        let lockedPicTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lockPicTapped(_:)))
        lockedPic.addGestureRecognizer(lockedPicTapGestureRecognizer)
        
        lockedPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lockedPic.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lockedPic.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -51),
            lockedPic.widthAnchor.constraint(equalToConstant: 30),
            lockedPic.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    func setCustomLocs(with section: Int) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(label)
        
        label.text = "Create your locations"
        label.textColor = .link
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lockPicTapped(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.section = section
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func addCustomLocations() {
        contentView.addSubview(addView)
        addView.translatesAutoresizingMaskIntoConstraints = false
        addView.image = Images.add
        
        NSLayoutConstraint.activate([
            addView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addView.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -51),
            addView.widthAnchor.constraint(equalToConstant: 30),
            addView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

//MARK: - Custom UISwitch

class CustomSwitch: UISwitch {
    var sectionNumber: Int? = nil
    
    convenience init(number: Int) {
        self.init()
        self.sectionNumber = number
        self.onTintColor = .systemBlue
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
