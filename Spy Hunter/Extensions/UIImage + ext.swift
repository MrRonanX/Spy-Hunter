//
//  UIImage + ext.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 29.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

extension UIImage {
	
	func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
		var width: CGFloat
		var height: CGFloat
		var newImage: UIImage
		
		let size = self.size
		let aspectRatio =  size.width/size.height
		
		switch contentMode {
		case .scaleAspectFit:
			if aspectRatio > 1 {                    // Landscape image
				width = dimension
				height = dimension / aspectRatio
			} else {                                // Portrait image
				height = dimension
				width = dimension * aspectRatio
			}
			
		default:
			fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
		}
		
		if #available(iOS 10.0, *) {
			let renderFormat = UIGraphicsImageRendererFormat.default()
			renderFormat.opaque = opaque
			let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
			newImage = renderer.image {
				(context) in
				self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
			}
		} else {
			UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
			self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
			newImage = UIGraphicsGetImageFromCurrentImageContext()!
			UIGraphicsEndImageContext()
		}
		
		return newImage
	}
	
	
	func circleMask (borderWidth: CGFloat = 0) -> UIImage? {
		let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
		let imageView = UIImageView(frame: .init(origin: .init(x: 0, y: 0), size: square))
		imageView.contentMode = .scaleAspectFill
		imageView.image = self
		imageView.layer.cornerRadius = square.width/2
		imageView.layer.borderColor = UIColor.white.cgColor
		imageView.layer.borderWidth = borderWidth
		imageView.layer.masksToBounds = true
		UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		imageView.layer.render(in: context)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	
	var redCircleMask: UIImage? {
		let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
		let imageView = UIImageView(frame: .init(origin: .init(x: 0, y: 0), size: square))
		imageView.contentMode = .scaleAspectFill
		imageView.image = self
		imageView.layer.cornerRadius = square.width/2
		imageView.layer.borderColor = UIColor.red.cgColor
		imageView.layer.borderWidth = self.size.width/30
		imageView.layer.masksToBounds = true
		UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
		defer { UIGraphicsEndImageContext() }
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		imageView.layer.render(in: context)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	
	func rotate(radians: Float) -> UIImage? {
		var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
		// Trim off the extremely small float value to prevent core graphics from rounding it up
		newSize.width = floor(newSize.width)
		newSize.height = floor(newSize.height)
		
		UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
		let context = UIGraphicsGetCurrentContext()!
		
		// Move origin to middle
		context.translateBy(x: newSize.width/2, y: newSize.height/2)
		// Rotate around middle
		context.rotate(by: CGFloat(radians))
		// Draw the image at its center
		self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
	
	func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
		let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
		let format = imageRendererFormat
		format.opaque = isOpaque
		return UIGraphicsImageRenderer(size: canvas, format: format).image {
			_ in draw(in: CGRect(origin: .zero, size: canvas))
		}
	}
	
	
	func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
		let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
		let format = imageRendererFormat
		format.opaque = isOpaque
		return UIGraphicsImageRenderer(size: canvas, format: format).image {
			_ in draw(in: CGRect(origin: .zero, size: canvas))
		}
	}
}
