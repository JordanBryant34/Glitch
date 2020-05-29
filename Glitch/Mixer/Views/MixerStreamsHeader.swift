//
//  MixerStreamsHeader.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/11/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class MixerStreamsHeader: UICollectionViewCell {
    
    let backgroundImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let coverImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.5)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.textColor = .mixerGrayTextColor()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        nameLabel.preferredMaxLayoutWidth = frame.width * 0.6
        
        addSubview(backgroundImageView)
        addSubview(coverImageView)
        addSubview(nameLabel)
        addSubview(viewersLabel)
        
        backgroundImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        coverImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        coverImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -25).isActive = true
        coverImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        coverImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 10).isActive = true
        
        viewersLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        viewersLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let mask = CAGradientLayer()
        mask.startPoint = CGPoint(x: 0.5, y: 1.0)
        mask.endPoint = CGPoint(x: 0.5, y: -0.2)
        mask.colors = [UIColor.mixerDarkBlue().withAlphaComponent(0.0).cgColor, UIColor.mixerDarkBlue().withAlphaComponent(1.0).cgColor]
        mask.locations = [0.0, 1.0]
        mask.frame = backgroundImageView.bounds
        backgroundImageView.layer.mask = mask
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
