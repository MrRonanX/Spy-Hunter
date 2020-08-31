//
//  AddNewPlayer.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import Vision
import RealmSwift

protocol AddNewPlayerDelegate {
    func updateData()
}

class AddNewPlayer: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let names               = Strings()
    
    private let realm               = try! Realm()
    
    private var playerTookPic       = UIImageView()
    private var playerEnteredName   = SHTextField()
    
    private var playerPhoto         = UIImage()
    private let imagePicker         = UIImagePickerController()
    
    private var filePath: URL?      = nil
    private var playerName: String? = nil
    
    var delegate                    :AddNewPlayerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        viewSetup()
        initialSetup()
        saveBarButtonSetup()
        addAnimation()
    }
    
    
    private func saveBarButtonSetup() {
        navigationController?.navigationBar.setGradientBackground(colors: [Colors.gradientRed, Colors.gradientBlue], startPoint: .topLeft, endPoint: .bottomLeft)
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        saveBarButton.title = names.save
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    
    private func viewSetup() {
        let picSize = view.bounds.size.height * 0.2
        let textHeight = view.bounds.size.height * 0.04
        let textWidth = view.bounds.size.width * 0.35
        
        view.addSubview(playerTookPic)
        view.addSubview(playerEnteredName)
        
        playerEnteredName.placeholder = names.textPlaceholder
        playerTookPic.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerTookPic.heightAnchor.constraint(equalToConstant: picSize),
            playerTookPic.widthAnchor.constraint(equalToConstant: picSize),
            playerTookPic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            playerTookPic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            playerEnteredName.heightAnchor.constraint(equalToConstant: textHeight),
            playerEnteredName.widthAnchor.constraint(equalToConstant: textWidth),
            playerEnteredName.topAnchor.constraint(equalTo: playerTookPic.bottomAnchor, constant: 15),
            playerEnteredName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    private func initialSetup() {
        view.backgroundColor = Colors.backgroundColor
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.cameraFlashMode = UIImagePickerController.CameraFlashMode.off
        
        playerTookPic.backgroundColor = Colors.backgroundColor
        playerTookPic.isUserInteractionEnabled = true
        playerTookPic.image = Images.cameraIcon!.circleMask()
        playerTookPic.addGestureRecognizer(tapGestureRecognizer)
        playerTookPic.isOpaque = false
    }
    
    
    private func addAnimation() {
        let buttonPressedAnimation  = Images.buttonPressedAnim!.resizeImage(200, opaque: false).circleMask()?.cgImage
        let animationLayer          = CALayer()
        animationLayer.isOpaque     = true
        animationLayer.frame        = playerTookPic.bounds
        animationLayer.contents     = buttonPressedAnimation
        animationLayer.opacity      = 0
        animationLayer.flash(duration: 3)
        playerTookPic.layer.insertSublayer(animationLayer, at: 0)
    }
    
    
    
    //MARK: - Image Picker Controller
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userTookPicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            playerPhoto = userTookPicture
            let imageName = String(Date().timeIntervalSince1970)
            self.filePath = saveImageDocumentDirectory(image: userTookPicture, fileName: imageName)
            
        }
        playerTookPic.image = playerPhoto.circleMask(borderWidth: 0)
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func imageTapped() {
        playerTookPic.layer.removeAllAnimations()
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Managment: Saving
    
    
    private func saveImageDocumentDirectory(image: UIImage, fileName: String) -> URL? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.resized(toWidth: 150)?.pngData() {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileURL
        }
        return nil
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.playerEnteredName.resignFirstResponder()
        }
    }
    
    
    @objc private func saveButtonPressed() {
        playerName = playerEnteredName.text
        
        guard playerName != "", filePath != nil else {
            presentAlert(title: names.error, message: names.addNewPlayer)
            return
        }
        if let theName = playerName, let theUrl = filePath {
            do {
                try self.realm.write {
                    let newPlayer = PlayerModel()
                    newPlayer.name = theName
                    newPlayer.picture = theUrl.absoluteString
                    realm.add(newPlayer)
                    delegate.updateData()
                    dismiss(animated: true, completion: nil)
                }
            } catch {
                presentAlert(title: names.error, message: error.localizedDescription)
            }
            
        }
    }
}


