//
//  TwitterThreadControllerExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AVKit

extension TwitterThreadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.item]
        
        if tweet.quoteTweet != nil { return setupQuoteTweetCell(tweet: tweet, indexPath: indexPath) }
        
        guard let media = tweet.media else { return setupBasicCell(tweet: tweet, indexPath: indexPath) }
        
        switch media.count {
        case 1:
            return setupSingleMediaCell(tweet: tweet, indexPath: indexPath)
        case 2...4:
            return setupMultiPictureCell(tweet: tweet, indexPath: indexPath)
        default:
            return setupBasicCell(tweet: tweet, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerId) as! TwitterThreadFooter
        footer.backgroundColor = .twitterMediumBlue()
        footer.backgroundView?.backgroundColor = .twitchGray()
        footer.viewInAppButton.addTarget(self, action: #selector(openTwitter), for: .touchUpInside)
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    @objc private func openTwitter() {
        guard let id = tweetId else { return }
        guard let url = URL(string: "twitter://status?id=\(id)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
