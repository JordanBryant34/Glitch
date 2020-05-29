//
//  MixerBrowseController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/10/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MixerBrowseController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = StretchyHeaderLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        cv.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 20, right: 15)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        return cv
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .mixerLightBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let cellId = "cellId"
    let topStreamsCellId = "topStreamsCellId"
    
    var games: [MixerGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MixerGameCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MixerTopStreamsCell.self, forCellWithReuseIdentifier: topStreamsCellId)
                
        setupViews()
        getGames()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    private func getGames() {
        activityIndicator.startAnimating()
        MixerService.getTopGames { (games) in
            if games.count != 0 {
                self.games = games
                self.reloadData()
                self.collectionView.isHidden = false
            }
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
}
