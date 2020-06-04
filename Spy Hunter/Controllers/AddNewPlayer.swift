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
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    private var playerPhoto = UIImage()
    private let imagePicker = UIImagePickerController()
    private let realm = try! Realm()
    private var filePath: URL? = nil
    private var playerName: String? = nil
    
    private let names = StringFiles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBarButton.title = names.save
        playerEnteredName.placeholder = names.textPlaceholder
        initialSetup()
        
    }
    
    private func initialSetup() {
        view.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        playerEnteredName.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.cameraFlashMode = UIImagePickerController.CameraFlashMode.off
        playerTookPic.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        playerTookPic.isUserInteractionEnabled = true
        print(playerTookPic.frame)
       
        playerTookPic.image = UIImage(named: "cameraIcon.png")!.circleMask()
        playerTookPic.addGestureRecognizer(tapGestureRecognizer)
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
            let alert = UIAlertController(title: names.addNewPlayer, message: nil, preferredStyle: .alert)
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
                    let alert = UIAlertController(title: names.error, message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: names.addNewPlayer, message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
        
        
        
    }
    
}


