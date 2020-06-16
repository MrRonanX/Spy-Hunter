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
    
   typealias DataSource = UICollectionViewDiffableDataSource<Section, PlayerModel>
   typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, PlayerModel>
    
    private var collectionView: UICollectionView!
    private var viewForCollection: UIView!
    
    @IBOutlet weak var playersBarButton: UIBarButtonItem!
    private var labelAndGradient: UIView!
    private var bottomView: UIView!
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.borderWidth = 0
        label.layer.borderColor = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var numberOfPlayersBefore = Int()
    var numberOfPlayersNow = Int()
  
    private let realm = try! Realm()
    private var players: Results<PlayerModel>?
    private var dataSource: DataSource!
    private var snapshot = DataSourceSnapshot()
    
    
    
     
    
    private let names = StringFiles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        playersBarButton.title = names.players
        loadPlayers()

        //change nextButton style
        setUpBottomView()
        //Adds label and Gradient
        setUpLabelViewAndGradient()
        //setupCollectionView
        setupCollectionView()
        //pop to root functionality
        customizedButton()
        
        configure()
        
        setupAddButton()
        
        
    }
    
    //MARK: - Label and Gradient
    
    
    private func getDeviceHeight() -> CGFloat{
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
    
    private func setUpLabelViewAndGradient() {

        //Label and Gradient View
        setupLabelAndGradientView()
        
        //Gradient Settings
        setupGradient()
        
        //Label settings
        setupPageLabel()
        
        
    }
    
    
    
    fileprivate func setupGradient() {
        //Gradient Settings
        let pageLabelGradient = CAGradientLayer()
        pageLabelGradient.frame = labelAndGradient.bounds
        pageLabelGradient.colors = [UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1), UIColor(displayP3Red: 111/255, green: 171/255, blue: 239/255, alpha: 1)].map {$0.cgColor}
        labelAndGradient.layer.insertSublayer(pageLabelGradient, at: 0)
    }
    
    fileprivate func setupLabelAndGradientView() {
        labelAndGradient = UIView()
        
        //NavBar height + statusBar
    
        let height = getDeviceHeight()
        
        //Label and Gradient View
        labelAndGradient.frame = CGRect(x: 0, y: height, width: self.view.frame.width, height: self.view.frame.height/11)
        view.addSubview(labelAndGradient)
 
        labelAndGradient.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelAndGradient.topAnchor.constraint(equalTo: view.topAnchor, constant: height),
            labelAndGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            labelAndGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            labelAndGradient.bottomAnchor.constraint(equalTo: labelAndGradient.topAnchor, constant: view.frame.height/11)
        ])
    }
    
    fileprivate func setupPageLabel() {
        //Label settings
        let relativeFontConstant:CGFloat = 0.0215
        pageLabel.text = names.pressPlus
        pageLabel.bounds = labelAndGradient.bounds
        pageLabel.font = pageLabel.font.withSize(view.bounds.height * relativeFontConstant)
        labelAndGradient.addSubview(pageLabel)
        
        NSLayoutConstraint.activate([
            pageLabel.topAnchor.constraint(equalTo: labelAndGradient.topAnchor, constant: 0),
            pageLabel.bottomAnchor.constraint(equalTo: labelAndGradient.bottomAnchor, constant: 0),
            pageLabel.trailingAnchor.constraint(equalTo: labelAndGradient.trailingAnchor, constant: 0),
            pageLabel.leadingAnchor.constraint(equalTo: labelAndGradient.leadingAnchor, constant: 0),
            pageLabel.centerXAnchor.constraint(equalTo: labelAndGradient.centerXAnchor, constant: 0),
            pageLabel.centerYAnchor.constraint(equalTo: labelAndGradient.centerYAnchor, constant: 0)
        ])
    }
    
    //MARK: - Collection View Setup
    
    fileprivate func configure() {
        print("configure")
        collectionView = UICollectionView(frame: viewForCollection.bounds, collectionViewLayout: UIHelper.createThreeColFlowLayout(in: viewForCollection))
        collectionView.bounds = viewForCollection.bounds
        collectionView.delegate = self

        collectionView.register(PlayerScreen_PlayerCell.self, forCellWithReuseIdentifier: PlayerScreen_PlayerCell.reuseIdentifier)
        viewForCollection.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        configureCollectionViewDataSource()
        createDummyData()
    }
    
    private func setupCollectionView() {
        
        let x: CGFloat = 0
        let y = getDeviceHeight() + view.bounds.height / 11
        let width = view.bounds.width
        let height = view.bounds.height - getDeviceHeight() - view.bounds.height / 11 - view.bounds.height / 9
        viewForCollection = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        view.addSubview(viewForCollection)
        viewForCollection.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            viewForCollection.topAnchor.constraint(equalTo: labelAndGradient.bottomAnchor),
//            viewForCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            viewForCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            viewForCollection.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
//        ])
          
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
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func loadImageFromDocumentDirectory(path: String) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: URL(string: path)!)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
    
    
    
    
    //MARK: - Segues
    
    @IBAction func libraryButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "PlayerScreenToLibrary", sender: self)
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "PlayerScreenToNewPlayer", sender: self)
    }
    
    @objc func popToRoot() {
        //Make smooth segue
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(displayP3Red: 185/255, green: 43/255, blue: 39/255, alpha: 1), UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1)].map {$0.cgColor}
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        labelAndGradient.layer.removeFromSuperlayer()
        performSegue(withIdentifier: "PlayerScreenToMain", sender: self)
    }
    
    @objc private func bottomButtonPressed(_ sender: UIButton) {
        if players?.count != 0 {
            performSegue(withIdentifier: "PlayerScreenToGameSettings", sender: self)
        } else {
            let alert = UIAlertController(title: names.error, message: names.addOnePlayer, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerScreenToGameSettings" {
            let destinationVC = segue.destination as! GameSettings
            destinationVC.players = players
        }
    }
    
    
    //MARK: - Button Settings
    
    fileprivate func setUpBottomView() {
        bottomView = UIView(frame: CGRect(x: 0, y: view.frame.height/1.2, width: view.frame.width, height: view.frame.height/9))
        bottomView.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        let bottomButton = UIButton()
        bottomView.addSubview(bottomButton)
        bottomButton.setTitle(names.next, for: .normal)
        bottomButton.setTitleColor(.black, for: .normal)
        bottomButton.titleLabel?.font = .systemFont(ofSize: 20)
        bottomButton.backgroundColor = UIColor.init(displayP3Red: 227/255, green: 66/255, blue: 52/255, alpha: 1)
        bottomButton.layer.cornerRadius = 5
        bottomButton.addTarget(self, action: #selector(bottomButtonPressed(_:)), for: .touchDown)
        
        let margin = CGFloat(50)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -30).isActive = true
        bottomButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 5).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -5).isActive = true
        view.addSubview(bottomView)
        
        bottomView.center = CGPoint(x: view.frame.width / 2,
                                    y: view.frame.height - bottomButton.frame.height / 2 - margin)
        
        
    }
    
    private func customizedButton() {
        navigationController!.setNavigationBarHidden(false, animated: true)
        let myBackButton:UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        myBackButton.addTarget(self, action: #selector(popToRoot), for: UIControl.Event.touchUpInside)
        myBackButton.setTitle(names.back, for: UIControl.State.normal)
        myBackButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    fileprivate func setupAddButton() {
        //AddButton setup
        let size = self.view.frame.width / 8
        let buttonImage = UIImage(named: "addPlayerButton.png")?.circleMask(borderWidth: 10)
        addButton.setImage(buttonImage, for: .normal)
        
        
        view.addSubview(addButton)
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



extension PlayersScreen: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("UICollectionViewDelegateFlowLayout Called")
        let width = view.bounds.width / 4
        return CGSize(width: width, height: width)
    }
}

