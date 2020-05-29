//
//  TwitterFeedController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/25/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AVKit
import Firebase
import CRRefresh

class TwitterFeedController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        let insets = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
        tableView.contentInset = insets
        tableView.backgroundColor = .clear
        tableView.backgroundView?.backgroundColor = .clear
        tableView.isHidden = true
        return tableView
    }()
    
    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "twitterBackground")
        view.label.text = "Sign in to view your Twitter feed"
        view.subLabel.text = "In order to view your timeline, sign into your Twitter account."
        view.subLabel.textColor = .twitterGrayText()
        view.button.setTitle("Sign In", for: .normal)
        view.button.backgroundColor = .twitterLightBlue()
        view.isHidden = true
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitterLightBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
        
    var tweets: [Any] = [] {
        didSet {
            if tweets.count > 0 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    let cellId = "cellId"
    let singleMediaCellId = "singleMediaCellId"
    let multiPicCellId = "multiPicCellId"
    let quoteCellId = "quoteCellId"
    let adCellId = "adCellId"
        
    var aboutToBecomeInvisibleCell = -1
    var firstLoad = true
    var visibleIP = IndexPath(row: 0, section: 0)
    var timer: Timer?
    var latestTweetId: Int = 0
    
    var avPlayerItems: [Int : AVPlayerItem] = [:]
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    let animator = CustomAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 90, target: self, selector: #selector(timerSelector), userInfo: nil, repeats: false)
        
        animator.label.textColor = .twitterLightBlue()
        animator.activityIndicator.color = .twitterLightBlue()
        
        tableView.cr.addHeadRefresh(animator: animator) {
            self.updateFeed()
        }
        
        backgroundView.button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TweetCellBasic.self, forCellReuseIdentifier: cellId)
        tableView.register(TwitterSingleMediaCell.self, forCellReuseIdentifier: singleMediaCellId)
        tableView.register(TwitterMultiPictureCell.self, forCellReuseIdentifier: multiPicCellId)
        tableView.register(TwitterQuoteCell.self, forCellReuseIdentifier: quoteCellId)
        tableView.register(NativeAdTableViewCell.self, forCellReuseIdentifier: adCellId)
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let _ = UserDefaults.standard.string(forKey: "twitterAccessToken"), let _ = UserDefaults.standard.string(forKey: "twitterTokenSecret") {
            backgroundView.isHidden = true
            if tweets.count == 0 {
                getTimeline()
            }
        } else {
            tweets = []
            getTimeline()
        }
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(backgroundView)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        backgroundView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    private func getTimeline() {
        if let _ = UserDefaults.standard.string(forKey: "twitterAccessToken"), let _ = UserDefaults.standard.string(forKey: "twitterTokenSecret") {
            
            if animator.isRefreshing == false {
                backgroundView.isHidden = true
                tableView.isHidden = true
                activityIndicator.startAnimating()
            }
            
            let parameters = [
                "Accept" : "application/json",
                "tweet_mode" : "extended",
                "include_rts" : "1"
            ]
            
            tweets = []
            TwitterService.getTimeline(withUrl: "https://api.twitter.com/1.1/statuses/home_timeline.json?count=150", parameters: parameters) { (tweets) in
                self.tweets = tweets
                self.injectAds()
                self.getLatestTweetId()
            }
        } else {
            activityIndicator.stopAnimating()
            tableView.isHidden = true
            backgroundView.isHidden = false
        }
    }
    
    private func injectAds() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let nativeAds = delegate.nativeAds
        
        if nativeAds.count <= 0 { return }
        if tweets.count <= 0 { return }
        
        tweets = tweets.adding(GADUnifiedNativeAd(), afterEvery: 8)
    }
    
    @objc private func updateFeed() {
        if let _ = UserDefaults.standard.string(forKey: "twitterAccessToken"), let _ = UserDefaults.standard.string(forKey: "twitterTokenSecret") {
            if timer?.isValid == false {
                backgroundView.isHidden = true
                
                let parameters = [
                    "Accept" : "application/json",
                    "tweet_mode" : "extended",
                    "include_rts" : "1",
                    "since_id" : "\(latestTweetId)"
                ]
                
                TwitterService.getTimeline(withUrl: "https://api.twitter.com/1.1/statuses/home_timeline.json?count=150", parameters: parameters) { (tweets) in
                    if tweets.count != 0 {
                        self.tweets = tweets + self.tweets
                        self.getLatestTweetId()
                        self.tableView.reloadData()
                    }
                    self.timer = Timer.scheduledTimer(timeInterval: 90, target: self, selector: #selector(self.timerSelector), userInfo: nil, repeats: false)
                    self.tableView.cr.endHeaderRefresh()
                }
            } else {
                self.tableView.cr.endHeaderRefresh()
            }
        } else {
            tableView.isHidden = true
            backgroundView.isHidden = false
        }
    }
    
    private func getLatestTweetId() {
        for tweet in tweets {
            if let tweet = tweet as? TwitterTweet {
                if tweet.id > latestTweetId {
                    latestTweetId = tweet.id
                }
            }
        }
    }
    
    @objc private func timerSelector() {
        print("Timer is done running")
    }
    
    @objc private func signIn() {
        TwitterService.signIn(withViewController: self) { (isSignedIn) in
            if isSignedIn {
                self.backgroundView.isHidden = true
                self.activityIndicator.startAnimating()
                self.getTimeline()
            } else {
                self.backgroundView.isHidden = false
                UserDefaults.standard.removeObject(forKey: "twitterAccessToken")
                UserDefaults.standard.removeObject(forKey: "twitterTokenSecret")
            }
        }
    }
}
