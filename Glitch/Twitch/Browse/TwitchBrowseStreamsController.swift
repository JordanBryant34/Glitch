//
//  TwitchBrowseStreamsController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import GoogleMobileAds
import Firebase

class TwitchBrowseStreamsController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 15
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.prefetchDataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        return cv
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitchPurple(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var topStreamsController: TwitchTopStreamsCell = {
        let controller = TwitchTopStreamsCell()
        return controller
    }()
    
    var game: TwitchGame?
    var streams: [Any] = []
    
    let cellId = "cellId"
    let adCellId = "adCellId"
    let headerId = "headerId"
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(TwitchStreamCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LargeNativeAdCollectionViewCell.self, forCellWithReuseIdentifier: adCellId)
        collectionView.register(TwitchStreamsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        setupViews()
        getStreams()
    }
    
    private func setupViews() {
        view.backgroundColor = .twitchGray()
        
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    private func getStreams() {
        guard let game = game else { dismiss(animated: true, completion: nil); return }
        
        activityIndicator.startAnimating()
        
        let parameters = [
            "first" : 100,
            "game_id": game.id,
            "language" : "en"
            ] as [String : Any]
        
        TwitchService.getStreams(parameters: parameters) { (streams) in
            if streams.count == 0 {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.streams = streams
                
                self.injectAds()
                self.reloadData()
                self.collectionView.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func injectAds() {
        let nativeAds = delegate.nativeAds
        
        if nativeAds.count <= 0 { return }
        if streams.count <= 0 { return }
        
        streams.insert(GADUnifiedNativeAd(), at: 2)
        
        streams = streams.adding(GADUnifiedNativeAd(), afterEvery: 5)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
