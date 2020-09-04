//
//  YoutubeFollowingController.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/28/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import NVActivityIndicatorView

class YoutubeFollowingController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12.5
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        return cv
    }()
    
    let noFollowsView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "youtubeBackground")
        view.label.text = "You don't follow any YouTubers"
        view.subLabel.text = "Search for channels to follow."
        view.subLabel.textColor = .youtubeLightGray()
        view.button.setTitle("Search", for: .normal)
        view.button.backgroundColor = .youtubeRed()
        view.isHidden = true
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .youtubeRed(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var selectedChannel: YoutubeChannel?
    var channelCount = 0
    var channelsRetrieved = 0
    
    lazy var functions = Functions.functions()
    
    var videos: [YoutubeVideo] = [] {
        didSet {
            if channelsRetrieved == channelCount && channelCount != 0 {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    if self.videos.count > 0 {
                        self.collectionView.isHidden = false
                        self.noFollowsView.isHidden = true
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    var allVideos: [YoutubeVideo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(YoutubeVideoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(YoutubeFollowsChannelsController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        noFollowsView.button.addTarget(self, action: #selector(presentSearchController), for: .touchUpInside)
        
        setupViews()
        getVideos()
    }
    
    private func getVideos() {
        guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
        let userRef = Database.database().reference().child("users").child(id).child("youtube").child("following")
        
        activityIndicator.startAnimating()
        
        userRef.observe(.value) { (snapshot) in
            guard let channels = snapshot.value as? NSDictionary else {
                self.noFollowsView.isHidden = false
                self.collectionView.isHidden = true
                self.activityIndicator.stopAnimating()
                return
            }
            self.channelCount = 0
            self.channelsRetrieved = 0
            self.videos = []
            self.allVideos = []
                        
            for channelData in channels {
                guard let channel = channelData.value as? NSDictionary else { return }
                guard let channelUploadsId = channel["channelUploadPlaylistId"] as? String else { return }
                guard let channelImageUrl = channel["channelImageUrl"] as? String else { return }
                
                self.channelCount += 1
                YoutubeService.getUploads(withPlaylistId: channelUploadsId, withChannelImageUrl: channelImageUrl) { (uploads) in
                    self.channelsRetrieved += 1
                    self.videos.append(contentsOf: uploads)
                    self.allVideos.append(contentsOf: uploads)
                    
                    self.sortVideos()
                }
            }
        }
    }
    
    private func sortVideos() {
        videos = videos.sorted(by: {
            $0.publishedAt.compare($1.publishedAt) == .orderedDescending
        })
        
        allVideos = allVideos.sorted(by: {
            $0.publishedAt.compare($1.publishedAt) == .orderedDescending
        })
    }
    
    func filterByChannel(channelId: String) {
        if allVideos.count == 0 { return }
        
        videos = allVideos.filter({$0.channelId == channelId })
    }
    
    private func setupViews() {
        view.addSubview(noFollowsView)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        noFollowsView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
}
