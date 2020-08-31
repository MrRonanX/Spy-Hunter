//
//  ViewController + ext.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 8/11/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String? = nil, delegate: SHAlertPaymentSuccessfulDelegate? = nil, section: Int? = nil) {
        DispatchQueue.main.async {
            let alertVC = SHAlertVC(title: title, message: message, buttonTitle: "OK", delegate: delegate, section: section)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle   = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }

}
