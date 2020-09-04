//
//  ExplorePageController.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import CRRefresh
import SwiftyJSON

class ExplorePageController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .white, padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var exploreItems: [Any] = []
    
    let youtubeCellId = "youtubeCellId"
    let twitchCellId = "twitchCellId"
    let mixerCellId = "mixerCellId"
    let esportsLiveCellId = "esportsLiveCellId"
    let esportsCellId = "esportsCellId"
    let headerId = "headerId"
    let noCellId = "noCellId"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getExploreData()
    }
    
    private func setupViews() {
        
        let animator = CustomAnimator()
        animator.label.textColor = .white
        animator.activityIndicator.color = .white
        
        collectionView.cr.addHeadRefresh(animator: animator) {
            self.getExploreData()
        }
        
        collectionView.register(ExploreYoutubeCell.self, forCellWithReuseIdentifier: youtubeCellId)
        collectionView.register(ExploreTwitchCell.self, forCellWithReuseIdentifier: twitchCellId)
        collectionView.register(ExploreMixerCell.self, forCellWithReuseIdentifier: mixerCellId)
        collectionView.register(ExploreLiveEsportsCell.self, forCellWithReuseIdentifier: esportsLiveCellId)
        collectionView.register(ExploreEsportsCell.self, forCellWithReuseIdentifier: esportsCellId)
        collectionView.register(ExploreHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: noCellId)
                
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    @objc private func getExploreData() {
        exploreItems = []
        
        activityIndicator.startAnimating()
        
        let exploreRef = Database.database().reference().child("explore")
        let esportsRef = Database.database().reference().child("esports").child("matches")
                 
        exploreRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let exploreData = snapshot.value as? NSDictionary else { return }
            
            if let twitchData = exploreData["twitch"] as? NSDictionary {
                self.setTwitchStreamers(data: twitchData)
            }
            
            if let youtubeData = exploreData["youtube"] as? NSDictionary {
                self.setYoutubeVideos(data: youtubeData)
            }
        })
        
        esportsRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let esportsData = snapshot.value as? NSDictionary else { return }
            
            if let liveData = esportsData["live"] as? String {
                let liveJson = JSON(parseJSON: liveData)
                self.setEsportsData(json: liveJson, limit: nil)
            }
            
            if let pastData = esportsData["past"] as? String {
                let pastData = JSON(parseJSON: pastData)
                self.setEsportsData(json: pastData, limit: 10)
            }
        }
    }
    
    private func setTwitchStreamers(data: NSDictionary) {
        guard let streamerNames = data.allKeys as? [String] else { return }
        
        var count = 0
        for streamerName in streamerNames {
            count += 1
            guard let streamer = data[streamerName] as? NSDictionary else { return }
            guard let profilePicUrl = streamer["profilePicUrl"] as? String else { return }
            guard let thumbnailUrl = streamer["thumbnailUrl"] as? String else { return }
            guard let title = streamer["title"] as? String else { return }
            guard let username = streamer["username"] as? String else { return }
            guard let viewerCount = streamer["viewerCount"] as? Int else { return }
            
            let twitchStream = TwitchStream(streamerName: username, title: title, thumbnailURL: thumbnailUrl, viewerCount: viewerCount, streamerPicURL: profilePicUrl)
            exploreItems.append(twitchStream)
            
            if count == streamerNames.count {
                reloadExploreItems()
            }
        }
    }
    
    private func setYoutubeVideos(data: NSDictionary) {
        guard let videoIds = data.allKeys as? [String] else { return }
        
        var count = 0
        for videoId in videoIds {
            count += 1
            guard let video = data[videoId] as? NSDictionary else { return }
            guard let channelId = video["channelId"] as? String else { return }
            guard let channelImageUrl = video["channelImageUrl"] as? String else { return }
            guard let channelTitle = video["channelTitle"] as? String else { return }
            guard let publishedAt = video["publishedAt"] as? String else { return }
            guard let thumbnailUrl = video["thumbnailUrl"] as? String else { return }
            guard var title = video["title"] as? String else { return }
            guard let videoId = video["videoId"] as? String else { return }
            
            title = title.stringByDecodingHTMLEntities
            
            let youtubeVideo = YoutubeVideo(title: title, videoId: videoId, thumbnailURL: thumbnailUrl, publishedAt: publishedAt, channelTitle: channelTitle, channelId: channelId, viewCount: 0, duration: nil, channelImageURL: channelImageUrl)
            exploreItems.append(youtubeVideo)
            
            if count == videoIds.count {
                reloadExploreItems()
            }
        }
    }
    
    private func setEsportsData(json: JSON, limit: Int?) {
        EsportsService.parseMatchesJson(json: json) { (matches) in
            var matchesToSet: [EsportsMatch] = matches
            
            if let limit = limit {
                matchesToSet = Array(matches.prefix(limit))
            }
            if matches.count > 0 {
                self.exploreItems.append(contentsOf: matchesToSet)
                self.reloadExploreItems()
            }
        }
    }
    
    private func reloadExploreItems() {
        DispatchQueue.main.async {
            self.exploreItems.shuffle()
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.collectionView.cr.endHeaderRefresh()
        }
    }
}
