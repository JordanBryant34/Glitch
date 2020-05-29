//
//  ExploreMixerCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class ExploreMixerCell: UICollectionViewCell {
    
    let profilePicImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.mixerLightBlue().cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playingLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = .twitchGrayTextColor()
        return label
    }()
    
    var channel: MixerChannel? = nil {
        didSet {
            if let channel = channel {
                setChannelInfo(channel: channel)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.mixerLightBlue().cgColor
        backgroundColor = .twitchLightGray()
        
        addSubview(profilePicImageView)
        addSubview(nameLabel)
        addSubview(liveLabel)
        addSubview(playingLabel)

        playingLabel.anchor(centerYAnchor, left: nameLabel.leftAnchor, bottom: nil, right: liveLabel.leftAnchor, topConstant: 2.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        profilePicImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profilePicImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profilePicImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profilePicImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2.5).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profilePicImageView.rightAnchor, constant: 10).isActive = true
        
        liveLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        liveLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        liveLabel.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        liveLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func setChannelInfo(channel: MixerChannel) {
        profilePicImageView.image = UIImage(named: "mixerNoCover")
        
        nameLabel.text = channel.username
        profilePicImageView.loadImageUsingUrlString(urlString: channel.profilePicUrl as NSString)
        playingLabel.text = "Playing \(channel.game)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
