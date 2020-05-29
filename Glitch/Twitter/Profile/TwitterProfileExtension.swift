//
//  TwitterProfileExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/7/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension TwitterProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.item]
        
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? TwitterProfileHeader else { return nil }
        header.userJson = userJson
        header.viewController = self
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let threadController = TwitterThreadViewController()
        threadController.tweetId = tweets[indexPath.item].id
        
        present(threadController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 500
    }
}
