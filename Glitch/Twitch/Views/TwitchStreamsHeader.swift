//
//  TwitchStreamsHeader.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/4/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TwitchStreamsHeader: UICollectionViewCell {
    
    let boxArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .twitchGray()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.textColor = .twitchGrayTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .twitchGray()
        
        addSubview(boxArtImageView)
        addSubview(nameLabel)
        addSubview(viewersLabel)
        
        boxArtImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        boxArtImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        boxArtImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        boxArtImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: boxArtImageView.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: boxArtImageView.rightAnchor, constant: 15).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        viewersLabel.leftAnchor.constraint(equalTo: boxArtImageView.rightAnchor, constant: 15).isActive = true
        viewersLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
