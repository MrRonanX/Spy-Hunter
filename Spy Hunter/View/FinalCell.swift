//
//  FinalCellTableViewCell.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 18.05.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

protocol FinalCellDelegate {
    func addButtonPressed(sender: UIButton, label: UILabel)
    func subtactButtonPressed(sender: UIButton, label: UILabel)
}

class FinalCell: UITableViewCell {
    
    private let names = StringFiles()
    
    var delegate: FinalCellDelegate?
    var cellTag : Int!  {
        didSet {
            switch cellTag {
            case 0:
                label.text = names.discussionTime
                numberLabel.text = "5"
            case 1:
                label.text = names.numberOfSpies
                numberLabel.text = "1"
            default:
                label.text = "Як дивно, цього не мало відображатись"
            }
        }
    }
    let label:UILabel = {
        let label = UILabel()
        
        label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberLabel:UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        
        label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let addButton:UIButton = {
        let width = UIScreen.main.bounds.width * 0.04
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: width))
        button.backgroundColor = UIColor(displayP3Red: 57/255, green: 47/255, blue: 90/255, alpha: 1)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let subtractButton:UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(displayP3Red: 57/255, green: 47/255, blue: 90/255, alpha: 1)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addSubtractView = UIView()
    
    @objc func subtractClick(_ sender: UIButton) {
        delegate?.subtactButtonPressed(sender: sender, label: numberLabel)
    }
    
    @objc func addClick(_ sender: UIButton) {
        delegate?.addButtonPressed(sender: sender, label: numberLabel)
    }
    static let reuseIdentifier: String = "FinalCell"
    
    override init(style: UITableViewCell.CellStyle ,reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let relativeFontConstant:CGFloat = 0.02
        label.font = label.font.withSize(UIScreen.main.bounds.height * relativeFontConstant)
        numberLabel.font = label.font.withSize(UIScreen.main.bounds.height * relativeFontConstant)
        
        addSubview(label)
        self.addSubtractView.addSubview(subtractButton)
        self.addSubtractView.addSubview(numberLabel)
        self.addSubtractView.addSubview(addButton)
        addSubview(self.addSubtractView)
        
        self.addSubtractView.translatesAutoresizingMaskIntoConstraints = false
        
        //adding actions to add & subtract buttons...
        self.addButton.addTarget(self, action: #selector(addClick(_:)), for: .touchUpInside)
        self.subtractButton.addTarget(self, action: #selector(subtractClick(_:)), for: .touchUpInside)
        
        self.setConstraints()
        self.makeCircleButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func setConstraints(){
        let buttonSize: CGFloat = self.frame.width * 0.11
        //Autolayout-Constraints
        NSLayoutConstraint.activate([
            
            //Label Constraints
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.label.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.55),
            
            //addSubtractView Constraints
            self.addSubtractView.leadingAnchor.constraint(equalTo: self.label.trailingAnchor, constant: 10),
            self.addSubtractView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.addSubtractView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            //subtractButton Constraints
            self.subtractButton.leadingAnchor.constraint(equalTo: self.addSubtractView.leadingAnchor, constant: 10),
            self.subtractButton.widthAnchor.constraint(equalToConstant: buttonSize),
            self.subtractButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.subtractButton.centerYAnchor.constraint(equalTo: addSubtractView.centerYAnchor),
            
            //numberLabel Constraints
            self.numberLabel.leadingAnchor.constraint(equalTo: subtractButton.trailingAnchor, constant: 10),
            self.numberLabel.heightAnchor.constraint(equalToConstant: self.bounds.height),
            self.numberLabel.widthAnchor.constraint(equalToConstant: 30),
            self.numberLabel.centerYAnchor.constraint(equalTo: addSubtractView.centerYAnchor),
            
            //addButton Constraints
            self.addButton.leadingAnchor.constraint(equalTo: self.numberLabel.trailingAnchor, constant: 10),
            self.addButton.widthAnchor.constraint(equalToConstant: buttonSize),
            self.addSubtractView.heightAnchor.constraint(equalToConstant: buttonSize),
            self.addButton.centerYAnchor.constraint(equalTo: addSubtractView.centerYAnchor)
        ])
    }
    
    func makeCircleButtons() {
        let buttonSize: CGFloat = self.frame.width * 0.11
        subtractButton.layer.cornerRadius = buttonSize / 2
        subtractButton.titleLabel?.textAlignment = .center
        addButton.layer.cornerRadius = buttonSize / 2
        addButton.titleLabel?.textAlignment = .center
        numberLabel.textAlignment = .center
    }
}
