//
//  CustomSegmentedControl.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/28/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        setup()
    }
    
    func setup() {
        let backgroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
        
        setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        setDividerImage(backgroundImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
