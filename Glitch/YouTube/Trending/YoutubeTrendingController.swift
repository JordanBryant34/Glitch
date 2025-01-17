//
//  YoutubeTrendingController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/27/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Firebase

class YoutubeTrendingController: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12.5, left: 0, bottom: 20, right: 0)
        layout.minimumInteritemSpacing = 12.5
        layout.minimumLineSpacing = 12.5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    let noResultsView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "youtubeBackground")
        view.label.text = "No results"
        view.subLabel.text = "Search for different keywords and try again."
        view.subLabel.textColor = .youtubeLightGray()
        view.button.isHidden = true
        view.isHidden = true
        return view
    }()
    
    let cellId = "cellId"
    let headerId = "headerId"
    let adCellId = "adCellId"
    let apiKey = "AIzaSyAPDm4p1q4j1gyNa6ENxfKGICPvW1d7wnw"
    
    var keyboardIsVisible = false
    
    var videos: [Any] = []
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(YoutubeVideoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(YoutubeTrendingHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(LargeNativeAdCollectionViewCell.self, forCellWithReuseIdentifier: adCellId)
        
        setupViews()
        getTrendingVideos()
    }
    
    func setupViews() {
        view.backgroundColor = .clear
        
        view.addSubview(noResultsView)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        noResultsView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 70, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    func getTrendingVideos() {
        activityIndicator.startAnimating()
        videos = []
        
        let ref = Database.database().reference().child("youtube").child("trending")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let items = snapshot.value as? NSDictionary else { return }
            let videoIds = items.allKeys
            
            for videoId in videoIds {
                guard let video = items[videoId] as? NSDictionary else { return }
                guard let title = video["title"] as? String else { return }
                guard let id = video["id"] as? String else { return }
                guard let channelId = video["channelId"] as? String else { return }
                guard let channelImageUrl = video["channelImageUrl"] as? String else { return }
                guard let channelTitle = video["channelTitle"] as? String else { return }
                guard let publishedAt = video["publishedAt"] as? String else { return }
                guard let viewCount = video["viewCount"] as? String else { return }
                let thumbnailUrl = video["thumbnailUrl"] as? String ?? ""
            
                let youtubeVideo = YoutubeVideo(title: title, videoId: id, thumbnailURL: thumbnailUrl, publishedAt: publishedAt, channelTitle: channelTitle, channelId: channelId, viewCount: Int(viewCount), duration: nil, channelImageURL: channelImageUrl)
                
                self.videos.append(youtubeVideo)
            }
            
            self.reloadData()
        }
    }
    
    private func injectAds() {
        let nativeAds = delegate.nativeAds
        
        if nativeAds.count <= 0 { return }
        if videos.count <= 0 { return }
        
        videos.insert(GADUnifiedNativeAd(), at: 2)
        
        videos = videos.adding(GADUnifiedNativeAd(), afterEvery: 5)
    }
    
    private func reloadData() {
        injectAds()
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
            if self.videos.count == 0 {
                self.noResultsView.isHidden = false
            } else {
                self.noResultsView.isHidden = true
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        if let text = searchBar.text {
            activityIndicator.startAnimating()
            YoutubeService.searchYoutubeVideos(searchText: text) { (videos) in
                if videos.count == 0 {
                    self.videos = []
                    self.reloadData()
                }
                
                var count = 0
                for video in videos {
                    count += 1
                    YoutubeService.getChannelImage(withChannelId: video.channelId) { (imageUrl) in
                        video.channelImageURL = imageUrl
                    
                        if count == videos.count {
                            self.videos = videos
                            self.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        keyboardIsVisible = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        keyboardIsVisible = false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != self.collectionView {
            return false
        }else{
            return true
        }
    }
}
