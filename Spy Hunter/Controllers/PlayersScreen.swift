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
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var player1Picture: UIImageView!
    @IBOutlet weak var player1Name: UILabel!
    @IBOutlet weak var player2Picture: UIImageView!
    @IBOutlet weak var player2Name: UILabel!
    @IBOutlet weak var player3Picture: UIImageView!
    @IBOutlet weak var player3Name: UILabel!
    @IBOutlet weak var player4Picture: UIImageView!
    @IBOutlet weak var player4Name: UILabel!
    @IBOutlet weak var player5Picture: UIImageView!
    @IBOutlet weak var player5Name: UILabel!
    @IBOutlet weak var player6Picture: UIImageView!
    @IBOutlet weak var player6Name: UILabel!
    @IBOutlet weak var player7Picture: UIImageView!
    @IBOutlet weak var player7Name: UILabel!
    @IBOutlet weak var player8Picture: UIImageView!
    @IBOutlet weak var player8Name: UILabel!
    @IBOutlet weak var player9Picture: UIImageView!
    @IBOutlet weak var player9Name: UILabel!
    @IBOutlet weak var player10Picture: UIImageView!
    @IBOutlet weak var player10Name: UILabel!
    @IBOutlet weak var player11Picture: UIImageView!
    @IBOutlet weak var player11Name: UILabel!
    @IBOutlet weak var player12Picture: UIImageView!
    @IBOutlet weak var player12Name: UILabel!
    @IBOutlet weak var playersBarButton: UIBarButtonItem!
    
    @IBOutlet weak var labelAndGradient: UIView!
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
        button.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var numberOfPlayersBefore = Int()
    var numberOfPlayersNow = Int()
    
    var picturesArray = [UIImageView]()
    var namesArray = [UILabel]()
    
    private let realm = try! Realm()
    private var players: Results<PlayerModel>?
    
    private let names = StringFiles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersBarButton.title = names.players
        //Adds label and Gradient
        setUpLabelViewAndGradient()
        addButtonSetup()
        //pop to root functionality
        customizedButton()
        //change nextButton style
        setUpBottomView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPlayers()
        
        //this code will delete redundant players
        if players?.count != 0 {
            numberOfPlayersNow = players!.count
            //checks if there are redundant players and deletes them
            if numberOfPlayersBefore > numberOfPlayersNow {
                deleteRedundandPics()
            }
        }
        
        //put new players
        populateViewsWithPlayers()
    }
    override func viewWillAppear(_ animated: Bool) {
        picturesArray = [player1Picture, player2Picture, player3Picture, player4Picture, player5Picture, player6Picture, player7Picture, player8Picture, player9Picture, player10Picture, player11Picture, player12Picture]
        namesArray = [player1Name, player2Name, player3Name, player4Name, player5Name, player6Name, player7Name, player8Name, player9Name, player10Name, player11Name, player12Name ]
        
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
           view.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
          
           //Label and Gradient View
           setupLabelAndGradientView()
           
           //Gradient Settings
           setupGradient()
           
            //Label settings
           setupPageLabel()
          
           setupAddButton()
       }
    
    fileprivate func setupGradient() {
        //Gradient Settings
        let pageLabelGradient = CAGradientLayer()
        pageLabelGradient.frame = labelAndGradient.bounds
        pageLabelGradient.colors = [UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1), UIColor(displayP3Red: 111/255, green: 171/255, blue: 239/255, alpha: 1)].map {$0.cgColor}
        labelAndGradient.layer.insertSublayer(pageLabelGradient, at: 0)
    }
    
    fileprivate func setupLabelAndGradientView() {
        //NavBar height + statusBar
        let height = getDeviceHeight()
        
        //Label and Gradient View
        labelAndGradient.frame = CGRect(x: 0, y: height, width: self.view.frame.width, height: self.view.frame.height/11)
        view.insertSubview(labelAndGradient, at: 0)
        
        labelAndGradient.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelAndGradient.topAnchor.constraint(equalTo: view.topAnchor, constant: height),
            labelAndGradient.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            labelAndGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            labelAndGradient.heightAnchor.constraint(equalToConstant: view.frame.height/11)
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
    
    fileprivate func setupAddButton() {
        //AddButton setup
        let size = self.view.frame.width / 8
        
        labelAndGradient.insertSubview(addButton, at: 1)
        addButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        addButton.centerYAnchor.constraint(equalTo: labelAndGradient.bottomAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: labelAndGradient.trailingAnchor, constant: -40).isActive = true
    }
    
   
    
    fileprivate func setUpBottomView() {
        let bottomView = UIView(frame: CGRect(x: 0, y: view.frame.height/1.2, width: view.frame.width, height: view.frame.height/9))
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
    //MARK: - Add Players on the screen
    
    
    private func addButtonSetup() {
        let buttonImage = UIImage(named: "addPlayerButton.png")?.circleMask(borderWidth: 10)
        addButton.setImage(buttonImage, for: .normal)
    }
    
    private func loadPlayers() {
        players = realm.objects(PlayerModel.self).filter("isPlaying == true")
        
    }
    
    private func populateViewsWithPlayers() {
        
        if let unwrappedPlayers = players {
            for (i, player) in unwrappedPlayers.enumerated() {
                if let picture = loadImageFromDocumentDirectory(path: player.picture) {
                    picturesArray[i].image = picture.rotate(radians: .pi/2)?.circleMask()
                    namesArray[i].minimumScaleFactor = 9
                    namesArray[i].font = UIFont.systemFont(ofSize: 14)
                    namesArray[i].numberOfLines = 0
                    namesArray[i].lineBreakMode = .byWordWrapping
                    namesArray[i].text = player.name
                }
            }
        }
        
    }
    //MARK: - Data Managment: Load and Delete
    
    private func loadImageFromDocumentDirectory(path: String) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: URL(string: path)!)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
    
    private func deleteRedundandPics() {
        var predicate = players!.count
        if picturesArray[predicate].image != nil {
            repeat{
                picturesArray[predicate].image = nil
                namesArray[predicate].text = nil
                predicate += 1
            }
                while predicate != numberOfPlayersBefore
        }
    }
    
    
    
    //MARK: - Segues
    
    
    
    @IBAction func libraryButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "PlayerScreenToLibrary", sender: self)
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "PlayerScreenToNewPlayer", sender: self)
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
    
    
    @objc func popToRoot() {
        //Make smooth segue
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(displayP3Red: 185/255, green: 43/255, blue: 39/255, alpha: 1), UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1)].map {$0.cgColor}
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        labelAndGradient.layer.removeFromSuperlayer()
        performSegue(withIdentifier: "PlayerScreenToMain", sender: self)
    }
    
    
    //MARK: - Button Settings
    
    
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
    
    
}


