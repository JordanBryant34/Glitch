//
//  YoutubeVideoCell.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/27/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class YoutubeVideoCell: UICollectionViewCell {
    
    let thumbnailImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        return imageView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeBlack()
        return view
    }()
    
    let channelImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = (80 * 0.7) / 2
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textColor = .white
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = .youtubeLightGray()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.sizeToFit() 
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(thumbnailImageView)
        addSubview(bottomView)
        
        bottomView.addSubview(channelImageView)
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(detailsLabel)
        
        bottomView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        thumbnailImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        channelImageView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        channelImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        channelImageView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.7).isActive = true
        channelImageView.widthAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.7).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: channelImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        detailsLabel.topAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: 2.5).isActive = true
        detailsLabel.leftAnchor.constraint(equalTo: channelImageView.rightAnchor, constant: 10).isActive = true
        detailsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
