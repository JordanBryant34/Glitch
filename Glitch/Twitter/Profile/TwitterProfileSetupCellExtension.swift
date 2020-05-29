//
//  TwitterProfileSetupCellExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/9/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension TwitterProfileViewController {
    
    func setupBasicCell(tweet: TwitterTweet) -> TweetCellBasic {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! TweetCellBasic
        cell.tweet = tweet
        cell.viewController = self
        return cell
    }
    
    func setupQuoteTweetCell(tweet: TwitterTweet, indexPath: IndexPath) -> TwitterQuoteCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: quoteCellId, for: indexPath) as! TwitterQuoteCell
        cell.tweet = tweet
        cell.viewController = self
        cell.quoteView.quoteTweet = tweet.quoteTweet
        cell.quoteView.viewController = self
        return cell
    }
    
    func setupSingleMediaCell(tweet: TwitterTweet, indexPath: IndexPath) -> TwitterSingleMediaCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: singleMediaCellId) as! TwitterSingleMediaCell
        cell.tweet = tweet
        cell.viewController = self
        return cell
    }
    
    func setupMultiPictureCell(tweet: TwitterTweet, indexPath: IndexPath) -> TwitterMultiPictureCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: multiPicCellId) as! TwitterMultiPictureCell
        cell.tweet = tweet
        cell.viewController = self
        return cell
    }
}
