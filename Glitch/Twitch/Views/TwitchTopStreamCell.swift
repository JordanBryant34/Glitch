//
//  TwitchTopStreamCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/17/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TwitchTopStreamCell: UICollectionViewCell {
    
    let profilePicImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.twitchPurple().cgColor
        imageView.backgroundColor = .twitchGray()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let liveLabel: UILabel = {
        let label = UILabel()
        label.text = "LIVE"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchPurple()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = 5
        layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1
        backgroundColor = .twitchLightGray()
        
        addSubview(profilePicImageView)
        addSubview(nameLabel)
        addSubview(labelBackgroundView)
        addSubview(liveLabel)
        
        profilePicImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        profilePicImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profilePicImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profilePicImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: profilePicImageView.bottomAnchor, constant: 7.5).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        labelBackgroundView.centerXAnchor.constraint(equalTo: liveLabel.centerXAnchor).isActive = true
        labelBackgroundView.centerYAnchor.constraint(equalTo: liveLabel.centerYAnchor, constant: 1).isActive = true
        labelBackgroundView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        labelBackgroundView.widthAnchor.constraint(equalTo: liveLabel.widthAnchor, constant: 15).isActive = true
        
        liveLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        liveLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
