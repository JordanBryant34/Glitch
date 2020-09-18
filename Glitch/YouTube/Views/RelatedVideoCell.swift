//
//  RelatedVideoCell.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/3/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class RelatedVideoCell: UICollectionViewCell {
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .youtubeDarkGray()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let channelNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .twitchGrayTextColor()
        label.font = label.font.withSize(13)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .twitchGrayTextColor()
        label.font = label.font.withSize(13)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(channelNameLabel)
        addSubview(viewCountLabel)
        
        thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: (frame.height * (16/9))).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.preferredMaxLayoutWidth = (frame.width - (frame.height * (16/9) + 20))
        
        channelNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        channelNameLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 10).isActive = true
        
        viewCountLabel.topAnchor.constraint(equalTo: channelNameLabel.bottomAnchor, constant: 5).isActive = true
        viewCountLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
