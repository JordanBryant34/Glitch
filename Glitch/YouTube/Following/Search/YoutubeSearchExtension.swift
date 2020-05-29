//
//  YoutubeSearchExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 5/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase

extension YoutubeSearchController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! YoutubeSearchCell
        let channel = results[indexPath.row]
        
        cell.channelImageView.loadImageUsingUrlString(urlString: channel.channelDefaultImageURL as NSString)
        cell.channelNameLabel.text = channel.name
        
        if channels.contains(channel.id) == true {
            cell.followButton.setTitle("Following", for: .normal)
            cell.followButton.tag = indexPath.row
            cell.followButton.backgroundColor = .youtubeGray()
            cell.followButton.isEnabled = false
            cell.followButton.addTarget(self, action: #selector(followChannel), for: .touchUpInside)
        } else {
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.tag = indexPath.row
            cell.followButton.backgroundColor = .youtubeRed()
            cell.followButton.isEnabled = true
            cell.followButton.addTarget(self, action: #selector(followChannel), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc private func followChannel(sender: UIButton) {
        let channel = results[sender.tag]
        guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
        YoutubeService.getChannel(withChannelId: channel.id) { (channel) in
            if let channel = channel {
                let channelData = [
                    "channelId" : channel.id,
                    "channelTitle" : channel.name,
                    "channelImageUrl" : channel.channelDefaultImageURL,
                    "channelUploadPlaylistId" : channel.uploadPlaylistId
                ]
                    
                let userRef = Database.database().reference().child("users").child(id).child("youtube").child("following").child(channel.id)
                userRef.updateChildValues(channelData)
                    
                sender.setTitle("Following", for: .normal)
                sender.backgroundColor = .youtubeGray()
                    
                self.channels.append(channel.id)
            }
        }
    }
}
