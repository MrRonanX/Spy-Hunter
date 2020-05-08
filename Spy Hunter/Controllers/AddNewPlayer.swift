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

class AddNewPlayer: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var playerTookPic: UIImageView!
    @IBOutlet weak var playerEnteredName: UITextField!
    private var playerPhoto = UIImage()
    private let imagePicker = UIImagePickerController()
    private let realm = try! Realm()
    private var filePath: URL? = nil
    private var playerName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.cameraFlashMode = UIImagePickerController.CameraFlashMode.off
        playerTookPic.isUserInteractionEnabled = true
        playerTookPic.image = #imageLiteral(resourceName: "camera").circleMask
        playerTookPic.addGestureRecognizer(tapGestureRecognizer)
        
    }
    //MARK: - Image Picker Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userTookPicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            playerPhoto = userTookPicture
            let imageName = String(Date().timeIntervalSince1970)
            self.filePath = saveImageDocumentDirectory(image: userTookPicture, fileName: imageName)
            
        }
        playerTookPic.image = playerPhoto.circleMask
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Data Managment: Saving
    
    
    
    private func saveImageDocumentDirectory(image: UIImage, fileName: String) -> URL? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData() {
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
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        playerName = playerEnteredName.text
        if playerName == "" {
            let alert = UIAlertController(title: "Введи ім'я та зроби фото", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            if let theName = playerName, let theUrl = filePath {
                do {
                    try self.realm.write {
                        let newPlayer = PlayerModel()
                        newPlayer.name = theName
                        newPlayer.picture = theUrl.absoluteString
                        realm.add(newPlayer)
                        performSegue(withIdentifier: "NewPlayerAdded", sender: self)
                    }
                } catch {
                    print(error)
                    let alert = UIAlertController(title: "Помилка", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Введи ім'я та зроби фото", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
        
        
        
    }
    
}

//MARK: - Regular Pictures become circles



extension UIImage {
    var circleMask: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: .init(origin: .init(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
