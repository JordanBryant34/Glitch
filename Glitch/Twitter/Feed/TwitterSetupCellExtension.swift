//
//  TwitterSetupCellExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/21/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import GoogleMobileAds

extension TwitterFeedController {
    
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
    
    func setupAdCell() -> NativeAdTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: adCellId) as! NativeAdTableViewCell
        
        cell.callToActionButton.backgroundColor = .twitterLightBlue()
        cell.advertiserNameLabel.textColor = .twitterGrayText()
        cell.adLabel.layer.borderColor = UIColor.twitterLightBlue().cgColor
        cell.adLabel.textColor = .twitterLightBlue()
        cell.iconImageView.backgroundColor = .twitterDarkBlue()
        
        let nativeAds = delegate.nativeAds
        if nativeAds.count > 0 {
            let newNativeAd = nativeAds.randomElement()
            cell.nativeAd = newNativeAd
        } else {
            print("No native ads to show")
        }
        
        return cell
    }
}
