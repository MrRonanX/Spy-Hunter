//
//  PlayersScreen.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import CoreGraphics
import RealmSwift


class PlayersScreen: UIViewController {
    
    enum Section {
        case main
    }
    
    private let names               = Strings()
    
    typealias DataSource            = UICollectionViewDiffableDataSource<Section, PlayerModel>
    typealias DataSourceSnapshot    = NSDiffableDataSourceSnapshot<Section, PlayerModel>
    private var dataSource          : DataSource!
    private var snapshot            = DataSourceSnapshot()
    
    private var collectionView      : UICollectionView!
    private var viewForCollection   : UIView!
    
    private var playersBarButton    : UIBarButtonItem!
    private var labelAndGradient    = SHHeaderView()
    private var bottomView          = NextButtonView()
    
    private let pageLabel           = SHPageLabel()
    private let addButton           = UIButton()
    
    private let realm               = try! Realm()
    private var players             : Results<PlayerModel>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundColor
        navigationItem.backBarButtonItem = UIHelper.setupBackButton()
        loadPlayers()
        setUpBottomView()
        setupLabelAndGradientView()
        setupCollectionView()
        configure()
        setupAddButton()
        setupRightBarButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPlayers()
        applySnapshot(players: Array(players!))
        
    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            view.subviews.forEach { $0.removeFromSuperview() }
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.view.bounds
            gradientLayer.colors = [Colors.gradientRed, Colors.gradientBlue].map {$0.cgColor}
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    
    private func setupRightBarButton() {
        playersBarButton = UIBarButtonItem(title: names.players, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = playersBarButton
        navigationItem.backBarButtonItem = UIHelper.setupBackButton()
    }
    
    
    @objc private func rightBarButtonTapped() {
        let destVC = PlayerLibrary()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    //MARK: - Label and Gradient
    
    private func getEndpointOfNavBar() -> CGFloat{
        //statusBar height for iPhone 10 +
        var statusBarHeight: CGFloat {
            if #available(iOS 13.0, *) {
                var heightToReturn: CGFloat = 0.0
                for window in UIApplication.shared.windows {
                    if let height = window.windowScene?.statusBarManager?.statusBarFrame.height, height > heightToReturn {
                        heightToReturn = height
                    }
                }
                return heightToReturn
            } else {
                return UIApplication.shared.statusBarFrame.height
            }}
        //NavBar height + statusBar
        let height = (navigationController?.navigationBar.frame.size.height)! + statusBarHeight
        return height
    }
    

    fileprivate func setupLabelAndGradientView() {
        let endOfNavBar = getEndpointOfNavBar()
        labelAndGradient = SHHeaderView(frame: CGRect(x: 0, y: endOfNavBar, width: self.view.frame.width, height: self.view.frame.height/11))
        labelAndGradient.label.text = names.pressPlus
        view.addSubview(labelAndGradient)
        
        labelAndGradient.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelAndGradient.topAnchor.constraint(equalTo: view.topAnchor, constant: endOfNavBar),
            labelAndGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            labelAndGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            labelAndGradient.bottomAnchor.constraint(equalTo: labelAndGradient.topAnchor, constant: view.frame.height/11)
        ])
    }

    
    //MARK: - Collection View Setup
    
    fileprivate func configure() {
        collectionView = UICollectionView(frame: viewForCollection.bounds, collectionViewLayout: UIHelper.createThreeColFlowLayout(in: viewForCollection))
        collectionView.bounds = viewForCollection.bounds
        collectionView.delegate = self
        
        collectionView.register(PlayerScreen_PlayerCell.self, forCellWithReuseIdentifier: PlayerScreen_PlayerCell.reuseIdentifier)
        viewForCollection.addSubview(collectionView)
        collectionView.backgroundColor = Colors.backgroundColor
        
        configureCollectionViewDataSource()
        createDummyData()
    }
    
    private func setupCollectionView() {
        
        let x: CGFloat = 0
        let y = getEndpointOfNavBar() + view.bounds.height / 11
        let width = view.bounds.width
        let height = view.bounds.height - getEndpointOfNavBar() - view.bounds.height / 11 - view.bounds.height / 9
        viewForCollection = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        view.addSubview(viewForCollection)
        viewForCollection.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configureCollectionViewDataSource() {
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, player) -> PlayerScreen_PlayerCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerScreen_PlayerCell.reuseIdentifier, for: indexPath) as! PlayerScreen_PlayerCell
            cell.setCell(with: player)
            
            return cell
        })
        
    }
    
    
    //MARK: - Load Players
    
    fileprivate func createDummyData() {
        var dummyPlayers: [PlayerModel] = []
        
        dummyPlayers = Array(players!)
        applySnapshot(players: dummyPlayers)
    }
    
    
    private func loadPlayers() {
        players = realm.objects(PlayerModel.self).filter("isPlaying == true")
    }

    
    private func applySnapshot(players: [PlayerModel]) {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(players)
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
        
    }
    
    
    //MARK: - Segues
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        let destVC = AddNewPlayer()
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    
    @objc private func bottomButtonPressed(_ sender: UIButton) {
        if players?.count != 0 {
            let destVC = GameSettings()
            destVC.players = players
            navigationController?.pushViewController(destVC, animated: true)
        } else {
            presentAlert(title: names.error, message: names.addOnePlayer)
        }
    }
    
    
    //MARK: - Button Settings
    
    fileprivate func setUpBottomView() {
        bottomView.button.addTarget(self, action: #selector(bottomButtonPressed(_:)), for: .touchDown)
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 70),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    fileprivate func setupAddButton() {
        let size = self.view.frame.width / 8
        let buttonImage = Images.addPlayerButton?.circleMask(borderWidth: 10)
        addButton.setImage(buttonImage, for: .normal)
        
        
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        addButton.centerYAnchor.constraint(equalTo: labelAndGradient.bottomAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: labelAndGradient.trailingAnchor, constant: -40).isActive = true
        
        addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
    }
    
}


extension PlayersScreen: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}


extension PlayersScreen: AddNewPlayerDelegate {
    func updateData() {
        loadPlayers()
        applySnapshot(players: Array(players!))
    }
    
    
}

