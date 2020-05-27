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
    
    var chosenLocations = [String]()
    var players: Results<PlayerModel>?
   private var numberOfSpies: Int = 1
   private var discusionTime: Int = 5
   private var bottomView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        navigationItem.title = "Налаштування"
        
    }
    
    private func viewSetup() {
        setUoStartButton()
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        view.insertSubview(tableView, aboveSubview: bottomView)
        tableView.register(FinalCell.self, forCellReuseIdentifier: "FinalCell")
        

        tableView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    private func setUoStartButton() {
        bottomView = UIView(frame: CGRect(x: 0, y: view.frame.height/1.2, width: view.frame.width, height: view.frame.height/9))
        bottomView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        let bottomButton = UIButton()
        bottomView.addSubview(bottomButton)
        bottomButton.setTitle("Почати", for: .normal)
        bottomButton.setTitleColor(.black, for: .normal)
        bottomButton.titleLabel?.font = .systemFont(ofSize: 20)
        bottomButton.backgroundColor = UIColor.init(displayP3Red: 227/255, green: 66/255, blue: 52/255, alpha: 1)
        bottomButton.layer.cornerRadius = 5
        bottomButton.addTarget(self, action: #selector(bottomButtonPressed(_:)), for: .touchDown)
        view.addSubview(bottomView)
        
        let margin = CGFloat(50)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -30).isActive = true
        bottomButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 5).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -5).isActive = true
        
        
        bottomView.center = CGPoint(x: view.frame.width / 2,
                                    y: view.frame.height - bottomButton.frame.height / 2 - margin)
    }
    
    
    @objc func bottomButtonPressed(_ sender: UIButton) {
      
        performSegue(withIdentifier: "FinalGameSettingsToRoleReveal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinalGameSettingsToRoleReveal" {
            let destinationVC = segue.destination as! RoleRevealViewController
            destinationVC.players = players
            destinationVC.locations = chosenLocations
            destinationVC.discussionTime = discusionTime
        }
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
        cell.contentView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        cell.cellTag = indexPath.row
        cell.addButton.tag = indexPath.row
        cell.subtractButton.tag = indexPath.row
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height/12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/11))
        
        let label = UILabel()
        header.addSubview(label)
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Підказка: кожен четвертий гравець має бути шпіоном"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -20).isActive = true
        label.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        //set up gradient
        let headerGradient = CAGradientLayer()
                      headerGradient.frame = header.bounds
                      headerGradient.colors = [UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1), UIColor(displayP3Red: 111/255, green: 171/255, blue: 239/255, alpha: 1)].map {$0.cgColor}
               header.layer.insertSublayer(headerGradient, at: 0)
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
            label.text = String(numberOfSpies)
        default:
            fatalError()
    }
    }
    
    func subtactButtonPressed(sender: UIButton, label: UILabel) {
        switch sender.tag {
        case 0:
            discusionTime -= 1
            label.text = String(discusionTime)
            print(discusionTime)
        case 1:
            numberOfSpies -= 1
             label.text = String(numberOfSpies)
            print(numberOfSpies)
        default:
            fatalError()
        }
    }
}

   
