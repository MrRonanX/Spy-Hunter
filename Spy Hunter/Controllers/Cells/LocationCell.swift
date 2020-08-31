//
//  LocationCell.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 7/6/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

protocol LocationCellDelegate {
    func updateSectionName(section: Int, item: Int)
    func addMoreLocs(to section: Int)
}

class LocationCell: UITableViewCell {
    
    enum Section {
        case main
        case add
    }
    
    static let reuseID          = "reuseID"
    var locations: [CellData]   = []
    
    var collectionView  : UICollectionView!
    var dataSource      : UICollectionViewDiffableDataSource<Section, CellData>!
    var section         : Int!
    var delegate        : LocationCellDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
     func configure(frame: CGRect, layout: UICollectionViewFlowLayout) {
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = Colors.backgroundColor
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(CLLocationCell.self, forCellWithReuseIdentifier: CLLocationCell.reuseID)
        collectionView.isScrollEnabled = false
         // double check if I really need this
        configureDataSource()
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CellData>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, location) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CLLocationCell.reuseID, for: indexPath) as! CLLocationCell
            
            switch indexPath.section {
            case 0:
                 cell.set(location: location)
            case 1:
                cell.setAddButton()
            default:
                fatalError("Section does not exist")
            }
            return cell
        })
    }
    
    
    func setCell(purchased: Bool) {
        switch purchased {
        case true:
            self.isUserInteractionEnabled = true
        case false:
            self.isUserInteractionEnabled = false
        }
    }
    
    
    func updateData(on locations: [CellData], section: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellData>()
        let plus = [CellData(locationName: "+", isChosen: false)]
        if section < 5 {
            snapshot.appendSections([.main])
             snapshot.appendItems(locations)
        } else {
            snapshot.appendSections([.main, .add])
            snapshot.appendItems(locations, toSection: .main)
            snapshot.appendItems(plus, toSection: .add)
            
        }
       
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
}

extension LocationCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        
        switch indexPath.section {
        case 0:
            delegate.updateSectionName(section: section, item: indexPath.item)
        case 1:
            delegate.addMoreLocs(to: section)
        default:
            fatalError("Fatal error from Location Cell. Section number doesn't exist")
        }
        
    }
}
