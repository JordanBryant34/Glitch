//
//  TwitterThreadFooter.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TwitterThreadFooter: UITableViewHeaderFooterView, UITextViewDelegate {
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.twitterGrayText().withAlphaComponent(0.2)
        return view
    }()
    
    let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.twitterGrayText().withAlphaComponent(0.2)
        return view
    }()
    
    let viewInAppButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.setTitle("View tweet on Twitter", for: .normal)
        button.backgroundColor = .twitterLightBlue()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        tintColor = .twitterMediumBlue()
        
        addSubview(separatorView)
        addSubview(viewInAppButton)
        addSubview(separatorView2)
        
        separatorView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        separatorView2.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        viewInAppButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        viewInAppButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        viewInAppButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
        viewInAppButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
