//
//  Rules.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 25.04.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class Rules: UIViewController {
    private let names = StringFiles()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let generalLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 2/255, green: 31/255, blue: 59/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let discussionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 2/255, green: 31/255, blue: 59/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let discussionLabelTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 2/255, green: 31/255, blue: 59/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let voteLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(displayP3Red: 2/255, green: 31/255, blue: 59/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vote: UILabel = {
        let label = UILabel()
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
    
    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 254/255, green: 239/255, blue: 221/255, alpha: 1)
        setupRulesAndGradientView()
        rulesLabelSettings()
        setupScrollView()
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
        topLabel.text = names.rules.uppercased()
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
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: rulesAndGradientView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            
        ])
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    private func setupGeneralLabel() {
        let relativeFontConstant:CGFloat = 0.019  // dynamic font
        generalLabel.text = names.generalLabelText
        generalLabel.font = generalLabel.font.withSize(view.bounds.height * relativeFontConstant)
        contentView.addSubview(generalLabel)
        
        let height = calculateLabelHeight(text: generalLabel.text!, font: generalLabel.font)
        
        NSLayoutConstraint.activate([
            generalLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            generalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            generalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            generalLabel.bottomAnchor.constraint(equalTo: generalLabel.topAnchor, constant: height),
            generalLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
    }
    
    private func setupDiscussionLabelTitle() {
        let relativeFontConstant:CGFloat = 0.021  // dynamic font
        discussionLabelTitle.text = names.discussionTitle
        discussionLabelTitle.font = discussionLabelTitle.font.withSize(view.bounds.height * relativeFontConstant)
        contentView.addSubview(discussionLabelTitle)
        
        let height = calculateLabelHeight(text: discussionLabelTitle.text!, font: discussionLabelTitle.font)
        
        NSLayoutConstraint.activate([
            discussionLabelTitle.topAnchor.constraint(equalTo: generalLabel.bottomAnchor, constant: 10),
            discussionLabelTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            discussionLabelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            discussionLabelTitle.bottomAnchor.constraint(equalTo: discussionLabelTitle.topAnchor, constant: height),
            discussionLabelTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupDiscussionLabel() {
        let relativeFontConstant:CGFloat = 0.019  // dynamic font
        discussionLabel.text = names.discussion
        discussionLabel.font = discussionLabel.font.withSize(view.bounds.height * relativeFontConstant)
        contentView.addSubview(discussionLabel)
        
        let height = calculateLabelHeight(text: discussionLabel.text!, font: discussionLabel.font)
        
        NSLayoutConstraint.activate([
            discussionLabel.topAnchor.constraint(equalTo: discussionLabelTitle.bottomAnchor, constant: 10),
            discussionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            discussionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            discussionLabel.bottomAnchor.constraint(equalTo: discussionLabel.topAnchor, constant: height),
            discussionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupVoteLabel() {
        let relativeFontConstant:CGFloat = 0.021  // dynamic font
        voteLabel.text = names.votingTitle
        voteLabel.font = voteLabel.font.withSize(view.bounds.height * relativeFontConstant)
        contentView.addSubview(voteLabel)
        
        let height = calculateLabelHeight(text: voteLabel.text!, font: voteLabel.font)
        
        NSLayoutConstraint.activate([
            voteLabel.topAnchor.constraint(equalTo: discussionLabel.bottomAnchor, constant: 10),
            voteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            voteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            voteLabel.bottomAnchor.constraint(equalTo: voteLabel.topAnchor, constant: height),
            voteLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupVote() {
        let relativeFontConstant:CGFloat = 0.019  // dynamic font
        vote.text = names.votingText
        vote.font = vote.font.withSize(view.bounds.height * relativeFontConstant)
        contentView.addSubview(vote)
        
        let height = calculateLabelHeight(text: vote.text!, font: vote.font)
        
        NSLayoutConstraint.activate([
            vote.topAnchor.constraint(equalTo: voteLabel.bottomAnchor, constant: 10),
            vote.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            vote.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            vote.bottomAnchor.constraint(equalTo: vote.topAnchor, constant: height),
            vote.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupPlayButton() {
        let relativeFontConstant:CGFloat = 0.025  // dynamic font
        playButton.setTitle(names.start.uppercased(), for: .normal)
        playButton.titleLabel!.font =  playButton.titleLabel!.font.withSize(view.bounds.height * relativeFontConstant)
        playButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        contentView.addSubview(playButton)
        
        //set shadow
        playButton.layer.shadowColor = UIColor.black.cgColor
        playButton.layer.shadowOpacity = 0.5
        playButton.layer.shadowOffset = .zero
        playButton.layer.shadowRadius = 4
        
        playButton.layer.shouldRasterize = true
        playButton.layer.rasterizationScale = UIScreen.main.scale
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: vote.bottomAnchor, constant: 20),
            playButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            playButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
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
