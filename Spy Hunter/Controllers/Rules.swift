//
//  Rules.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class Rules: UIViewController {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Правила:"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let generalLabel: UILabel = {
        let label = UILabel()
        label.text = "Для потрібно як мінімум 3 гравця. Кожен гравець або знатиме локацію, або ж буде шпіоном. Задача гравців своїми запитання та відповідями не видати локацію, а задача шпіона не видати, що він шпіон. Після кола обговореня гравці голосують, хто, як вони вважають, шпіон. Якщо шпіон відгадує локацію - виграє він."
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 2/255, green: 31/255, blue: 59/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let discussionLabel: UILabel = {
        let label = UILabel()
        label.text = "Коло обговорення починає ведучий, задаючи питання про локацію наступному гравцю по годинниковій, або ж проти годинникової стрілки. Гравець який відповів на запитання продовжує питати в тому ж напрямку. Коли всі гравці в кругу відповіли і черга задавати питання вернулась до ведучого, він може задати питання будь якому гравцю. Після цього гравець, який відповів, задає питання гравцю на свій вибір. Не можна запитувати одного і того ж гравця підряд."
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 2/255, green: 31/255, blue: 59/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let discussionLabelTitle: UILabel = {
        let label = UILabel()
        label.text = "Коло обговорення:"
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 2/255, green: 31/255, blue: 59/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let voteLabel: UILabel = {
        let label = UILabel()
        label.text = "Голосування:"
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 2/255, green: 31/255, blue: 59/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vote: UILabel = {
        let label = UILabel()
        label.text = "Після кола обговорень гравці радяться, та вирішують хто шпіон. Рішення приймається більшістю. За цей час шпіон має шанс назвати локацію та виграти. Якщо шпіон називає локацію, проте помиляється - він програє."
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 2/255, green: 31/255, blue: 59/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var rulesAndGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var playButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 185/255, green: 43/255, blue: 39/255, alpha: 1)
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(playButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        setupRulesAndGradientView()
        rulesLabelSettings()
        setupGeneralLabel()
        setupDiscussionLabelTitle()
        setupDiscussionLabel()
        setupVoteLabel()
        setupVote()
        setupPlayButton()
        
        
        
        // Do any additional setup after loading the view.
    }
    
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
    
    
    private func setupRulesAndGradientView() {
        let height = getDeviceHeight()
        
        //view settings
        rulesAndGradientView.frame = CGRect(x: 0, y: height, width: self.view.frame.width, height: self.view.frame.height/11)
        view.insertSubview(rulesAndGradientView, at: 0)
        
        NSLayoutConstraint.activate([
            rulesAndGradientView.topAnchor.constraint(equalTo: view.topAnchor, constant: height),
            rulesAndGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            rulesAndGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            
            rulesAndGradientView.bottomAnchor.constraint(equalTo: rulesAndGradientView.topAnchor, constant: view.frame.height/11)
        ])
        
        
        //Gradient Settings
        let labelGradient = CAGradientLayer()
        labelGradient.frame = rulesAndGradientView.bounds
        labelGradient.colors = [UIColor(displayP3Red: 21/255, green: 101/255, blue: 192/255, alpha: 1), UIColor(displayP3Red: 111/255, green: 171/255, blue: 239/255, alpha: 1)].map {$0.cgColor}
        rulesAndGradientView.layer.insertSublayer(labelGradient, at: 0)
        
    }
    
    private func rulesLabelSettings() {
        
        //Label settings
        
        let relativeFontConstant:CGFloat = 0.03  // dynamic font
        
        topLabel.bounds = rulesAndGradientView.bounds
        topLabel.font = topLabel.font.withSize(view.bounds.height * relativeFontConstant)
        rulesAndGradientView.addSubview(topLabel)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: rulesAndGradientView.topAnchor, constant: 0),
            topLabel.bottomAnchor.constraint(equalTo: rulesAndGradientView.bottomAnchor, constant: 0),
            topLabel.trailingAnchor.constraint(equalTo: rulesAndGradientView.trailingAnchor, constant: 0),
            topLabel.leadingAnchor.constraint(equalTo: rulesAndGradientView.leadingAnchor, constant: 0),
            topLabel.centerXAnchor.constraint(equalTo: rulesAndGradientView.centerXAnchor, constant: 0),
            topLabel.centerYAnchor.constraint(equalTo: rulesAndGradientView.centerYAnchor, constant: 0),
        ])
    }
    
    private func setupGeneralLabel() {
        let relativeFontConstant:CGFloat = 0.019  // dynamic font
        generalLabel.font = generalLabel.font.withSize(view.bounds.height * relativeFontConstant)
        view.addSubview(generalLabel)
        
        let height = calculateLabelHeight(text: generalLabel.text!, font: generalLabel.font)
        
        NSLayoutConstraint.activate([
            generalLabel.topAnchor.constraint(equalTo: rulesAndGradientView.bottomAnchor, constant: 10),
            generalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalLabel.bottomAnchor.constraint(equalTo: generalLabel.topAnchor, constant: height),
            generalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    private func setupDiscussionLabelTitle() {
        let relativeFontConstant:CGFloat = 0.021  // dynamic font
        discussionLabelTitle.font = discussionLabelTitle.font.withSize(view.bounds.height * relativeFontConstant)
        view.addSubview(discussionLabelTitle)
        
        let height = calculateLabelHeight(text: discussionLabelTitle.text!, font: discussionLabelTitle.font)
        
        NSLayoutConstraint.activate([
            discussionLabelTitle.topAnchor.constraint(equalTo: generalLabel.bottomAnchor, constant: 10),
            discussionLabelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            discussionLabelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            discussionLabelTitle.bottomAnchor.constraint(equalTo: discussionLabelTitle.topAnchor, constant: height),
            discussionLabelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupDiscussionLabel() {
        let relativeFontConstant:CGFloat = 0.019  // dynamic font
        discussionLabel.font = discussionLabel.font.withSize(view.bounds.height * relativeFontConstant)
        view.addSubview(discussionLabel)
        
        let height = calculateLabelHeight(text: discussionLabel.text!, font: discussionLabel.font)
        
        NSLayoutConstraint.activate([
            discussionLabel.topAnchor.constraint(equalTo: discussionLabelTitle.bottomAnchor, constant: 10),
            discussionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            discussionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            discussionLabel.bottomAnchor.constraint(equalTo: discussionLabel.topAnchor, constant: height),
            discussionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupVoteLabel() {
        let relativeFontConstant:CGFloat = 0.021  // dynamic font
        voteLabel.font = voteLabel.font.withSize(view.bounds.height * relativeFontConstant)
        view.addSubview(voteLabel)
        
        let height = calculateLabelHeight(text: voteLabel.text!, font: voteLabel.font)
        
        NSLayoutConstraint.activate([
            voteLabel.topAnchor.constraint(equalTo: discussionLabel.bottomAnchor, constant: 10),
            voteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            voteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            voteLabel.bottomAnchor.constraint(equalTo: voteLabel.topAnchor, constant: height),
            voteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupVote() {
        let relativeFontConstant:CGFloat = 0.019  // dynamic font
        vote.font = vote.font.withSize(view.bounds.height * relativeFontConstant)
        view.addSubview(vote)
        
        let height = calculateLabelHeight(text: vote.text!, font: vote.font)
        
        NSLayoutConstraint.activate([
            vote.topAnchor.constraint(equalTo: voteLabel.bottomAnchor, constant: 10),
            vote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vote.bottomAnchor.constraint(equalTo: vote.topAnchor, constant: height),
            vote.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupPlayButton() {
        let relativeFontConstant:CGFloat = 0.025  // dynamic font
        playButton.setTitle("ПОЧАТИ", for: .normal)
        playButton.titleLabel!.font =  playButton.titleLabel!.font.withSize(view.bounds.height * relativeFontConstant)
        playButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        view.addSubview(playButton)
        
        //set shadow
        playButton.layer.shadowColor = UIColor.black.cgColor
        playButton.layer.shadowOpacity = 0.5
        playButton.layer.shadowOffset = .zero
        playButton.layer.shadowRadius = 4
        
        playButton.layer.shouldRasterize = true
        playButton.layer.rasterizationScale = UIScreen.main.scale
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: vote.bottomAnchor, constant: 20),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    @objc private func playButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "RulesToPlayerScreen", sender: self)
    }
    
    
    
    
    private func calculateLabelHeight(text: String, font: UIFont) -> CGFloat {
        var currentHeight: CGFloat!
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.9, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        currentHeight = label.frame.height
        
        return currentHeight
    }
    
}
