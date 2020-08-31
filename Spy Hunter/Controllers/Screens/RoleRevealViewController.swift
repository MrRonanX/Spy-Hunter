//
//  RoleRevealViewController.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 21.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import RealmSwift

fileprivate let names = Strings()

class RoleRevealViewController: UIViewController {
    
    private let realm           = try! Realm()
    private let userSeeThisView = UIView()
    
    private let nextButton      = SHButton()
    
    private let instructions    = SHBodyLabel(textAlignment: .left, fontSize: .body)
    private let playerNameLabel = SHBodyLabel(textAlignment: .center, fontSize: .title1)
    
    private let pictureToShow   = UIImageView()
    
    private let timeLabel       = SHBodyLabel(textAlignment: .center, fontSize: .title1)
    
    private let showSpiesButton = SHButton(backgroundColor: .clear, title: names.showSpy)
    
    private let labelFont       = UIFont.systemFont(ofSize: 20)
    var numberOfSpies           = Int()
    var locations               = [String]()
    var locationToPlay          = String()
    var players                 : Results<PlayerModel>?
    lazy private var hostText   = names.instructions
    private var buttonSwitcher  = true
    private var playerNumber    = 0
    
    //time is for Animation purposes
    private var timer           = Timer()
    private var totalTime       = 150
    private var timePassed      = 0
    
    //time for circleAnimation
    private var shapeLayer      = CAShapeLayer()
    private var pulsatingLayer  = CAShapeLayer()
    var discussionTime          = Int()
    private var time            = Int()  // is set in startDiscussion method
    
    private var enteredBackgroundTime = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.backBarButtonItem    = UIHelper.setupBackButton()
        activateConstraints()
        setupSpiesButtonAndTimeLabel()
        deleteSpies()
        gameStarts()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - Background and Foreground observers
    
    
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timeEnteredBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func timeEnteredBackground() {
        enteredBackgroundTime = Date().timeIntervalSince1970
        
        if time > 0 { ScheduleNotification().scheduledNotification(notificationType: names.timeIsUp, time: Double(time)) }
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer(pulsatingLayer)
        if time > 0 { time -= Int(Date().timeIntervalSince1970 - enteredBackgroundTime) }
        
    }
    
    //MARK: - GAME FUNCTIONALITY
    
    
    //BEGINNING OF THE GAME
    private func gameStarts() {
        
        if let firstPlayer = players?.randomElement() {
            let hostName = firstPlayer.name
            //get userName and userPicture
            if let hostImage = UIHelper.loadImageFromDocumentDirectory(path: firstPlayer.picture) {
                
                //method to put 2 pictures into 1
                let topImage = Images.crownImage?.resizeImage(155, opaque: false, contentMode: .scaleAspectFit)
                let bottomImage = hostImage.resizeImage(220, opaque: false, contentMode: .scaleAspectFit).circleMask()
                let size = CGSize(width: bottomImage!.size.width, height: topImage!.size.height + bottomImage!.size.height)
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                
                bottomImage!.draw(in: CGRect(x: 0, y: topImage!.size.height - 40, width: bottomImage!.size.width, height: bottomImage!.size.height))
                topImage!.draw(in: CGRect(x: (bottomImage!.size.width / 2) - (topImage!.size.width / 2), y: 0, width: topImage!.size.width, height: topImage!.size.height))
                
                let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                // set picture and name
                pictureToShow.image = newImage
                playerNameLabel.text = "\(hostName) \(names.host)"
                instructions.text = hostText
                
                playerGetsTheRole()
            }
        }
    }
    

    //pressing on button first time should show the current player's picture, second tap will show his role
    //buttonSwitch helped to implement this functionality
    @objc private func buttonPressed(_ sender: UIButton) {
        
        // check if player number is not equal to player's count (out of bounds)
        if playerNumber != players?.count {
            if buttonSwitcher == true {
                if let players = players {
                    
                    // load image from docs, make it smaller and make a circle
                    let playerPicture = UIHelper.loadImageFromDocumentDirectory(path: players[playerNumber].picture)!.resizeImage(200, opaque: false).circleMask()
                    pictureToShow.image = playerPicture
                    pictureToShow.isOpaque = true
                    updateLabel(playerName: players[playerNumber].name)
                    
                    pictureToShow.isUserInteractionEnabled = true
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                    pictureToShow.addGestureRecognizer(tapGestureRecognizer)
                }
                //Button is pressed. User picture is revealed. In order for user to press on picture I need to hide the button
                nextButton.alpha = 0
                
                //animation on Player Picture
                addAnimation()
                
            } else {
                // make picture transparent to activate animation
                pictureToShow.alpha = 0
                timer.invalidate()
                timePassed = 0
                nextButton.setTitle("OK", for: .normal)
                players![playerNumber].isSpy == true ? youAreTheSpy() : youAreCivilian()
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
        pictureToShow.image = UIHelper.loadImageFromDocumentDirectory(path: players![playerNumber].picture)!.resizeImage(200, opaque: false).redCircleMask
        
        nextButton.alpha = 1
        
        //set switcher to true, so the button can perform another action
        nextButton.setTitle(names.showLocation, for: .normal)
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
        
        instructions.text = names.passPhone
    }
    
    
    private func addAnimation() {
        let buttonPressedAnimation  = Images.buttonPressedAnim!.resizeImage(150, opaque: false).circleMask()?.cgImage
        let animationLayer          = CALayer()
        animationLayer.isOpaque     = true
        animationLayer.frame        = pictureToShow.bounds
        animationLayer.contents     = buttonPressedAnimation
        animationLayer.opacity      = 0
        animationLayer.flash(duration: 3)
        pictureToShow.layer.insertSublayer(animationLayer, at: 0)
    }
    
    
    private func youAreTheSpy() {
        
        pictureToShow.image = Images.stylishBoy?.resizeImage(220, opaque: false)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        playerNameLabel.text = names.youSpy
        instructions.text = names.spyHint
        instructions.textAlignment = .center
        
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
    
    
    private func youAreCivilian() {
        pictureToShow.image = UIImage(named: "topSecretLogo.png")?.resizeImage(220, opaque: false)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        playerNameLabel.text = "\(names.locationIs) \(locationToPlay)"
        instructions.text = names.notSpyHint
        instructions.textAlignment = .center
        
        //switch the switcher, so the correct button is displayed. If true - Player picture is displayed. False - his role
        buttonSwitcher = true
        
        //add +1 , so i can choose next player from the RESULTS
        playerNumber += 1
    }
    
    //MARK: - Player get the role
    
    
    private func playerGetsTheRole() {
        var counter = 0
        guard var number = (1...players!.count).randomElement() else { return }
        while (counter < numberOfSpies) {
            
            if players?[number - 1].isSpy == false {
                do {
                    try realm.write {
                        players?[number - 1].isSpy = true
                    }
                } catch {
                    print(error)
                }
                counter += 1
            } else {
                number = (0...players!.count).randomElement()!
            }
        }
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
    //MARK: - Discussion begins
    
    private func startDiscussion() {
        // add animation layers
        setupAnimationLayers()
        //hide background
        prepareForCircleAnimation()
        
        //turn on animation
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateLabelTimer), userInfo: nil, repeats: true)
        animatePulsatingLayer(pulsatingLayer)
        createCircleAnimation()
        
        setupNotificationObservers()
    }
    
    
    fileprivate func prepareForCircleAnimation() {
        userSeeThisView.alpha = 0
        time = discussionTime * 60
        timeLabel.alpha = 1
        timeLabel.font = .systemFont(ofSize: 42, weight: .medium)
        timeLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.height / 10)
        setTimeLabel()
        view.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    
    @objc private func updateLabelTimer() {
        time -= 1
        setTimeLabel()
        if time <= 0 {
            timer.invalidate()
            timeLabel.removeFromSuperview()
            let alert = UIAlertController(title: names.outOfTime, message: names.decideWhoSpy, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) in
                self.presentWhoIsTheSpyButton()
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func setTimeLabel() {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        timeLabel.text = String(format:"%02i:%02i", minutes, seconds)
    }
    
    //MARK: - Circle Animations
    
    
    private func setupAnimationLayers() {
        pulsatingLayer = createCircleShapeLayer(fillColor: Colors.vividTangerine, strokeColor: .clear)
        view.layer.addSublayer(pulsatingLayer)
        
        let trekLayer = createCircleShapeLayer(fillColor: Colors.antiqueWhite, strokeColor: Colors.eerieBlack)
        view.layer.addSublayer(trekLayer)
        
        shapeLayer = createCircleShapeLayer(fillColor: .clear, strokeColor: Colors.flamingRed)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
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
        pulsatingAnimation.duration = 0.7
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
    
    
    //MARK: - Show Spies Button Appears
    
    private func setupSpiesButtonAndTimeLabel() {
        showSpiesButton.setShowSpiesButton()
        showSpiesButton.addTarget(self, action: #selector(showSpiesButtonPressed(_:)), for: .touchUpInside)
        timeLabel.alpha = 0
    }
    
    
    private func presentWhoIsTheSpyButton() {
        showSpiesButton.alpha = 1
        
        view.addSubview(showSpiesButton)
        
        NSLayoutConstraint.activate([
            showSpiesButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showSpiesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showSpiesButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2.3),
            showSpiesButton.heightAnchor.constraint(equalToConstant: view.bounds.height / 12)
        ])
    }
    
    
    @objc private func showSpiesButtonPressed(_ sender: UIButton) {
        let destVC = ShowSpies()
        destVC.players = players?.filter("isSpy == true")
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    //MARK: - CONSTRAINTS
    private func activateConstraints() {
        view.addSubview(userSeeThisView)
        userSeeThisView.translatesAutoresizingMaskIntoConstraints = false
        userSeeThisView.pinToSafeArea(of: view)
        view.backgroundColor = Colors.backgroundColor
        
        setupPictureToShow()
        setupPlayerNameLabel()
        setupInstructions()
        setupNextButton()
    }
    
    
    private func setupPictureToShow() {
        userSeeThisView.addSubview(pictureToShow)
        pictureToShow.translatesAutoresizingMaskIntoConstraints = false
        pictureToShow.contentMode = .center
        
        NSLayoutConstraint.activate([
            pictureToShow.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            pictureToShow.widthAnchor.constraint(equalTo: pictureToShow.heightAnchor),
            pictureToShow.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pictureToShow.topAnchor.constraint(equalTo: userSeeThisView.topAnchor, constant: 50),
        ])
    }
    
    
    private func setupPlayerNameLabel() {
        userSeeThisView.addSubview(playerNameLabel)
        let userNameHeightConstraint = NSLayoutConstraint(item: playerNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: calculateLabelHeight(text: "Roman", font: labelFont, width: self.view.frame.width))
        playerNameLabel.addConstraint(userNameHeightConstraint)
        
        NSLayoutConstraint.activate([
            playerNameLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            playerNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            playerNameLabel.topAnchor.constraint(equalTo: pictureToShow.bottomAnchor, constant: 20)
        ])
    }
    
    
    private func setupInstructions() {
        userSeeThisView.addSubview(instructions)
        let heightConstraint = NSLayoutConstraint(item: instructions, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: calculateLabelHeight(text: hostText, font: labelFont, width: self.view.frame.width * 0.85))
        instructions.addConstraint(heightConstraint)
        
        NSLayoutConstraint.activate([
            instructions.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            instructions.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            instructions.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 10)
        ])
    }
    
    
    private func setupNextButton() {
        userSeeThisView.addSubview(nextButton)
        nextButton.set(backgroundColor: Colors.buttonColor, title: names.understand, cornerRadius: 10, borderWidth: 0)
        nextButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        nextButton.setShadow()
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.07),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: instructions.bottomAnchor, constant: 35)
        ])
    }
    
    //MARK: - Calculation
    
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
