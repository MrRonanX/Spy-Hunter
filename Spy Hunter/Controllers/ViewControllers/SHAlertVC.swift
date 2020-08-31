//
//  SHAlertVC.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 8/11/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

protocol SHAlertPaymentSuccessfulDelegate {
    func passPaymentToSection(section: Int)
}

class SHAlertVC: UIViewController {
    
    let containerView    = SHContainerView()
    let titleLabel       = SHTitleLabel()
    let messageLabel     = SHPageLabel(textColor: .secondaryLabel, textAlignment: .center)
    let actionButton     = SHButton(backgroundColor: .systemPink, title: "OK")
    
    var alertTitle          : String?
    var message             : String?
    var buttonTitle         : String?
    var delegate            : SHAlertPaymentSuccessfulDelegate?
    var section             : Int?
    
    let padding: CGFloat = 20
    
    
    init(title: String, message: String?, buttonTitle: String, delegate: SHAlertPaymentSuccessfulDelegate? = nil, section: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle      = title
        self.message         = message
        self.buttonTitle     = buttonTitle
        self.delegate        = delegate
        self.section         = section
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
    }
    
    
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, actionButton, messageLabel)
        
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
        messageLabel.text             = message ?? ""
        messageLabel.numberOfLines    = 0
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    
    @objc private func dismissVC() {
        guard section != nil else {
             dismiss(animated: true, completion: nil)
            return
        }
        dismiss(animated: true) {
            self.delegate?.passPaymentToSection(section: self.section!)
        }
    }
}
