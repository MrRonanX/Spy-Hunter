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
    
    private let names           = Strings()
    static let reuseIdentifier  = "FinalCell"
    var delegate                : FinalCellDelegate?
    
    var cellTag: Int!  {
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
    
    let label           = SHPageLabel(textColor: .black, textAlignment: .left)
    let numberLabel     = SHPageLabel(textColor: .black, textAlignment: .center)

    let addButton       = SHCircleButton(title: "+")
    let subtractButton  = SHCircleButton(title: "-")
    
    let addSubtractView = UIView()
    

    override init(style: UITableViewCell.CellStyle ,reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let relativeFontConstant:CGFloat = 0.020
        
        label.font          = label.font.withSize(UIScreen.main.bounds.height * relativeFontConstant)
        numberLabel.font    = numberLabel.font.withSize(UIScreen.main.bounds.height * relativeFontConstant)
        
        addSubview(label)
        addSubview(addSubtractView)
        addSubtractView.addSubviews(subtractButton, numberLabel, addButton)
        addSubtractView.translatesAutoresizingMaskIntoConstraints = false
    
        addButton.addTarget(self, action: #selector(addClick(_:)), for: .touchUpInside)
        subtractButton.addTarget(self, action: #selector(subtractClick(_:)), for: .touchUpInside)
        
        setConstraints()
        makeCircleButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func subtractClick(_ sender: UIButton) {
        delegate?.subtactButtonPressed(sender: sender, label: numberLabel)
    }
    
    
    @objc func addClick(_ sender: UIButton) {
        delegate?.addButtonPressed(sender: sender, label: numberLabel)
    }
    
    
    private func setConstraints(){
        let buttonSize: CGFloat = self.frame.width * 0.11

        NSLayoutConstraint.activate([
            
            //Label Constraints
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.55),
            
            //addSubtractView Constraints
            addSubtractView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            addSubtractView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addSubtractView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addSubtractView.heightAnchor.constraint(equalToConstant: buttonSize),
            
            //addButton Constraints
            addButton.trailingAnchor.constraint(equalTo: addSubtractView.trailingAnchor, constant: -10),
            addButton.widthAnchor.constraint(equalToConstant: buttonSize),
            addButton.centerYAnchor.constraint(equalTo: addSubtractView.centerYAnchor),
            
            //numberLabel Constraints
            numberLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),
            numberLabel.heightAnchor.constraint(equalToConstant: self.bounds.height),
            numberLabel.widthAnchor.constraint(equalToConstant: 30),
            numberLabel.centerYAnchor.constraint(equalTo: addSubtractView.centerYAnchor),
            
            //subtractButton Constraints
            subtractButton.trailingAnchor.constraint(equalTo: numberLabel.leadingAnchor, constant: -10),
            subtractButton.widthAnchor.constraint(equalToConstant: buttonSize),
            subtractButton.heightAnchor.constraint(equalToConstant: buttonSize),
            subtractButton.centerYAnchor.constraint(equalTo: addSubtractView.centerYAnchor)
        ])
    }
    
    
    private func makeCircleButtons() {
        let buttonSize: CGFloat                     = self.frame.width * 0.11
        
        subtractButton.layer.cornerRadius           = buttonSize / 2
        subtractButton.titleLabel?.textAlignment    = .center
        
        addButton.layer.cornerRadius                = buttonSize / 2
        addButton.titleLabel?.textAlignment         = .center
        
        numberLabel.textAlignment                   = .center
    }
}
