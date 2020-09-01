//
//  DataLoadingVC.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 27.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class DataLoadingVC: UIViewController {
	
	var containerView: UIView!
	
	func showLoadingView() {
		containerView = UIView(frame: view.bounds)
		view.addSubview(containerView)
        containerView.backgroundColor 	= .systemGray3
		containerView.alpha 			= 0
		
		UIView.animate(withDuration: 0.25) {
			self.containerView.alpha = 0.8
		}
		
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      
		
		
		NSLayoutConstraint.activate([
			activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
		])
		print("a")
        activityIndicator.startAnimating()
        
	}
	
	
	func dismissLoadingView() {
		DispatchQueue.main.async {
            print("s")
			self.containerView.removeFromSuperview()
			self.containerView = nil
		}
		
	}
}
