//
//  TwitterProfileViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/6/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView

class TwitterProfileViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.contentInset = insets
        tableView.backgroundColor = .clear
        tableView.backgroundView?.backgroundColor = .clear
        tableView.isHidden = false
        return tableView
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitterLightBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "twitterBackground")
        view.label.text = "Sign in to view your Twitter profile"
        view.subLabel.text = "In order to view your profile, sign into your Twitter account."
        view.subLabel.textColor = .twitterGrayText()
        view.button.setTitle("Sign In", for: .normal)
        view.button.backgroundColor = .twitterLightBlue()
        view.isHidden = true
        return view
    }()
    
    let cellId = "cellId"
    let singleMediaCellId = "singleMediaCellId"
    let multiPicCellId = "multiPicCellId"
    let quoteCellId = "quoteCellId"
    let headerId = "headerId"
    
    var userJson: JSON? {
        didSet {
            if screenName == nil {
                getTweets()
            }
        }
    }
    
    var screenName: String? = nil {
        didSet {
            if screenName == "TwitterSignedInUser" {
                tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
                getSignedInUser()
            } else {
                getTweets()
            }
        }
    }
    
    var tweets: [TwitterTweet] = [] {
        didSet {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TwitterProfileHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(TweetCellBasic.self, forCellReuseIdentifier: cellId)
        tableView.register(TwitterSingleMediaCell.self, forCellReuseIdentifier: singleMediaCellId)
        tableView.register(TwitterMultiPictureCell.self, forCellReuseIdentifier: multiPicCellId)
        tableView.register(TwitterQuoteCell.self, forCellReuseIdentifier: quoteCellId)
        
        view.backgroundColor = .twitterMediumBlue()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(backgroundView)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        backgroundView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / 6).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isBeingPresented == false {
            if let _ = UserDefaults.standard.string(forKey: "twitterAccessToken"), let _ = UserDefaults.standard.string(forKey: "twitterTokenSecret") {
                if tweets.count == 0 {
                    getSignedInUser()
                    backgroundView.isHidden = true
                    tableView.isHidden = false
                }
            } else {
                tweets = []
                backgroundView.isHidden = false
                tableView.isHidden = true
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private func getTweets() {
        activityIndicator.startAnimating()
        
        let parameters = [
            "Accept" : "application/json",
            "tweet_mode" : "extended",
            "include_rts" : "1"
        ]
        
        if let userJson = userJson {
            let screenName = userJson["screen_name"].stringValue
            let url = "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(screenName)&count=100"
            
            TwitterService.getTimeline(withUrl: url, parameters: parameters) { (tweets) in
                self.tweets = tweets
            }
        } else if let screenName = screenName {
            let url = "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(screenName)&count=100"
            
            TwitterService.getTimeline(withUrl: url, parameters: parameters) { (tweets) in
                for tweet in tweets {
                    print(tweet.displayName)
                    
                    if tweet.user["screen_name"].stringValue.lowercased() == self.screenName?.lowercased() {
                        self.userJson = tweet.user
                        break
                    }
                }
                self.tweets = tweets
            }
        }
    }
    
    private func getSignedInUser() {
        activityIndicator.startAnimating()
        
        TwitterService.getSignedInUser { (screenName) in
            self.screenName = screenName
        }
    }
    
    @objc private func signIn() {
        TwitterService.signIn(withViewController: self) { (isSignedIn) in
            if isSignedIn {
                self.backgroundView.isHidden = true
                self.tableView.isHidden = false
                self.screenName = "TwitterSignedInUser"
            } else {
                self.backgroundView.isHidden = false
                self.tableView.isHidden = true
                UserDefaults.standard.removeObject(forKey: "twitterAccessToken")
                UserDefaults.standard.removeObject(forKey: "twitterTokenSecret")
            }
        }
    }
    
    deinit {
        print("Twitter Profile View Controller Deinit")
    }
}
