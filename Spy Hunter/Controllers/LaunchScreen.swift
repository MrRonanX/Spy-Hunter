//
//  LaunchScreen.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit



class LaunchScreen: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var spyPic: UIImageView!
    
    private let names = StringFiles()
    private var timer = Timer()
    
    lazy private var buttonTitles = [names.start, names.rules, names.playersTitle, names.becomeProTitle]
    
    private let settingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(settingsButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupGradient()
        setupSettingButton()
        setButtonsStyle()
        setSpyAnimation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        // Do any additional setup after loading the view.
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
        settingButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.addSubview(settingButton)
        settingButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/14).isActive = true
        settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width/16).isActive = true
    }
    
    private func setButtonsStyle() {
        let relativeFontConstant:CGFloat = 0.025
        
        for (i, button) in buttons.enumerated() {
            button.setTitle(buttonTitles[i].uppercased(), for: .normal)
            button.titleLabel?.font =  button.titleLabel?.font.withSize(view.bounds.height * relativeFontConstant)
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
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
    
    
    @IBAction func startGamePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToPlayerScreen", sender: self)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(displayP3Red: 185/255, green: 43/255, blue: 39/255, alpha: 1), UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1)], startPoint: .topLeft, endPoint: .bottomLeft)
        navigationController?.navigationBar.shadowImage = UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1).as1ptImage()
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(displayP3Red: 185/255, green: 43/255, blue: 39/255, alpha: 1), UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1)].map {$0.cgColor}
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}



