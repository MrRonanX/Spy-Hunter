//
//  PlayerLibrary.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift

class PlayerLibrary: UIViewController {
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var playersView: UITableView!
    private var players: Results<PlayerModel>?
    private let realm = try! Realm()
    var oldPlayers = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        loadPlayers()
        
        
        // customized back button
        customizedButton()
    }
    private func initialSetup() {
        playersView.backgroundColor = UIColor.white
        playersView.rowHeight = 72
        playersView.separatorStyle = .none
        playersView.delegate = self
        playersView.dataSource = self
        playersView.register(UINib(nibName: "PlayerCell", bundle: nil), forCellReuseIdentifier: "PlayerCell")
    }
    
    private func customizedButton() {
        navigationController!.setNavigationBarHidden(false, animated: true)
        let myBackButton:UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        myBackButton.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        myBackButton.setTitle("Назад", for: UIControl.State.normal)
        myBackButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    
    @objc func goBack() {
        performSegue(withIdentifier: "LibraryToPlayers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LibraryToPlayers" {
            let destinationVC = segue.destination as! PlayersScreen
            destinationVC.numberOfPlayersBefore = oldPlayers
            
        }
    }
    
    private func loadPlayers() {
        players = realm.objects(PlayerModel.self)
        if let loadedPlayers = players?.filter("isPlaying == true") {
            oldPlayers = loadedPlayers.count
        }
        
        playersView.reloadData()
        
        
        
    }
}
//MARK: - TableView Functionality



extension PlayerLibrary: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        cell.selectionStyle = .none
        if let player = players?[indexPath.row] {
            cell.playerName.text = player.name
            cell.accessoryType = player.isPlaying ? .checkmark : .none
            if let playerPhoto = loadImageFromDocumentDirectory(path: (player.picture)) {
                cell.playerPicture.image = playerPhoto.circleMask?.rotate(radians: .pi/2)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let player = players?[indexPath.row] {
            do {
                try realm.write {
                    player.isPlaying.toggle()
                    playersView.reloadData()
                    
                }
            } catch {
                print(error)
                let alert = UIAlertController(title: "Помилка", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                tableView.deselectRow(at: indexPath, animated: false)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func loadImageFromDocumentDirectory(path: String) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: URL(string: path)!)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
}


//MARK: - Round Images become circles



extension UIImage {
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
}
