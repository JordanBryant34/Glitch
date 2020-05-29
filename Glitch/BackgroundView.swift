//
//  BackgroundView.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/29/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.5)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = .youtubeLightGray()
        label.sizeToFit()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(imageView)
        addSubview(label)
        addSubview(subLabel)
        addSubview(button)
        
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        
        subLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 15).isActive = true
        subLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
