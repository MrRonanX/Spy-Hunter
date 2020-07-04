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
    
    private let generalLabel = SHBodyLabel(textAlignment: .natural, fontSize: .body)
    private let discussionLabel = SHBodyLabel(textAlignment: .natural, fontSize: .body)
    private let discussionLabelTitle = SHBodyLabel(textAlignment: .left, fontSize: .headline)
    private let voteLabel = SHBodyLabel(textAlignment: .left, fontSize: .headline)
    private let vote = SHBodyLabel(textAlignment: .left, fontSize: .body)
    
    private var rulesAndGradientView = SHHeaderView()
    private var playButton: SHButton!
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundColor
        
        setupRulesAndGradientView()
        setupScrollView()
        setupGeneralLabel()
        setupDiscussionLabelTitle()
        setupDiscussionLabel()
        setupVoteLabel()
        setupVote()
        setupPlayButton()
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
    
    
    private func setupRulesAndGradientView() {
        let endOfNavBar = getEndpointOfNavBar()
        
        rulesAndGradientView = SHHeaderView(frame: CGRect(x: 0, y: endOfNavBar, width: self.view.frame.width, height: self.view.frame.height/11))
        view.addSubview(rulesAndGradientView)
        rulesAndGradientView.translatesAutoresizingMaskIntoConstraints = false
        rulesAndGradientView.label.text = names.rules.uppercased()
        rulesAndGradientView.label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        NSLayoutConstraint.activate([
            rulesAndGradientView.topAnchor.constraint(equalTo: view.topAnchor, constant: endOfNavBar),
            rulesAndGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            rulesAndGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            rulesAndGradientView.bottomAnchor.constraint(equalTo: rulesAndGradientView.topAnchor, constant: view.frame.height/11)
        ])
    }
    
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: rulesAndGradientView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            
        ])
        
        scrollView.addSubview(contentView)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 950)
        ])
    }
    
    private func setupGeneralLabel() {
        generalLabel.text = names.generalLabelText
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
        discussionLabelTitle.text = names.discussionTitle
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
        discussionLabel.text = names.discussion
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
        voteLabel.text = names.votingTitle
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
        vote.text = names.votingText
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
        playButton = SHButton(backgroundColor: Colors.buttonColor, title: names.start.uppercased())
        playButton.addTarget(self, action: #selector(playButtonPressed(_:)), for: .touchUpInside)
        
        contentView.addSubview(playButton)
        
        playButton.setShadow()
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: vote.bottomAnchor, constant: 20),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 200),
            playButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
    }
    
    @objc private func playButtonPressed(_ sender: UIButton) {
        let destVC = PlayersScreen()
        navigationController?.pushViewController(destVC, animated: true)
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
