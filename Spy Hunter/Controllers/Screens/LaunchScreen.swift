//
//  LaunchScreen.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit



class LaunchScreen: UIViewController {
    
    private let startButton         = SHButton()
    private let rulesButton         = SHButton()
    private let libraryButton       = SHButton()
    private let becomeProButton     = SHButton()
    private let settingButton       = UIButton()
    
    private let spyPic              = UIImageView()
    
    private let names               = StringFiles()
    private var timer               = Timer()
    
    lazy private var buttonTitles   = [names.start, names.rules, names.playersTitle, names.becomeProTitle]
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupGradient()
        setupSettingButton()
        setButtonsStyle()
        setPicture()
        setSpyAnimation()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    
    @objc private func settingsButtonPressed(_ sender: UIButton) {
        //        let url = URL(string: UIApplication.openSettingsURLString)!
        //        UIApplication.shared.open(url)
        //        print("pressed")
        
        let languages = Languages.languages
      
        let alert = UIAlertController(title: nil, message: "Switch Language", preferredStyle: .actionSheet)
        for language in languages {
            let languageAction = UIAlertAction(title: language.language, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("\(language) is set")
                self.setLanguage(didSelectLanguage: language)
            })
            alert.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        alert.addAction(cancelAction)
        
        //lets open popover in iPad
        if let popoverPresentationController = alert.popoverPresentationController {
                  popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.size.width * 0.925, y: self.view.bounds.size.height * 0.075, width: 1.0, height: 1.0)
            
           
              }
     
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func setLanguage(didSelectLanguage language: Language) {

    //  Set selected language to application language
            RKLocalization.sharedInstance.setLanguage(language: language.languageCode)
            
    //  Reload application bundle as new selected language
        changeLanguageAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.initRootView()
            })
        }

    
    private func changeLanguageAnimation() {
        //initilize current window and take it's Snapshot
        let window = UIApplication.shared.windows.first
        guard let snapshot = window?.snapshotView(afterScreenUpdates: false) else {
          return
        }
        
        view.addSubview(snapshot);
        
        //animation
        UIView.animate(withDuration: 0.5, animations: {
          snapshot.transform = CGAffineTransform(scaleX: 2, y: 2)
          snapshot.alpha = 0
        }) { _ in
          snapshot.removeFromSuperview()
            
        }
      
       
    }
    
    private func setupSettingButton() {
        settingButton.setImage(Images.configureImage, for: .normal)
        settingButton.tintColor = UIColor.white
        settingButton.addTarget(self, action: #selector(settingsButtonPressed(_:)), for: .touchUpInside)
        
        view.addSubview(settingButton)
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        
        settingButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/14).isActive = true
        settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width/16).isActive = true
    }
    
    
    private func setButtonsStyle() {
        let buttons = [startButton, rulesButton, libraryButton, becomeProButton]

        for (i, button) in buttons.enumerated() {
            view.addSubview(button)
            button.set(backgroundColor: .clear, title: buttonTitles[i].uppercased(), cornerRadius: 5, borderWidth: 1)
            button.addTarget(self, action: #selector(menuButtonPressed(_ :)), for: .touchUpInside)

            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.widthAnchor.constraint(equalToConstant: 200),
                button.heightAnchor.constraint(equalToConstant: 44),
            ])
        }
        
        setButtonsConstraints()
    }
    
    
    
    @objc private func menuButtonPressed(_ sender: SHButton) {
        navigationItem.backBarButtonItem = UIHelper.setupBackButton()
        switch sender.currentTitle! {
        case names.start.uppercased():
            print("123")
            let destVC = PlayersScreen()
            navigationController?.pushViewController(destVC, animated: true)
            
        case names.rules.uppercased():
            let destVC = Rules()
            navigationController?.pushViewController(destVC, animated: true)
            
        case names.playersTitle.uppercased():
             let destVC = PlayerLibrary()
             navigationController?.pushViewController(destVC, animated: true)
            
        case names.becomeProTitle.uppercased():
             let destVC = Rules()
             navigationController?.pushViewController(destVC, animated: true)
            
        default:
            "There is an error"
        }
    }
    
    
    func setButtonsConstraints() {
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            rulesButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 25),
            libraryButton.topAnchor.constraint(equalTo: rulesButton.bottomAnchor, constant: 25),
            becomeProButton.topAnchor.constraint(equalTo: libraryButton.bottomAnchor, constant: 25)
        ])
    }
    

    func setPicture() {
        view.addSubview(spyPic)
        spyPic.translatesAutoresizingMaskIntoConstraints = false
        spyPic.image = UIImage(named: "SpyForMainScreen")
        spyPic.alpha = 0
        spyPic.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            spyPic.heightAnchor.constraint(equalToConstant: view.bounds.height / 2.3),
            spyPic.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.5),
            spyPic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spyPic.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func setSpyAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(turnOnAnimation), userInfo: nil, repeats: true)
    }
    
    
    @objc func turnOnAnimation() {
        spyPic.alpha += 0.007
        if spyPic.alpha == 1 {
            timer.invalidate()
        }
    }
    
    
    private func setupNavBar() {
        navigationController?.navigationBar.setGradientBackground(colors: [Colors.gradientRed, Colors.gradientBlue], startPoint: .topLeft, endPoint: .bottomLeft)
        navigationController?.navigationBar.shadowImage = Colors.gradientBlue.as1ptImage()
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [Colors.gradientRed, Colors.gradientBlue].map {$0.cgColor}
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}


