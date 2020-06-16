//
//  ShowSpies.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 27.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift

class ShowSpies: UIViewController {
    
    private let names = StringFiles()
    private let tableView = UITableView()
    private var bottomView = UIView()
    private let bottomButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = UIColor.init(displayP3Red: 227/255, green: 66/255, blue: 52/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(bottomButtonPressed(_:)), for: .touchDown)
        return button
    }()
    
    var players: Results<PlayerModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        setupBottomView()
        setupTableView()
        
    }
    
    private func initialSetup() {
        view.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
    }
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(SpyCell.self, forCellReuseIdentifier: "SpyCell")
        tableView.rowHeight = 220
        tableView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    
    private func setupBottomView() {
            bottomView = UIView(frame: CGRect(x: 0, y: view.frame.height/1.2, width: view.frame.width, height: view.frame.height/9))
            bottomView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)

            view.addSubview(bottomView)
            bottomView.addSubview(bottomButton)
            
        bottomButton.setTitle(names.playAgain, for: .normal)
            let margin = CGFloat(50)
        
        NSLayoutConstraint.activate([
        bottomButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5),
        bottomButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -30),
        bottomButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 5),
        bottomButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -5)
        ])
          
            bottomView.center = CGPoint(x: view.frame.width / 2,
                                        y: view.frame.height - bottomButton.frame.height / 2 - margin)
        }
    
    @objc private func bottomButtonPressed(_ sender: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(displayP3Red: 185/255, green: 43/255, blue: 39/255, alpha: 1), UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1)].map {$0.cgColor}
        self.view.layer.insertSublayer(gradientLayer, at: 0)

        performSegue(withIdentifier: "GoToRootVC", sender: self)
    }
    
    private func loadImageFromDocumentDirectory(path: String) -> UIImage? {
           do {
               let imageData = try Data(contentsOf: URL(string: path)!)
               return UIImage(data: imageData)
           } catch {}
           return nil
       }

}

extension ShowSpies: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpyCell", for: indexPath) as! SpyCell
        if let player = players {
            cell.spyPic.image = loadImageFromDocumentDirectory(path: player[indexPath.row].picture)?.resizeImage(150, opaque: false).circleMask()
            cell.spyName.text = player[indexPath.row].name
        
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        headerLabel.textColor = .black
        headerLabel.textAlignment = .center
        headerView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        headerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])
        if players!.count > 1 {
            headerLabel.text = names.spiesAre
        } else {
            headerLabel.text = names.spyIs
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}
