//
//  ExploreHeader.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/16/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class ExploreHeader: UICollectionViewCell {
    
    let exploreLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore"
        label.font = .boldSystemFont(ofSize: 35)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(exploreLabel)
        
        exploreLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
