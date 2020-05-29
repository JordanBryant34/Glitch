//
//  YoutubeChannelCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 5/3/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class YoutubeChannelCell: UICollectionViewCell {
    
    let channelImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .youtubeGray()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.youtubeRed().cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeGray()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(channelImageView)
        addSubview(nameLabel)
                
        channelImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        channelImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        channelImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        channelImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: channelImageView.bottomAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        selectedBackgroundView = selectedView
        selectedBackgroundView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
