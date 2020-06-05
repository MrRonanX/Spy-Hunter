//
//  PlayerLibrary.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class PlayerLibrary: UIViewController {
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var playersView: UITableView!
    private var players: Results<PlayerModel>?
    private let realm = try! Realm()
    var oldPlayers = Int()
    
    private let names = StringFiles()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        loadPlayers()
        
        
        
        // customized back button
        customizedButton()
    }
    private func initialSetup() {
        //Table View setup
        viewBackground.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        playersView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        playersView.rowHeight = 72
        playersView.separatorStyle = .none
        playersView.delegate = self
        playersView.dataSource = self
        playersView.register(UINib(nibName: "PlayerCell", bundle: nil), forCellReuseIdentifier: "PlayerCell")
        playersView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playersView.topAnchor.constraint(equalTo: view.topAnchor),
            playersView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playersView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playersView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupHeaderView()
    }
    
    private func customizedButton() {
        
        let myBackButton:UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        myBackButton.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        myBackButton.setTitle(names.back, for: UIControl.State.normal)
        myBackButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem: UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
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
        cell.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        cell.delegate = self
        if let player = players?[indexPath.row] {
            cell.playerName.text = player.name
            cell.accessoryType = player.isPlaying ? .checkmark : .none
            if let playerPhoto = loadImageFromDocumentDirectory(path: (player.picture)) {
                cell.playerPicture.image = playerPhoto.rotate(radians: .pi/2)?.circleMask()
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
                let alert = UIAlertController(title: names.error, message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                tableView.deselectRow(at: indexPath, animated: false)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/11))
        let headerLabel = UILabel()
        headerView.addSubview(headerLabel)
        
        headerLabel.textColor = .white
        headerLabel.backgroundColor = .clear
        headerLabel.text = names.deletePlayer
        headerLabel.font = .systemFont(ofSize: 18)
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 0
        let height = (headerView.frame.height / 2) - 10
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: height),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])
        
        let labelGradient = CAGradientLayer()
        labelGradient.frame = headerView.bounds
        labelGradient.colors = [UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1), UIColor(displayP3Red: 111/255, green: 171/255, blue: 239/255, alpha: 1)].map {$0.cgColor}
        headerView.layer.insertSublayer(labelGradient, at: 0)
        
        playersView.tableHeaderView = headerView
    }
    
    
    private func loadImageFromDocumentDirectory(path: String) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: URL(string: path)!)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
}

extension PlayerLibrary: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.deleteCell(at: indexPath)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-Icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
    func deleteCell(at indexPath: IndexPath) {
        // will be executed by other View Controllers
        if let itemToDelete = players?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("Deletion Error Occured: \(error)")
            }
        }
    }
    
    
}
