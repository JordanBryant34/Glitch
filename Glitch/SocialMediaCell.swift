//
//  SocialMediaCell.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/25/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class SocialMediaCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "testTabBarImage")
        return imageView
    }()
    
    let selectedView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        imageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true

        selectedBackgroundView = selectedView
        selectedBackgroundView?.frame = CGRect(x: 0, y: self.frame.maxY - 6, width: frame.width, height: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

