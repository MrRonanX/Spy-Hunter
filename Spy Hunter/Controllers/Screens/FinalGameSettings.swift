//
//  FinalGameSettings.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 16.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift

class FinalGameSettings: UIViewController {
    
    var chosenLocations             = [String]()
    var players                     : Results<PlayerModel>?
    private var numberOfSpies: Int  = 1
    private var discusionTime: Int  = 5
    private var bottomView          = NextButtonView()
    
    private let names = StringFiles()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor                = Colors.backgroundColor
        navigationItem.backBarButtonItem    = UIHelper.setupBackButton()
        navigationItem.title                = names.settings
        setUoStartButton()
        viewSetup()
    }
    
    
    private func viewSetup() {
        let tableView           = UITableView()
        tableView.delegate      = self
        tableView.dataSource    = self
        view.insertSubview(tableView, aboveSubview: bottomView)
        tableView.register(FinalCell.self, forCellReuseIdentifier: "FinalCell")
        
        
        tableView.backgroundColor   = Colors.backgroundColor
        tableView.allowsSelection   = false
        tableView.separatorStyle    = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
    }
    
    
    private func setUoStartButton() {
        bottomView = NextButtonView(frame: CGRect(x: 0, y: view.frame.height/1.2, width: view.frame.width, height: view.frame.height/9))
        bottomView.button.addTarget(self, action: #selector(bottomButtonPressed(_:)), for: .touchDown)
        
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 70),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    @objc func bottomButtonPressed(_ sender: UIButton) {
        let destVC              = RoleRevealViewController()
        destVC.players          = players
        destVC.locations        = chosenLocations
        destVC.numberOfSpies    = numberOfSpies
        destVC.discussionTime   = discusionTime
        navigationController?.pushViewController(destVC, animated: true)
    }
}

extension FinalGameSettings: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/12
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinalCell", for: indexPath) as! FinalCell
        cell.delegate = self
        cell.contentView.backgroundColor = Colors.backgroundColor
        cell.cellTag            = indexPath.row
        cell.addButton.tag      = indexPath.row
        cell.subtractButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height/12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SHHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/11))
        header.label.text = names.hint

        return header
    }
}

extension FinalGameSettings: FinalCellDelegate {
    func addButtonPressed(sender: UIButton, label: UILabel) {
        switch sender.tag {
        case 0:
            discusionTime += 1
            label.text = String(discusionTime)
        case 1:
            numberOfSpies += 1
            if numberOfSpies > players!.count {
                numberOfSpies = players!.count
            }
            label.text = String(numberOfSpies)
        default:
            fatalError()
        }
    }
    
    func subtactButtonPressed(sender: UIButton, label: UILabel) {
        switch sender.tag {
        case 0:
            discusionTime -= 1
            if discusionTime < 1 {
                discusionTime = 1
            }
            label.text = String(discusionTime)
            print(discusionTime)
        case 1:
            numberOfSpies -= 1
            if numberOfSpies < 1 {
                numberOfSpies = 1
            }
            label.text = String(numberOfSpies)
            print(numberOfSpies)
        default:
            fatalError()
        }
    }
}


