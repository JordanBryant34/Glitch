//
//  TwitchStreamerOfflineCell.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/7/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TwitchStreamerOfflineCell: UICollectionViewCell {
    
    let profilePicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .twitchGray()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.twitchPurple().cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let streamerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.5)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let offlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Offline"
        label.textColor = .twitchGrayTextColor()
        label.font = label.font.withSize(17.5)
        label.textAlignment = .right
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .twitchGray()
        
        addSubview(profilePicImageView)
        addSubview(streamerNameLabel)
        addSubview(offlineLabel)
        
        profilePicImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profilePicImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profilePicImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profilePicImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        streamerNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        streamerNameLabel.leftAnchor.constraint(equalTo: profilePicImageView.rightAnchor, constant: 10).isActive = true
        
        offlineLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        offlineLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
