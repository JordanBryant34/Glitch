//
//  YoutubeSearchCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 5/3/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class YoutubeSearchCell: UITableViewCell {
    
    let channelImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 25
        imageView.layer.borderColor = UIColor.youtubeRed().cgColor
        imageView.backgroundColor = .youtubeGray()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let channelNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeGray()
        return view
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3
        button.backgroundColor = .youtubeRed()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        backgroundColor = .clear
        
        addSubview(channelImageView)
        addSubview(channelNameLabel)
        addSubview(separatorView)
        addSubview(followButton)
        
        channelImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        channelImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        channelImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        channelImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        channelNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        channelNameLabel.leftAnchor.constraint(equalTo: channelImageView.rightAnchor, constant: 10).isActive = true
        channelNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        channelNameLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -15).isActive = true
        
        separatorView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
