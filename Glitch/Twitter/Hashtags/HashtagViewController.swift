//
//  HashtagViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/11/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView

class HashtagViewController: UIViewController {
    
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
    
    let cellId = "cellId"
    let singleMediaCellId = "singleMediaCellId"
    let multiPicCellId = "multiPicCellId"
    let quoteCellId = "quoteCellId"
    let headerId = "headerId"
    
    var hashtag: String? {
        didSet {
            getTweets()
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TwitterProfileHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(TweetCellBasic.self, forCellReuseIdentifier: cellId)
        tableView.register(TwitterSingleMediaCell.self, forCellReuseIdentifier: singleMediaCellId)
        tableView.register(TwitterMultiPictureCell.self, forCellReuseIdentifier: multiPicCellId)
        tableView.register(TwitterQuoteCell.self, forCellReuseIdentifier: quoteCellId)
        
        view.backgroundColor = .twitchGray()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    private func getTweets() {
        activityIndicator.startAnimating()
        
        if let hashtag = hashtag {
            let url = "https://api.twitter.com/1.1/search/tweets.json"
            
            let parameters = [
                "Accept" : "application/json",
                "tweet_mode" : "extended",
                "count" : "100",
                "result_type" : "popular",
                "include_rts" : "0",
                "include_entities" : "true",
                "q" : hashtag
            ]
            
            TwitterService.searchTweets(withUrl: url, parameters: parameters) { (tweets) in
                self.tweets = tweets
            }
        }
    }
}
