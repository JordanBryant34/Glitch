//
//  MixerFollowCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/16/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class MixerFollowCell: UICollectionViewCell {
    
    let profilePicImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.mixerLightBlue().cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .mixerGrayTextColor()
        view.alpha = 0.1
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let liveLabel: UILabel = {
        let label = UILabel()
        label.text = "LIVE"
        label.backgroundColor = .mixerLightBlue()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let offlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Offline"
        label.textColor = .white
        label.backgroundColor = .mixerBlue()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playingLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textColor = .mixerGrayTextColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(separatorView)
        addSubview(profilePicImageView)
        addSubview(nameLabel)
        addSubview(liveLabel)
        addSubview(offlineLabel)
        addSubview(playingLabel)
        
        separatorView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        playingLabel.anchor(nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: separatorView.topAnchor, right: nil, topConstant: -5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width * 0.7, heightConstant: 0)
        
        profilePicImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profilePicImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profilePicImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profilePicImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profilePicImageView.rightAnchor, constant: 10).isActive = true
        
        liveLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        liveLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        liveLabel.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        liveLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        offlineLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        offlineLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        offlineLabel.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        offlineLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
