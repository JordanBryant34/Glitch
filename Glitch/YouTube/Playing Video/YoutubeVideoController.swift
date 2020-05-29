//
//  YoutubeVideoController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/26/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AVKit
import youtube_ios_player_helper
import NVActivityIndicatorView
import GoogleMobileAds

class YoutubeVideoController: UIViewController, YTPlayerViewDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .youtubeBlack()
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let videoPlayer: YTPlayerView = {
        let player = YTPlayerView()
        player.isHidden = true
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .youtubeRed(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let recommendedActivityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .youtubeRed(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var infoView: VideoInfoView = {
        let view = VideoInfoView(frame: self.view.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let adsAlertView: AdsAlertView = {
        let view = AdsAlertView()
        view.alertView.backgroundColor = .youtubeDarkGray()
        view.alertView.layer.borderColor = UIColor.youtubeRed().cgColor
        view.imageView.contentMode = .scaleToFill
        view.imageView.image = UIImage(named: "youtubeLogoLarge")
        view.imageView.contentMode = .scaleAspectFit
        view.titleLabel.text = "Sorry for the interruption"
        view.detailsLabel.text = "Watch a short ad in order to view this video?"
        view.detailsLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        view.confirmButton.setTitle("Watch ad", for: .normal)
        view.cancelButton.setTitle("No thanks", for: .normal)
        view.confirmButton.backgroundColor = .youtubeRed()
        view.cancelButton.backgroundColor = .youtubeRed()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var video: YoutubeVideo?
    var relatedVideos: [YoutubeVideo] = []
    var rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()
    var nativeAdLoader: GADAdLoader!
    var nativeAd: GADUnifiedNativeAd?
    var contentCount = 0
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    private let playerVars: [String : Any] =  [ "playsinline":"1",
                                                "autoplay":"1",
                                                "origin":"https://www.youtube.com",
                                                "enablejsapi":"1",
                                                "iv_load_policy":"3",
                                                "showinfo":"1" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(RelatedVideoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(NativeAdCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        infoView.viewInAppButton.addTarget(self, action: #selector(openYoutube), for: .touchUpInside)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler))
        view.addGestureRecognizer(pan)
        
        adsAlertView.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        adsAlertView.confirmButton.addTarget(self, action: #selector(watchAdPressed), for: .touchUpInside)
        
        contentCount = UserDefaults.standard.integer(forKey: "contentWatchedCount")
        
        setupAds()
        setupViews()
        getRelatedVideos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupVideo()
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        view.addSubview(infoView)
        view.addSubview(statusBarView)
        view.addSubview(blackView)
        view.addSubview(collectionView)
        view.addSubview(adsAlertView)
        
        collectionView.addSubview(recommendedActivityIndicator)
        
        blackView.addSubview(activityIndicator)
        blackView.addSubview(videoPlayer)
                
        statusBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UIApplication.shared.windows[0].safeAreaInsets.top)
        adsAlertView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        blackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blackView.topAnchor.constraint(equalTo: statusBarView.bottomAnchor).isActive = true
        blackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blackView.heightAnchor.constraint(equalToConstant: view.frame.width / (16/9)).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: blackView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: blackView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: blackView.widthAnchor, multiplier: 0.1).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: blackView.widthAnchor, multiplier: 0.1).isActive = true
        
        recommendedActivityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        recommendedActivityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        recommendedActivityIndicator.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.15).isActive = true
        recommendedActivityIndicator.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.15).isActive = true
        
        videoPlayer.anchor(blackView.topAnchor, left: blackView.leftAnchor, bottom: blackView.bottomAnchor, right: blackView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        infoView.topAnchor.constraint(equalTo: blackView.bottomAnchor, constant: -1).isActive = true
        infoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -1).isActive = true
        infoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 1).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 155).isActive = true
        
        collectionView.anchor(infoView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    private func setupAds() {        
        let nativeAds = delegate.nativeAds
        if nativeAds.count > 0 {
            let newNativeAd = nativeAds.randomElement()
            self.nativeAd = newNativeAd
        } else {
            print("No native ads to show")
        }
    }
    
    @objc private func watchAdPressed() {
        adsAlertView.hide()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.rewardAdInstance.isReady {
            appDelegate.rewardAdInstance.present(fromRootViewController: self)
        } else {
            UserDefaults.standard.set(0, forKey: "contentWatchedCount")
            appDelegate.rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()
            appDelegate.rewardAdInstance.load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
            self.setupVideo()
        }
    }
    
    @objc private func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupVideo() {
        let currentContentCount = UserDefaults.standard.integer(forKey: "contentWatchedCount")
                
        if currentContentCount >= 2 {
            adsAlertView.show()
        } else {
            UserDefaults.standard.set(currentContentCount + 1, forKey: "contentWatchedCount")
            activityIndicator.startAnimating()
            getChannelImage()
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
            
            if let video = video {
                videoPlayer.delegate = self
                            
                videoPlayer.load(withVideoId: video.videoId, playerVars: playerVars)
                videoPlayer.setPlaybackQuality(.HD720)
                
                infoView.titleLabel.text = video.title
                infoView.channelNameLabel.text = video.channelTitle
                
                let timeSincePublished = HelperFunctions.getYoutubeTimeAgo(fromString: video.publishedAt)
                let viewCount = HelperFunctions.formatPoints(from: video.viewCount ?? 0)
                
                if video.viewCount != 0 {
                    infoView.viewAndTimeLabel.text = "\(viewCount) views • \(timeSincePublished)"
                } else {
                    infoView.viewAndTimeLabel.text = timeSincePublished
                }
            } else { dismiss(animated: true, completion: nil) }
        }
    }
    
    func getRelatedVideos() {
        recommendedActivityIndicator.startAnimating()
        if let videoId = video?.videoId {
            relatedVideos = []
            self.reloadData()
            YoutubeService.getRelatedVideos(withVideoId: videoId) { (videos) in
                self.relatedVideos = videos
                self.recommendedActivityIndicator.stopAnimating()
                self.reloadData()
            }
        }
    }
    
    private func getChannelImage() {
        if let channelImageURL = video?.channelImageURL {
            ImageService.getImage(withURL: URL(string: channelImageURL)!) { (image) in
                self.infoView.channelImageView.image = image
            }
        } else {
            if let channelId = video?.channelId {
                YoutubeService.getChannelImage(withChannelId: channelId) { (url) in
                    ImageService.getImage(withURL: URL(string: url)!) { (image) in
                        self.infoView.channelImageView.image = image
                    }
                }
            }
        }
    }
    
    @objc private func openYoutube() {
        if let id = video?.videoId, let url = URL(string: "youtube://\(id)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func reloadData() {
        setupAds()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        activityIndicator.stopAnimating()
        playerView.playVideo()
        videoPlayer.isHidden = false
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)

        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y > view.frame.height * 0.7 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}
