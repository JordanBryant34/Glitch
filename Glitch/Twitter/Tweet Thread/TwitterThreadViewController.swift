//
//  TwitterThreadViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/13/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TwitterThreadViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        let insets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.contentInset = insets
        tableView.backgroundColor = .clear
        tableView.backgroundView?.backgroundColor = .clear
        tableView.isHidden = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitterLightBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var tweetId: Int? = nil {
        didSet {
            if let id = tweetId {
                getThread(id: id)
            }
        }
    }
    
    var tweets: [TwitterTweet] = []
    
    var lastId: Int = 0
    
    let cellId = "cellId"
    let singleMediaCellId = "singleMediaCellId"
    let multiPicCellId = "multiPicCellId"
    let quoteCellId = "quoteCellId"
    let footerId = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .twitchLightGray()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TweetCellBasic.self, forCellReuseIdentifier: cellId)
        tableView.register(TwitterSingleMediaCell.self, forCellReuseIdentifier: singleMediaCellId)
        tableView.register(TwitterMultiPictureCell.self, forCellReuseIdentifier: multiPicCellId)
        tableView.register(TwitterQuoteCell.self, forCellReuseIdentifier: quoteCellId)
        tableView.register(TwitterThreadFooter.self, forHeaderFooterViewReuseIdentifier: footerId)
        
        view.addSubview(activityIndicator)
        view.addSubview(tableView)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0.5)
        let topLine = UIView(frame: frame)
        topLine.backgroundColor = UIColor.twitterGrayText().withAlphaComponent(0.2)
        tableView.tableHeaderView = topLine
    }
    
    private func getThread(id: Int) {
        activityIndicator.startAnimating()
        TwitterService.getTweet(withId: id) { (tweet) in
            self.tweets.append(tweet)
            if tweet.inReplyToId != 0, let id = tweet.inReplyToId, id != self.lastId {
                self.lastId = id
                self.getThread(id: id)
            } else {
                self.tweets = self.tweets.reversed()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
    }
}
