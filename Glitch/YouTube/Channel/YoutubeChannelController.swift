//
//  YoutubeChannelController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/30/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class YoutubeChannelController: UIViewController {
    
    lazy var collectionView: UICollectionView = { [weak self] in
        let layout = StretchyHeaderLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 10, left: -10, bottom: 20, right: 0)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .youtubeRed(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var channel: YoutubeChannel?
    var videos: [YoutubeVideo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(ChannelHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(RelatedVideoCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
        getVideos()
    }
    
    private func setupViews() {
        view.backgroundColor = .youtubeGray()
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 275/2).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    private func getVideos() {
        activityIndicator.startAnimating()
        guard let channelId = channel?.id else { return }
        
        YoutubeService.getChannelVideos(withChannelId: channelId) { (videos) in
            self.videos = videos
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
}
