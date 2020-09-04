//
//  TeamSearchCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/30/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TeamSearchCell: UITableViewCell {
    
    let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let teamNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.twitchGrayTextColor(), for: .disabled)
        button.backgroundColor = .esportsBlue()
        button.setTitle("Follow", for: .normal)
        button.setTitle("Following", for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17.5)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 63, g: 63, b: 67)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(gameImageView)
        addSubview(teamNameLabel)
        addSubview(followButton)
        addSubview(separatorView)
        
        gameImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gameImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        gameImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        gameImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        teamNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        teamNameLabel.leftAnchor.constraint(equalTo: gameImageView.rightAnchor, constant: 10).isActive = true
        teamNameLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        teamNameLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -10).isActive = true
        
        followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        separatorView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
