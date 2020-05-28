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
    
    var timer = Timer()
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
            navigationController?.navigationBar.setGradientBackground(colors: [UIColor(displayP3Red: 185/255, green: 43/255, blue: 39/255, alpha: 1), UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1)], startPoint: .topLeft, endPoint: .bottomLeft)
            navigationController?.navigationBar.shadowImage = UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1).as1ptImage()
           navigationController?.isNavigationBarHidden = true
       }
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           navigationController?.isNavigationBarHidden = false
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(displayP3Red: 185/255, green: 43/255, blue: 39/255, alpha: 1), UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1)].map {$0.cgColor}
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        setButtonsStyle()
        setSpyAnimation()
        // Do any additional setup after loading the view.
    }
    
    private func setButtonsStyle() {
        let relativeFontConstant:CGFloat = 0.025
        
        for button in buttons {
            button.setTitle("  \(button.currentTitle!)  ", for: .normal)
            button.titleLabel?.font =  button.titleLabel?.font.withSize(view.bounds.height * relativeFontConstant)
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
}
