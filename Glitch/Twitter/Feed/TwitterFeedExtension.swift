//
//  TwitterFeedExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/19/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AVKit
import GoogleMobileAds

extension TwitterFeedController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tweet = tweets[indexPath.row] as? TwitterTweet {
            if tweet.quoteTweet != nil { return setupQuoteTweetCell(tweet: tweet, indexPath: indexPath) }
            
            guard let media = tweet.media else { return setupBasicCell(tweet: tweet) }
            
            switch media.count {
            case 1:
                return setupSingleMediaCell(tweet: tweet, indexPath: indexPath)
            case 2...4:
                return setupMultiPictureCell(tweet: tweet, indexPath: indexPath)
            default:
                return setupBasicCell(tweet: tweet)
            }
        } else {
            return setupAdCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tweets[indexPath.row] is TwitterTweet {
            return UITableView.automaticDimension
        } else {
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tweet = tweets[indexPath.item] as? TwitterTweet {
            let threadController = TwitterThreadViewController()
            threadController.tweetId = tweet.id
            
            present(threadController, animated: true, completion: nil)
        }
    }
    
    private func getRetweetLabelText(retweetedBy: String) -> NSMutableAttributedString {
        let retweetText = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment(image: UIImage(named: "twitterRetweetIcon")!.withRenderingMode((.alwaysTemplate)))
        imageAttachment.bounds = CGRect(x: 0, y: -1, width: 12, height: 12)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        retweetText.append(imageString)
        retweetText.append(NSMutableAttributedString(string: " \(retweetedBy) Retweeted"))
        
        return retweetText
    }
}
