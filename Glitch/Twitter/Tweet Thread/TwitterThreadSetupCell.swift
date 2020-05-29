//
//  TwitterThreadSetupCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension TwitterThreadViewController {
    
    func setupBasicCell(tweet: TwitterTweet, indexPath: IndexPath) -> TweetCellBasic {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! TweetCellBasic

        if tweets.count > 1 {
            if indexPath.row == 0 {
                cell.hasReplyView.isHidden = false
            } else if indexPath.row == tweets.count - 1 {
                cell.isReplyView.isHidden = false
            } else {
                cell.hasReplyView.isHidden = false
                cell.isReplyView.isHidden = false
            }
        }
        
        cell.tweet = tweet
        cell.viewController = self
        cell.retweetedLabel.text = ""
        cell.backgroundColor = .twitterMediumBlue()
        
        return cell
    }
    
    func setupQuoteTweetCell(tweet: TwitterTweet, indexPath: IndexPath) -> TwitterQuoteCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: quoteCellId, for: indexPath) as! TwitterQuoteCell
        
        if tweets.count > 1 {
            if indexPath.row == 0 {
                cell.hasReplyView.isHidden = false
            } else if indexPath.row == tweets.count - 1 {
                cell.isReplyView.isHidden = false
            } else {
                cell.hasReplyView.isHidden = false
                cell.isReplyView.isHidden = false
            }
        }
        
        cell.tweet = tweet
        cell.viewController = self
        cell.quoteView.quoteTweet = tweet.quoteTweet
        cell.quoteView.viewController = self
        cell.retweetedLabel.text = ""
        cell.backgroundColor = .twitterMediumBlue()
        
        return cell
    }
    
    func setupSingleMediaCell(tweet: TwitterTweet, indexPath: IndexPath) -> TwitterSingleMediaCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: singleMediaCellId) as! TwitterSingleMediaCell
        
        if tweets.count > 1 {
            if indexPath.row == 0 {
                cell.hasReplyView.isHidden = false
            } else if indexPath.row == tweets.count - 1 {
                cell.isReplyView.isHidden = false
            } else {
                cell.hasReplyView.isHidden = false
                cell.isReplyView.isHidden = false
            }
        }
        
        cell.tweet = tweet
        cell.viewController = self
        cell.retweetedLabel.text = ""
        cell.backgroundColor = .twitterMediumBlue()
        
        return cell
    }
    
    func setupMultiPictureCell(tweet: TwitterTweet, indexPath: IndexPath) -> TwitterMultiPictureCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: multiPicCellId) as! TwitterMultiPictureCell
        
        if tweets.count > 1 {
            if indexPath.row == 0 {
                cell.hasReplyView.isHidden = false
            } else if indexPath.row == tweets.count - 1 {
                cell.isReplyView.isHidden = false
            } else {
                cell.hasReplyView.isHidden = false
                cell.isReplyView.isHidden = false
            }
        }
        
        cell.tweet = tweet
        cell.viewController = self
        cell.retweetedLabel.text = ""
        cell.backgroundColor = .twitterMediumBlue()
        
        return cell
    }
}
