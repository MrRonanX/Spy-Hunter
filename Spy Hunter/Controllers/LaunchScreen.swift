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
        // Do any additional setup after loading the view.
    }
    
    func setButtonsStyle() {
        let awesomeColor = UIColor(red: 250/255, green: 116/255, blue: 79/255, alpha: 1)
        for button in buttons {
            button.setTitle("  \(button.currentTitle!)  ", for: .normal)
            button.backgroundColor = UIColor(red: 247/255, green: 144/255, blue: 113/255, alpha: 1)
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = awesomeColor.cgColor
        }
    }
}
