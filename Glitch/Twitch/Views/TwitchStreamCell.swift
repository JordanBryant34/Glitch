//
//  TwitchStreamCell.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TwitchStreamCell: UICollectionViewCell {
    
    let thumbnailImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitchGray()
        return imageView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchLightGray()
        return view
    }()
    
    let profilePicImageView: AsyncImageView = {
        let imageView = AsyncImageView()
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .twitchGrayTextColor()
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let liveLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .youtubeRed()
        label.text = "LIVE"
        label.font = label.font.withSize(17.5)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewerCountLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewerCountView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchGray()
        view.alpha = 0.9
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(thumbnailImageView)
        addSubview(bottomView)
        
        thumbnailImageView.addSubview(liveLabel)
        thumbnailImageView.addSubview(viewerCountView)
        thumbnailImageView.addSubview(viewerCountLabel)
        
        bottomView.addSubview(profilePicImageView)
        bottomView.addSubview(streamerNameLabel)
        bottomView.addSubview(titleLabel)
        
        bottomView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        thumbnailImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        liveLabel.leftAnchor.constraint(equalTo: thumbnailImageView.leftAnchor, constant: 10).isActive = true
        liveLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: 10).isActive = true
        liveLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        liveLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        viewerCountLabel.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -10).isActive = true
        viewerCountLabel.leftAnchor.constraint(equalTo: thumbnailImageView.leftAnchor, constant: 20).isActive = true
        
        viewerCountView.centerYAnchor.constraint(equalTo: viewerCountLabel.centerYAnchor).isActive = true
        viewerCountView.centerXAnchor.constraint(equalTo: viewerCountLabel.centerXAnchor).isActive = true
        viewerCountView.heightAnchor.constraint(equalTo: viewerCountLabel.heightAnchor, multiplier: 1.3).isActive = true
        viewerCountView.widthAnchor.constraint(equalTo: viewerCountLabel.widthAnchor, multiplier: 1.3).isActive = true
        
        profilePicImageView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        profilePicImageView.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 10).isActive = true
        profilePicImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profilePicImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        streamerNameLabel.leftAnchor.constraint(equalTo: profilePicImageView.rightAnchor, constant: 10).isActive = true
        streamerNameLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: streamerNameLabel.bottomAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: profilePicImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
