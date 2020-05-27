//
//  RoleRevealViewController.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 21.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift

class RoleRevealViewController: UIViewController {
    
    private let realm = try! Realm()
    private let userSeeThisView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.numberOfLines = 0
        button.setTitle("Гаразд", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = UIColor.init(displayP3Red: 227/255, green: 66/255, blue: 52/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private let instructions: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "test"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 18/255, green: 24/255, blue: 29/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont(name: "Futura-Bold", size: 20)
        label.textAlignment = .center
        label.textColor = UIColor(displayP3Red: 1/255, green: 11/255, blue: 19/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pictureToShow: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 42, weight: .medium)
        label.textAlignment = .center
        label.text = "test"
        label.alpha = 0
        return label
    }()
    
    private let labelFont = UIFont.systemFont(ofSize: 20)
    var numberOfSpies = Int()
    var locations = [String]()
    var locationToPlay = String()
    var players: Results<PlayerModel>?
    private let hostText = "Всі гравці мають сиділи в в колі, обличчям один до одного. Починає гру ведучий. \n \nВін читатиме інструкції та передасть девайс наступному гравцю. Кожен гравець побачить або локацію, або ж дізнається що він шпіон. Під час кола обговорень не можна називати локацію"
    private var buttonSwitcher = true
    private var playerNumber = 0
    
    //time is for Animation purposes
    private var timer = Timer()
    private var totalTime = 150
    private var timePassed = 0
    
    //time for circleAnimation
    private var shapeLayer = CAShapeLayer()
    private var pulsatingLayer = CAShapeLayer()
    var discussionTime = Int()
    private var time = Int()  // is set in startDiscussion method
    private var labelTimePassed = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activateConstraints()
        deleteSpies()
        gameStarts()
        
    }
    
    
    private func activateConstraints() {
        view.addSubview(userSeeThisView)
        view.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        userSeeThisView.addSubview(nextButton)
        userSeeThisView.addSubview(instructions)
        userSeeThisView.addSubview(pictureToShow)
        userSeeThisView.addSubview(playerNameLabel)
        
        //set custom height for Label (instructions) and userNameLabel
        let heightConstraint = NSLayoutConstraint(item: instructions, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: calculateLabelHeight(text: hostText, font: labelFont, width: self.view.frame.width * 0.85))
        self.instructions.addConstraint(heightConstraint)
        
        let userNameHeightConstraint = NSLayoutConstraint(item: playerNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: calculateLabelHeight(text: "Roman", font: labelFont, width: self.view.frame.width))
        self.playerNameLabel.addConstraint(userNameHeightConstraint)
        NSLayoutConstraint.activate([
            //ViewContstrints
            self.userSeeThisView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
            self.userSeeThisView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            self.userSeeThisView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.userSeeThisView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            
            //imageView Constraints
            self.pictureToShow.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.27),
            self.pictureToShow.widthAnchor.constraint(equalTo: self.pictureToShow.heightAnchor),
            self.pictureToShow.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.pictureToShow.topAnchor.constraint(equalTo: userSeeThisView.topAnchor, constant: 80),
            
            //playerNameLabel Constraints
            self.playerNameLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            self.playerNameLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.playerNameLabel.topAnchor.constraint(equalTo: pictureToShow.bottomAnchor, constant: 20),
            
            //label (instructions) Constraints
            self.instructions.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            self.instructions.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.instructions.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 10),
            
            //nextButton Constraints
            self.nextButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.07),
            self.nextButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.35),
            self.nextButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.nextButton.topAnchor.constraint(equalTo: instructions.bottomAnchor, constant: 35)
        ])
        
    }
    
    //BEGINNING OF THE GAME
    private func gameStarts() {
        
        //unwrap optional players
        if let firstPlayer = players?.first {
        let hostName = firstPlayer.name
            //get userName and userPicture
            if let hostImage = loadImageFromDocumentDirectory(path: firstPlayer.picture) {
                
                //method to put 2 pictures into 1
                let topImage = UIImage(named: "crown.png")?.resizeImage(155, opaque: false, contentMode: .scaleAspectFit)
                let bottomImage = hostImage.resizeImage(220, opaque: false, contentMode: .scaleAspectFit).rotate(radians: .pi/2)?.circleMask
                let size = CGSize(width: bottomImage!.size.width, height: topImage!.size.height + bottomImage!.size.height)
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                
                bottomImage!.draw(in: CGRect(x: 0, y: topImage!.size.height - 40, width: bottomImage!.size.width, height: bottomImage!.size.height))
                topImage!.draw(in: CGRect(x: (bottomImage!.size.width / 2) - (topImage!.size.width / 2), y: 0, width: topImage!.size.width, height: topImage!.size.height))
                
                let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                // set picture and name
                pictureToShow.image = newImage
                playerNameLabel.text = "\(hostName) ведучий!"
                instructions.text = hostText
                
                playerGetsTheRole()
                
            }
        }
    }
    // load pictures from Documents Folder. Path is from the Player's DB
    private func loadImageFromDocumentDirectory(path: String) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: URL(string: path)!)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
    
    
    
    //pressing on button first time should show the current player's picture, second tap will show his role
    //buttonSwitch helped to implement this functionality
    @objc private func buttonPressed(_ sender: UIButton) {
        
        // check if player number is not equal to player's count (out of bounds)
        if playerNumber != players?.count {
            if buttonSwitcher == true {
                   if let players = players {
                       
                       // load image from docs, make it smaller, rotate it and make a circle
                       let playerPicture = loadImageFromDocumentDirectory(path: players[playerNumber].picture)?.circleMask?.resizeImage(160, opaque: false).rotate(radians: .pi/2)
                       pictureToShow.image = playerPicture
                       pictureToShow.isOpaque = true
                       updateLabel(playerName: players[playerNumber].name)
                       
                       pictureToShow.isUserInteractionEnabled = true
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                       pictureToShow.addGestureRecognizer(tapGestureRecognizer)
                    
                       
                   }
                   //Button is pressed. User picture is revealed. In order for user to press on picture i need to hide the button
                   nextButton.alpha = 0
                   
                   //animation on Player Picture
                   addAnimation()
                   
               } else {
                   // make picture transparent to activate animation
                   pictureToShow.alpha = 0
                   timer.invalidate()
                   timePassed = 0
                   nextButton.setTitle("OK", for: .normal)
                  if players![playerNumber].isSpy == true {
                                 setSpyAnimation()
                             } else {
                                 setNonSpyAnimation()
                             }
            
               }
            // the player number is equal player's count. The discussion should start
        } else {
            timer.invalidate()
            startDiscussion()
        }
    }
    //PRESS ON PICTURE
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //deletes animation
        pictureToShow.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        //shows picture with red circle around it
        pictureToShow.image = loadImageFromDocumentDirectory(path: players![playerNumber].picture)?.redCircleMask!.resizeImage(165, opaque: false).rotate(radians: .pi/2)
        
        
        nextButton.alpha = 1
        
        //set switcher to true, so the button can perform another action
        nextButton.setTitle("Дізнатись локацію", for: .normal)
        nextButton.titleLabel?.textAlignment = .center
        
        buttonSwitcher = false
        
        //cannot tap again
        pictureToShow.removeGestureRecognizer(tapGestureRecognizer)
       }
    
    private func updateLabel(playerName: String) {
        
        playerNameLabel.text = playerName
        
        //set up new height for instructions label
        for constraint in instructions.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = 100
            }
        }
        
        instructions.text = "Передайте девайс цьому гравцю. Нажми на фото, що дізнатись свою роль"
    }
    
    private func addAnimation() {
        let buttonPressedAnimation = UIImage(named: "buttonPressedAnimation.png")?.circleMask!.resizeImage(160, opaque: false).cgImage
        let animationLayer = CALayer()
        animationLayer.isOpaque = true
        animationLayer.frame = pictureToShow.bounds
        animationLayer.contents = buttonPressedAnimation
        animationLayer.opacity = 0
        animationLayer.flash(duration: 3)
        pictureToShow.layer.insertSublayer(animationLayer, at: 0)
    }
    
    private func setSpyAnimation() {
        
        pictureToShow.image = UIImage(named: "StylishSpy")?.resizeImage(220, opaque: false)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        playerNameLabel.text = "Твоя роль - Шпіон"
        instructions.text = "Постарайся видати, що ти шпіон, та дізнатись локацію, щоб виграти"
        
        //switch the switcher, so the correct button is displayed. If true - Player picture is displayed. False - his role
        buttonSwitcher = true
        
        //add +1 , so i can choose next player from the RESULTS
        playerNumber += 1
        
        
  
    }
    
    
    //Implementation of the FADE-IN animation
    @objc private func updateTimer() {
        if timePassed < totalTime {
        timePassed += 1
            pictureToShow.alpha = CGFloat(timePassed) / CGFloat(totalTime)
    }
    }
    
    private func setNonSpyAnimation() {
        pictureToShow.image = UIImage(named: "topSecretLogo.png")?.resizeImage(220, opaque: false)
    
        timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        playerNameLabel.text = "Локація - \(locationToPlay)"
        instructions.text = "Задавай питання про це місце та давай відповіді так, щоб не видати лоацію!"
        
        //switch the switcher, so the correct button is displayed. If true - Player picture is displayed. False - his role
        buttonSwitcher = true
        
        //add +1 , so i can choose next player from the RESULTS
        playerNumber += 1
    }
    
    private func playerGetsTheRole() {
            var counter = 0
            repeat {
                if players?.randomElement()?.isSpy == false {
                    do {
                        try realm.write {
                            players?.randomElement()?.isSpy = true
                        }
                    } catch {
                        print(error)
                    }
                    counter += 1
                }
            }
                while counter <= numberOfSpies
            
            //choose the location to play
            locationToPlay = locations.randomElement()!
    }
    private func deleteSpies() {
        
        //Some players might be spies from the last game.
        //This will make them peaceful
        if let players = players {
            for player in players {
                do {
                    try realm.write {
                        player.isSpy = false
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    //DISCUSSION BEGINS
 
    fileprivate func prepareForCircleAnimation() {
        userSeeThisView.alpha = 0
          time = discussionTime * 60
        
          timeLabel.alpha = 1
          timeLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.height / 10)
          timeLabel.center = view.center
              setTimeLabel()
        view.addSubview(timeLabel)
        
        
        
    }
    
    private func setupAnimationLayers() {
        // add animation layers
        let vividTangerine = UIColor(displayP3Red: 250/255, green: 170/255, blue: 141/255, alpha: 1)
        let eerieBlack = UIColor(displayP3Red: 77/255, green: 75/255, blue: 76/255, alpha: 1)
        let flamingRed = UIColor(displayP3Red: 228/255, green: 87/255, blue: 46/255, alpha: 1)
        let antiqueWhite = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        pulsatingLayer = createCircleShapeLayer(fillColor: vividTangerine, strokeColor: .clear)
        view.layer.addSublayer(pulsatingLayer)
        
        let trekLayer = createCircleShapeLayer(fillColor: antiqueWhite, strokeColor: eerieBlack)
        view.layer.addSublayer(trekLayer)
        
        shapeLayer = createCircleShapeLayer(fillColor: .clear, strokeColor: flamingRed)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
    }
    
    private func startDiscussion() {
        // add animation layers
        setupAnimationLayers()
        //hide background
        prepareForCircleAnimation()
        
        //turn on animation
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateLabelTimer), userInfo: nil, repeats: true)
        animatePulsatingLayer(pulsatingLayer)
        createCircleAnimation()
        
    }
    
    private func createCircleShapeLayer(fillColor: UIColor, strokeColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: view.frame.width * 0.35, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.lineCap = .round
        layer.fillColor = fillColor.cgColor
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 18
        layer.position = view.center
        return layer
    }
    
    private func animatePulsatingLayer(_ pulsatingLayer: CAShapeLayer) {
        let pulsatingAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulsatingAnimation.toValue = 1.2
        pulsatingAnimation.duration = 0.8
        pulsatingAnimation.autoreverses = true
        pulsatingAnimation.repeatCount = .infinity
        pulsatingAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pulsatingLayer.add(pulsatingAnimation, forKey: "pulsate")
    }
    
    private func createCircleAnimation() {
           let animation = CABasicAnimation(keyPath: "strokeEnd")
           animation.toValue = 1
           animation.duration = CFTimeInterval(time)
           animation.fillMode = .forwards
           animation.isRemovedOnCompletion = false
           shapeLayer.add(animation, forKey: "circlularAnimation")
       }
   
    
    @objc private func updateLabelTimer() {
        time -= 1
        setTimeLabel()
        if time == 0 {
            timer.invalidate()
            let alert = UIAlertController(title: "Час вийшов", message: "Пора вирішувати хто шпіон", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func setTimeLabel() {
           let minutes = Int(time) / 60 % 60
           let seconds = Int(time) % 60
           
           timeLabel.text = String(format:"%02i:%02i", minutes, seconds)
       }
    
    
    // Height for label (instructions)
    private func calculateLabelHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        var currentHeight: CGFloat!
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        currentHeight = label.frame.height
        
        return currentHeight
    }
}
//MARK: - FLASH ANIMATION

extension CALayer {
    
    func flash(duration: TimeInterval) {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.beginTime = CACurrentMediaTime() + 3
        flash.fromValue = NSNumber(value: 0)
        flash.toValue = NSNumber(value: 1)
        flash.duration = duration
        flash.autoreverses = true
        flash.repeatCount = 20
        
        removeAnimation(forKey: "flashAnimation")
        add(flash, forKey: "flashAnimation")
        opacity = 0     // Change the actual data value in the layer to the final value
    }
}
