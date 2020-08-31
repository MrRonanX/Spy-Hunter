//
//  BecomeProVC.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 8/11/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

protocol BecomeProDelegate {
    func buyButtonPressed()
}

class BecomeProVC: UIViewController {
    
    private let containerView   = SHContainerView()
    private let topLabel        = SHTitleLabel()
    private let messageLabel    = SHPageLabel(textColor: .secondaryLabel, textAlignment: .center)
    private let logo            = UIImageView()
    private let buyButton       = SHButton(backgroundColor: .systemPink, title: "Get It")
    private let cancelButton    = UIButton()
    
    
    private var alertTitle      : String?
    private var message         : String?
    private var buttonTitle     : String?
    private var delegate        : BecomeProDelegate?
    
    private let padding         = CGFloat(20)
    
    init(title: String, message: String, buttonTitle: String, delegate: BecomeProDelegate){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle     = title
        self.message        = message
        self.buttonTitle    = buttonTitle
        self.delegate       = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configure()
    }
    
    
    private func configure() {
        configureContainerView()
        configureTopLabel()
        configureButton()
        configureMessageLabel()
        configureLogo()
        configureCancelButton()
        
    }
    
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.addSubviews(topLabel, logo, messageLabel, buyButton, cancelButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.66),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
        ])
    }
    
    
    private func configureTopLabel() {
        topLabel.text       = "Become Pro"
        topLabel.textColor  = .label
        
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            topLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            topLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            topLabel.heightAnchor.constraint(equalToConstant: 2 * padding)
        ])
    }
    
    
    private func configureButton() {
        buyButton.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            buyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            buyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            buyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            buyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    private func configureMessageLabel() {
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -padding),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.heightAnchor.constraint(equalToConstant: padding * 2.5)
            
        ])
    }
    
    
    private func configureLogo() {
        logo.image = Images.spyForMainScreen
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: padding),
            logo.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            logo.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            logo.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -padding)
        ])
    }
    
    
    private func configureCancelButton() {
        //cancelButton.imageView?.contentMode = .scaleAspectFit
        cancelButton.setImage(Images.cancel, for: .normal)
        cancelButton.tintColor = .systemGray
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 30),
            cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
    }
    
    
    @objc private func buyButtonPressed() {
        delegate?.buyButtonPressed()
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    


}
