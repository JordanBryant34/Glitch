//
//  YoutubeSubscriptionCell.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/29/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class YoutubeSubscriptionCell: UITableViewCell {
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let channelNameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = label.font.withSize(17.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let channelDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .youtubeLightGray()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let newItemIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeRed()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .youtubeDarkGray()
        selectionStyle = .none
        
        thumbnailImageView.layer.cornerRadius = frame.height / 2
        
        addSubview(thumbnailImageView)
        addSubview(channelNameLabel)
        addSubview(channelDescriptionLabel)
        addSubview(newItemIndicator)
        
        thumbnailImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
        
        channelNameLabel.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        channelNameLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 15).isActive = true
        
        channelDescriptionLabel.anchor(channelNameLabel.bottomAnchor, left: thumbnailImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 3, leftConstant: 15, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 0)
        
        newItemIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newItemIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        newItemIndicator.widthAnchor.constraint(equalToConstant: 10).isActive = true
        newItemIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
