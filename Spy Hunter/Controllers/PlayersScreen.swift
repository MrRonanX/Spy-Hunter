//
//  PlayersScreen.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
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
    @IBOutlet weak var addButtonPressed: UIImageView!
    @IBOutlet weak var nextButtonPressed: UIButton!
    var numberOfPlayersBefore = Int()
    var numberOfPlayersNow = Int()

    var picturesArray = [UIImageView]()
    var namesArray = [UILabel]()
    
    private let realm = try! Realm()
    private var players: Results<PlayerModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // this will allow me to tap on picture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        addButtonPressed.addGestureRecognizer(tapGestureRecognizer)
        addButtonPressed.image = #imageLiteral(resourceName: "plus").circleMask
        
        
        //pop to root functionality
        customizedButton()
        //change nextButton style
        setButtonsStyle()
        
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
    
    //MARK: - Add Players on the screen
    
    

    
     private func loadPlayers() {
        players = realm.objects(PlayerModel.self).filter("isPlaying == true")
        
    }
    
    private func populateViewsWithPlayers() {
        
        if let unwrappedPlayers = players {
            for (i, player) in unwrappedPlayers.enumerated() {
                if let picture = loadImageFromDocumentDirectory(path: player.picture) {
                    picturesArray[i].image = picture.circleMask?.rotate(radians: .pi/2)
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
           
         performSegue(withIdentifier: "PlayerScreenToNewPlayer", sender: self)
       }
    private func customizedButton() {
        navigationController!.setNavigationBarHidden(false, animated: true)
        let myBackButton:UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        myBackButton.addTarget(self, action: #selector(popToRoot), for: UIControl.Event.touchUpInside)
        myBackButton.setTitle("Назад", for: UIControl.State.normal)
        myBackButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    
    @objc func popToRoot() {
        viewBackground.backgroundColor = UIColor(red: 2/255, green: 66/255, blue: 73/255, alpha: 1)
        performSegue(withIdentifier: "PlayerScreenToMain", sender: self)
    }
    
    
    //MARK: - Button Settings
    
    func setButtonsStyle() {
        let awesomeColor = UIColor(red: 250/255, green: 116/255, blue: 79/255, alpha: 1)
       
            nextButtonPressed.setTitle("  \(nextButtonPressed.currentTitle!)  ", for: .normal)
            nextButtonPressed.backgroundColor = UIColor(red: 247/255, green: 144/255, blue: 113/255, alpha: 1)
            nextButtonPressed.setTitleColor(UIColor.white, for: .normal)
            nextButtonPressed.layer.cornerRadius = 10
            nextButtonPressed.layer.borderWidth = 2
            nextButtonPressed.layer.borderColor = awesomeColor.cgColor
        
    }
}

