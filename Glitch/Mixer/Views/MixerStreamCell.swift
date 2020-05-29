//
//  MixerStreamCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/12/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class MixerStreamCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let profilePicImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let thumbnailImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .mixerGrayTextColor()
        view.alpha = 0.1
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let viewersLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = .mixerGrayTextColor()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = 7.5
        
        addSubview(separatorView)
        addSubview(thumbnailImageView)
        addSubview(profilePicImageView)
        addSubview(nameLabel)
        addSubview(titleLabel)
        addSubview(viewersLabel)
        
        separatorView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        thumbnailImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.height * (16/9), heightConstant: 0)
        profilePicImageView.anchor(nil, left: thumbnailImageView.rightAnchor, bottom: titleLabel.topAnchor, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        
        nameLabel.centerYAnchor.constraint(equalTo: profilePicImageView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profilePicImageView.rightAnchor, constant: 5).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 5).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
        viewersLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        viewersLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 5).isActive = true
        viewersLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        viewersLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
