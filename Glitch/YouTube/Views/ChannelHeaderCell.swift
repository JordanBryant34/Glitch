//
//  ChannelHeaderCell.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/31/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class ChannelHeaderCell: UICollectionViewCell {
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeDarkGray()
        return view
    }()
    
    let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .youtubeDarkGray()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let channelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderColor = UIColor.youtubeDarkGray().cgColor
        imageView.layer.borderWidth = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let channelNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        return label
    }()
    
    let subscriberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.textColor = .youtubeLightGray()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.textColor = .youtubeLightGray()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videosLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.textColor = .youtubeLightGray()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let leftSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeGray()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rightSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeGray()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bannerImageView)
        addSubview(bottomView)
        
        bottomView.addSubview(channelImageView)
        bottomView.addSubview(channelNameLabel)
        bottomView.addSubview(viewsLabel)
        bottomView.addSubview(subscriberLabel)
        bottomView.addSubview(videosLabel)
        bottomView.addSubview(leftSeparator)
        bottomView.addSubview(rightSeparator)
        
        bottomView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 150)
        bannerImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        channelImageView.centerYAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15).isActive = true
        channelImageView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        channelImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        channelImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        channelNameLabel.anchor(channelImageView.bottomAnchor, left: bottomView.leftAnchor, bottom: nil, right: bottomView.rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 5, rightConstant: 15, widthConstant: 0, heightConstant: 25)
        
        viewsLabel.centerXAnchor.constraint(equalTo: channelNameLabel.centerXAnchor).isActive = true
        viewsLabel.topAnchor.constraint(equalTo: channelNameLabel.bottomAnchor).isActive = true
        viewsLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        viewsLabel.widthAnchor.constraint(equalTo: channelNameLabel.widthAnchor, multiplier: 0.32).isActive = true
        
        subscriberLabel.rightAnchor.constraint(equalTo: viewsLabel.leftAnchor).isActive = true
        subscriberLabel.topAnchor.constraint(equalTo: channelNameLabel.bottomAnchor).isActive = true
        subscriberLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        subscriberLabel.widthAnchor.constraint(equalTo: channelNameLabel.widthAnchor, multiplier: 0.32).isActive = true
        
        videosLabel.leftAnchor.constraint(equalTo: viewsLabel.rightAnchor).isActive = true
        videosLabel.topAnchor.constraint(equalTo: channelNameLabel.bottomAnchor).isActive = true
        videosLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        videosLabel.widthAnchor.constraint(equalTo: channelNameLabel.widthAnchor, multiplier: 0.32).isActive = true
        
        leftSeparator.rightAnchor.constraint(equalTo: viewsLabel.leftAnchor).isActive = true
        leftSeparator.heightAnchor.constraint(equalTo: viewsLabel.heightAnchor, multiplier: 0.7).isActive = true
        leftSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        leftSeparator.centerYAnchor.constraint(equalTo: viewsLabel.centerYAnchor).isActive = true
        
        rightSeparator.leftAnchor.constraint(equalTo: viewsLabel.rightAnchor).isActive = true
        rightSeparator.heightAnchor.constraint(equalTo: viewsLabel.heightAnchor, multiplier: 0.7).isActive = true
        rightSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        rightSeparator.centerYAnchor.constraint(equalTo: viewsLabel.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
