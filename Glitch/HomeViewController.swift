//
//  HomeViewController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/26/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AVKit
import WebKit

class HomeViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = label.font.withSize(25)
        label.textColor = .white
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
