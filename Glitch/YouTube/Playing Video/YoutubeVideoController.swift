//
//  YoutubeVideoController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/26/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AVKit
import WebKit
import NVActivityIndicatorView
import GoogleMobileAds
import Purchases
import YoutubeDirectLinkExtractor

class YoutubeVideoController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .twitchGray()
        cv.dataSource = self
        cv.delegate = self
        cv.isHidden = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchGray()
        return view
    }()
    
    let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var videoPlayer: AVPlayerViewController = {
        let videoView = AVPlayerViewController()
        videoView.view.isHidden = false
        videoView.view.translatesAutoresizingMaskIntoConstraints = false
        return videoView
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
    
    let initialLoadIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .youtubeRed(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var infoView: VideoInfoView = {
        let view = VideoInfoView(frame: self.view.frame)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let adsAlertView: AdsAlertView = {
        let view = AdsAlertView()
        view.alertView.backgroundColor = .twitchLightGray()
        view.alertView.layer.borderColor = UIColor.youtubeRed().cgColor
        view.imageView.contentMode = .scaleToFill
        view.imageView.image = UIImage(named: "youtubeLogoLarge")
        view.imageView.contentMode = .scaleAspectFit
        view.titleLabel.text = "Sorry for the interruption"
        view.detailsLabel.text = "Watch a short ad in order to view this video?"
        view.detailsLabel.textColor = .twitchGrayTextColor()
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
    var adWatched = false
    
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
        
        initialLoadIndicator.startAnimating()
        
        setupAds()
        setupViews()
        getRelatedVideos()
        
        setupVideo()
        setVideoInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if adWatched == true {
            adWatched = false
            setupVideo()
            present(SubscriptionViewController(), animated: true, completion: nil)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        view.addSubview(grayBackgroundView)
        view.addSubview(infoView)
        view.addSubview(statusBarView)
        view.addSubview(blackView)
        view.addSubview(collectionView)
        view.addSubview(initialLoadIndicator)
        view.addSubview(adsAlertView)
        
        collectionView.addSubview(recommendedActivityIndicator)
        
        blackView.addSubview(activityIndicator)
        blackView.addSubview(videoPlayer.view)
        
        self.addChild(videoPlayer)
                
        grayBackgroundView.anchor(blackView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
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
        
        initialLoadIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        initialLoadIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        initialLoadIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        initialLoadIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        
        recommendedActivityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        recommendedActivityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        recommendedActivityIndicator.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.15).isActive = true
        recommendedActivityIndicator.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.15).isActive = true
        
        videoPlayer.view.anchor(blackView.topAnchor, left: blackView.leftAnchor, bottom: blackView.bottomAnchor, right: blackView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
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
        adWatched = true
        
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
        activityIndicator.startAnimating()
        getChannelImage()
        videoPlayer.player = nil
        
        let currentContentCount = UserDefaults.standard.integer(forKey: "contentWatchedCount")
        
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print("Error with purchaser info in youtube video controller: \(error.localizedDescription)")
            }

            if currentContentCount >= 2 && purchaserInfo?.entitlements["remove-ads"]?.isActive != true {
                self.adsAlertView.show()
                self.videoPlayer.player?.pause()
            } else {
                UserDefaults.standard.set(currentContentCount + 1, forKey: "contentWatchedCount")
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print(error)
                }
                
                if let video = self.video {
                    let youtubeLinkExtractor = YoutubeDirectLinkExtractor()
                    youtubeLinkExtractor.extractInfo(for: .id(video.videoId), success: { (info) in
                        if let link = info.lowestQualityPlayableLink {
                            DispatchQueue.main.async {
                                if let player = self.videoPlayer.player {
                                    player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: link)!))
                                } else {
                                    self.videoPlayer.player = AVPlayer(playerItem: AVPlayerItem(url: URL(string: link)!))
                                }
                                self.videoPlayer.player?.play()
                            }
                        }
                    }) { (error) in
                        print("video error: \(error)")
                    }
                } else { self.dismiss(animated: true, completion: nil) }
            }
        }
    }
    
    func setVideoInfo() {
        if let video = video {
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
    
    func getRelatedVideos() {
        recommendedActivityIndicator.startAnimating()
        if let videoId = video?.videoId {
            relatedVideos = []
            self.reloadData()
            YoutubeService.getRelatedVideos(withVideoId: videoId) { (videos) in
                self.relatedVideos = videos
                self.recommendedActivityIndicator.stopAnimating()
                self.initialLoadIndicator.stopAnimating()
                self.collectionView.isHidden = false
                self.infoView.isHidden = false
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
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        if adsAlertView.isShown == false {
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
}
