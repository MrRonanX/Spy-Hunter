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
    
    private let names           = StringFiles()
    private let tableView       = UITableView()
    private var bottomView      = NextButtonView()

    
    var players: Results<PlayerModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupBottomView()
        setupTableView()
        setupHeader()
        
    }
    
    private func initialSetup() {
        view.backgroundColor = Colors.backgroundColor
    }
    private func setupTableView() {
        tableView.separatorStyle    = .none
        tableView.allowsSelection   = false
        tableView.delegate          = self
        tableView.dataSource        = self
        view.addSubview(tableView)
        tableView.register(SpyCell.self, forCellReuseIdentifier: "SpyCell")
        tableView.rowHeight         = 220
        tableView.backgroundColor   = Colors.backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    
    private func setupBottomView() {
            bottomView = NextButtonView(frame: CGRect(x: 0, y: view.frame.height/1.2, width: view.frame.width, height: view.frame.height/9))
            view.addSubview(bottomView)
        bottomView.button.addTarget(self, action: #selector(bottomButtonPressed(_:)), for: .touchUpInside)
        bottomView.button.setTitle(names.playAgain, for: .normal)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 70),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func bottomButtonPressed(_ sender: UIButton) {
        view.subviews.forEach { $0.removeFromSuperview() }
               
               let gradientLayer = CAGradientLayer()
               gradientLayer.frame = self.view.bounds
               gradientLayer.colors = [Colors.gradientRed, Colors.gradientBlue].map {$0.cgColor}
               self.view.layer.insertSublayer(gradientLayer, at: 0)
               
               navigationController?.popToRootViewController(animated: true)
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
    
    
    func setupHeader() {
        let headerView = SHHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/11))
        headerView.label.font = UIFont.preferredFont(forTextStyle: .title1)

        if players!.count > 1 {
            headerView.label.text = names.spiesAre
        } else {
            headerView.label.text = names.spyIs
        }
        tableView.tableHeaderView = headerView
    }
}
