//
//  TwitchStreamsHeader.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/4/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TwitchStreamsHeader: UICollectionViewCell {
        
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22.5)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.5)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.textColor = UIColor(r: 140, g: 140, b: 140)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let backgroundImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.alpha = 0.8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.0
        return imageView
    }()
    
    let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .twitchLightGray()
        
        addSubview(backgroundImageView)
        addSubview(gradientView)
        addSubview(nameLabel)
        addSubview(viewersLabel)
        
        backgroundImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        gradientView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        nameLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewersLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        viewersLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 25).isActive = true
    }
    
    override func layoutSubviews() {
        gradientView.setFadeGradientBackground(colorOne: .clear, colorTwo: UIColor.twitchGray().withAlphaComponent(0.8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
