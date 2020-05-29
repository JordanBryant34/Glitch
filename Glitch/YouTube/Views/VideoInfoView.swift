//
//  VideoInfoView.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/30/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class VideoInfoView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(17)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeGray()
        return view
    }()
    
    let channelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let channelNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewAndTimeLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = label.font.withSize(13.5)
        label.textColor = .youtubeLightGray()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewInAppButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .youtubeRed()
        button.setTitle("Open in app", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(13.5)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeGray()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .youtubeBlack()
        
        titleLabel.preferredMaxLayoutWidth = frame.width * 0.9
        
        addSubview(channelImageView)
        addSubview(channelNameLabel)
        addSubview(separatorView)
        addSubview(titleLabel)
        addSubview(viewAndTimeLabel)
        addSubview(viewInAppButton)
        addSubview(bottomSeparatorView)
        
        channelImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        channelImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        channelImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        channelImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        channelNameLabel.centerYAnchor.constraint(equalTo: channelImageView.centerYAnchor).isActive = true
        channelNameLabel.leftAnchor.constraint(equalTo: channelImageView.rightAnchor, constant: 10).isActive = true
        channelNameLabel.heightAnchor.constraint(equalTo: channelImageView.heightAnchor, multiplier: 0.8).isActive = true
        channelNameLabel.rightAnchor.constraint(equalTo: viewInAppButton.leftAnchor, constant: -10).isActive = true
        
        separatorView.anchor(nil, left: leftAnchor, bottom: channelImageView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        viewAndTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        viewAndTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        viewInAppButton.centerYAnchor.constraint(equalTo: channelImageView.centerYAnchor).isActive = true
        viewInAppButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        viewInAppButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewInAppButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        bottomSeparatorView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
