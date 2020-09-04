//
//  EsportsFollowingCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/1/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class EsportsFollowingCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noTeamImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var team: EsportsTeam? = nil {
        didSet {
            setTeamInfo()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .twitchLightGray()
        
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameLabel.anchor(imageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 15, rightConstant: 5, widthConstant: 0, heightConstant: 0)
    }
    
    private func setTeamInfo() {
        if let team = self.team {
            nameLabel.text = team.name
            
            if team.picUrl == "" {
                imageView.image = UIImage(named: "noTeamImage")
            } else {
                if let teamImageUrl = URL(string: team.picUrl) {
                    if let image = HelperFunctions.getImageFromFile(pathComponent: "\(team.name).png") {
                        imageView.image = HelperFunctions.resizeImage(image: image, newSize: CGSize(width: 50, height: 50))
                    } else {
                        ImageService.getImage(withURL: teamImageUrl) { (image) in
                            if let image = image {
                                self.imageView.image = HelperFunctions.resizeImage(image: image, newSize: CGSize(width: 50, height: 50))
                                HelperFunctions.storePngToFile(image: image, pathComponent: "\(team.name).png", size: CGSize(width: 100, height: 100))
                            }
                        }
                    }
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
