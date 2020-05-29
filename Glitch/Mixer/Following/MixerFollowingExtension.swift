//
//  MixerFollowingExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/16/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension MixerFollowingController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MixerFollowCell
        let channel = channels[indexPath.item]
        
        cell.profilePicImageView.image = UIImage(named: "mixerNoCover")
        
        cell.nameLabel.text = channel.username
        cell.profilePicImageView.loadImageUsingUrlString(urlString: channel.profilePicUrl as NSString)
        
        if channel.isOnline == 1 {
            cell.liveLabel.isHidden = false
            cell.offlineLabel.isHidden = true
            cell.playingLabel.text = "Playing \(channel.game)"
        } else {
            cell.liveLabel.isHidden = true
            cell.offlineLabel.isHidden = false
            cell.playingLabel.text = ""
        }
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let channel = channels[indexPath.item]
        
        if channel.isOnline == 1 {
            let mixerStreamController = MixerWatchStreamController()
            mixerStreamController.stream = MixerStream(streamerName: channel.username, thumbnailUrl: "", profilePicUrl: channel.profilePicUrl, title: "", channelId: channel.id, viewerCount: 0)
            mixerStreamController.modalPresentationStyle = .overFullScreen
            
            present(mixerStreamController, animated: true, completion: nil)
        }
    }
}
