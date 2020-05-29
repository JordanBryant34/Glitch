//
//  MixerGameCell.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/11/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class MixerGameCell: UICollectionViewCell {
    
    let imageView: AsyncImageView = {
        let imageView = AsyncImageView()
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(12)
        label.textColor = .mixerGrayTextColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mixerBlue()
                
        layer.masksToBounds = true
        layer.cornerRadius = 4
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(viewersLabel)
        
        imageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.width)
        
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        
        viewersLabel.anchor(nameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
