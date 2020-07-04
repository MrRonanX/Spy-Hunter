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

class PlayerLibrary: UIViewController, UINavigationControllerDelegate {
    
    private let realm       = try! Realm()
    private let names       = StringFiles()
    
    private let playersView = UITableView()
    private var headerView  = SHHeaderView()
    private let addButton   = UIButton()
    
    private var players: Results<PlayerModel>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableViewSetup()
        loadPlayers()
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: LaunchScreen.self) {
            view.subviews.forEach { $0.removeFromSuperview() }
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.view.bounds
            gradientLayer.colors = [Colors.gradientRed, Colors.gradientBlue].map {$0.cgColor}
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    
    private func tableViewSetup() {
        view.addSubview(playersView)
        playersView.translatesAutoresizingMaskIntoConstraints = false
        playersView.frame = view.bounds
        playersView.backgroundColor = Colors.backgroundColor
        playersView.rowHeight = 72
        playersView.separatorStyle = .none
        playersView.delegate = self
        playersView.dataSource = self
        playersView.register(UINib(nibName: "PlayerCell", bundle: nil), forCellReuseIdentifier: "PlayerCell")
        playersView.translatesAutoresizingMaskIntoConstraints = false
        playersView.pinToEdges(of: view)
        
        setupHeaderView()
        setupAddButton()
    }
    
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        let destVC = AddNewPlayer()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    fileprivate func setupAddButton() {
        let size = self.view.frame.width / 8
        let buttonImage = Images.addPlayerButton?.circleMask(borderWidth: 10)
        
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        addButton.setImage(buttonImage, for: .normal)
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: size),
            addButton.widthAnchor.constraint(equalToConstant: size),
            addButton.centerYAnchor.constraint(equalTo: headerView.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    
    private func loadPlayers() {
        players = realm.objects(PlayerModel.self)
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
        cell.backgroundColor = Colors.backgroundColor
        cell.delegate = self
        if let player = players?[indexPath.row] {
            cell.playerName.text = player.name
            cell.accessoryType = player.isPlaying ? .checkmark : .none
            if let playerPhoto = loadImageFromDocumentDirectory(path: (player.picture)) {
                cell.playerPicture.image = playerPhoto.circleMask()
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
                present(UIHelper.presentAlert(title: names.error, message: error.localizedDescription), animated: true)
            }
        }
    }
    
    
    private func setupHeaderView() {
        headerView = SHHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/11))
        headerView.label.text = names.deletePlayer
    
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
