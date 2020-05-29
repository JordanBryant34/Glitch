//
//  YoutubeSubscriptionsExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/29/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension YoutubeSubscriptionsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! YoutubeSubscriptionCell
        
        let subscription = subscriptions[indexPath.item]
        
        let url = URL(string: subscription.smallThumbnailURL)!
        ImageService.getImage(withURL: url, completion: { (image) in
            if let image = image { cell.thumbnailImageView.image = image }
        })
        
        cell.channelNameLabel.text = subscription.channelName
        cell.channelDescriptionLabel.text = subscription.description
        
        let prevItemCount = UserDefaults.standard.integer(forKey: "\(subscription.channelId)_totalItems")
        if subscription.totalItems > prevItemCount && prevItemCount > 0 {
            cell.newItemIndicator.isHidden = false
        } else {
            cell.newItemIndicator.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subscription = subscriptions[indexPath.item]
        let channelController = YoutubeChannelController()
        let prevItemCount = UserDefaults.standard.integer(forKey: "\(subscription.channelId)_totalItems")
        
        
        YoutubeService.getChannel(withChannelId: subscription.channelId) { (channel) in
            guard let channel = channel else { return }
            channelController.channel = channel
            
            if subscription.totalItems > prevItemCount && prevItemCount > 0 {
                UserDefaults.standard.set(subscription.totalItems, forKey: "\(channel.id)_totalItems")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            self.present(channelController, animated: true, completion: nil)
        }
    }
}
