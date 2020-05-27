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
     var delegate: FinalCellDelegate?
    var cellTag : Int!  {
        didSet {
            switch cellTag {
            case 0:
                label.text = "Час обговорення в хвилинах"
                numberLabel.text = "5"
            case 1:
                label.text = "Кількіть шпіонів"
                numberLabel.text = "1"
            default:
                label.text = "Як дивно, цього не мало відображатись"
            }
        }
    }
        let label:UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        let numberLabel:UILabel = {
            let label = UILabel()
            label.text = "0"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()


        let addButton:UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle("+", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 0
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()

        let subtractButton:UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle("-", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 0
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
            super.awakeFromNib()

            
        }

        func setConstraints(){

            //Autolayout-Constraints
            NSLayoutConstraint.activate([

                //Label Constraints
                self.label.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                self.label.heightAnchor.constraint(equalToConstant: self.bounds.height),
                self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.label.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),

                //addSubtractView Constraints
                self.addSubtractView.leadingAnchor.constraint(equalTo: self.label.trailingAnchor, constant: 10),
                self.addSubtractView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5),
                self.addSubtractView.heightAnchor.constraint(equalToConstant: self.bounds.height),
                self.addSubtractView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

                //subtractButton Constraints
                self.subtractButton.leadingAnchor.constraint(equalTo: self.addSubtractView.leadingAnchor, constant: 10),
                self.subtractButton.heightAnchor.constraint(equalToConstant: self.bounds.height),
                self.subtractButton.topAnchor.constraint(equalTo: self.addSubtractView.topAnchor, constant: 1.5),

                //numberLabel Constraints
                self.numberLabel.leadingAnchor.constraint(equalTo: subtractButton.trailingAnchor, constant: 10),
                self.numberLabel.heightAnchor.constraint(equalToConstant: self.bounds.height),
                self.numberLabel.widthAnchor.constraint(equalToConstant: 30),
                self.numberLabel.topAnchor.constraint(equalTo: self.addSubtractView.topAnchor, constant: 1.5),

                //addButton Constraints
                self.addButton.leadingAnchor.constraint(equalTo: self.numberLabel.trailingAnchor, constant: 10),
                self.addButton.heightAnchor.constraint(equalToConstant: self.bounds.height),
                self.addButton.topAnchor.constraint(equalTo: self.addSubtractView.topAnchor, constant: 1.5)
                ])
        }
    }
