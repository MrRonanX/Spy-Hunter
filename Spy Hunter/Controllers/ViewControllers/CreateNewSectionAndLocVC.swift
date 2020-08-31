//
//  CreateNewSectionAndLocVC.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 8/13/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift

protocol CreateSectionDelegate {
    func createLocation(sectionName: String, in section: RealmSectionModel, sectionNumber: Int)
    func updateData(in section: Int)
    func addSection(with number: Int)
}

class CreateNewSectionAndLocVC: UIViewController {
    
    private let realm                   = try! Realm()
    private let names                   = Strings()
    private let containerView           = SHContainerView()
    private let titleLabel              = SHTitleLabel()
    private let sectionTextField        = SHTextField()
    private let actionButton            = SHButton(backgroundColor: .systemPink, title: "OK")
    private let cancelButton            = UIButton()
    
    private var alertTitle              : String?
    private var buttonTitle             : String?
    private var sectionName             : String?
    private var textFieldPlaceholder    : String?
    private var sectionNumber           : Int?
    private var delegate                : CreateSectionDelegate?
    private var selectedSection         : RealmSectionModel?
    private var sectionIsCreated        = false
    
    let padding: CGFloat = 20
    
    
    init(title: String, buttonTitle: String, sectionName: String? = nil, placeholder: String?, delegate: CreateSectionDelegate? = nil, sectionCreated: Bool = false, section: RealmSectionModel? = nil, sectionNumber: Int) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle             = title
        self.buttonTitle            = buttonTitle
        self.sectionName            = sectionName
        self.textFieldPlaceholder   = placeholder
        self.delegate               = delegate
        self.sectionIsCreated       = sectionCreated
        self.selectedSection        = section
        self.sectionNumber          = sectionNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
        configureCancelButton()
    }
    
    
    @objc private func dismissVC() {
        guard sectionName != nil else {
            saveSection()
            return
        }
        
        guard let locationName      = sectionTextField.text, locationName != "" else {
            presentAlert(title: "Cannot continue", message: "Location must not be empty")
            return
        }
        
        let newSection              = RealmSectionModel()
        let newLocation             = RealmCellData()
        newSection.name             = sectionName
        newLocation.locationName    = locationName
        saveToRealm(with: newSection, and: newLocation)
        
        dismiss(animated: true) {
            self.delegate?.addSection(with: self.sectionNumber!)
        }
        
    }
    
    
    private func saveSection() {
        switch sectionIsCreated {
        case true:
            saveOnlyLocation()
        case false:
            saveSectionAndPresentLocationVC()
        }
        
    }
    
    
    private func saveOnlyLocation() {
        guard let enteredName = sectionTextField.text, enteredName != "" else {
            presentAlert(title: "Cannot proceed", message: "Locations must not be empty")
            return
        }
        
        let newLocation             = RealmCellData()
        newLocation.locationName    = enteredName
        
        do {
            try self.realm.write {
                selectedSection?.data.append(newLocation)
            }
        } catch {
            presentAlert(title: names.error, message: "Location was not saved")
        }
        
        dismiss(animated: true) {
            self.delegate?.updateData(in: self.sectionNumber!)
        }
    }
    
    
    private func saveSectionAndPresentLocationVC() {
        guard let enteredName = sectionTextField.text, enteredName != "" else {
            presentAlert(title: "Cannot proceed", message: "Locations must not be empty")
            return
        }
        
        let newSection = RealmSectionModel()
        newSection.name = enteredName
        selectedSection = newSection
        
        dismiss(animated: true) {
            self.delegate?.createLocation(sectionName: enteredName, in: self.selectedSection!, sectionNumber: self.sectionNumber!)
        }
    }
    
    
    private func saveToRealm(with section: RealmSectionModel, and location: RealmCellData) {
        do {
            try self.realm.write {
                section.data.append(location)
                realm.add(section)
            }
        } catch {
            presentAlert(title: names.error, message: "Location was not saved")
        }
    }
    
    
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, actionButton, sectionTextField, cancelButton)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    
    func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: padding * 2),
        ])
    }
    
    
    func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    func configureMessageLabel() {
        sectionTextField.placeholder = textFieldPlaceholder
        sectionTextField.backgroundColor = .quaternarySystemFill
        
        NSLayoutConstraint.activate([
            
            sectionTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            sectionTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            sectionTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sectionTextField.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    
    private func configureCancelButton() {
        cancelButton.setImage(Images.cancel, for: .normal)
        cancelButton.tintColor = .systemGray4
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 30),
            cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5)
        ])
    }
    
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sectionTextField.resignFirstResponder()
    }
}


