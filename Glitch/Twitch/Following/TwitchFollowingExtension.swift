//
//  TwitchFollowingExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/7/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension TwitchFollowingController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streamers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let streamer = streamers[indexPath.item]
        
        if let stream = streamer.stream {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: liveCellId, for: indexPath) as! TwitchStreamCell
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 3
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.1).cgColor
            
            cell.thumbnailImageView.image = nil
            cell.profilePicImageView.image = nil
            
            cell.streamerNameLabel.text = stream.streamerName
            cell.titleLabel.text = stream.title
            
            cell.viewerCountLabel.text = "\(HelperFunctions.formatPoints(from: stream.viewerCount)) viewers"
            
            var thumbnailURL = stream.thumbnailURL
            thumbnailURL = thumbnailURL.replacingOccurrences(of: "{width}", with: "1280")
            thumbnailURL = thumbnailURL.replacingOccurrences(of: "{height}", with: "720")            
            
            if let url = URL(string: thumbnailURL) {
                ImageService.getImage(withURL: url) { (image) in
                    cell.thumbnailImageView.image = image
                }
            }
            
            var profilePicURL = streamer.profilePicURL
            profilePicURL = profilePicURL.replacingOccurrences(of: "{width}", with: "90")
            profilePicURL = profilePicURL.replacingOccurrences(of: "{height}", with: "90")
            cell.profilePicImageView.loadImageUsingUrlString(urlString: profilePicURL as NSString)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offlineCellId, for: indexPath) as! TwitchStreamerOfflineCell
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 3
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.1).cgColor
            
            cell.profilePicImageView.image = nil
            cell.streamerNameLabel.text = streamer.name
            
            var profilePicURL = streamer.profilePicURL
            profilePicURL = profilePicURL.replacingOccurrences(of: "{width}", with: "90")
            profilePicURL = profilePicURL.replacingOccurrences(of: "{height}", with: "90")
            ImageService.getImage(withURL: URL(string: profilePicURL)!) { (image) in
                cell.profilePicImageView.image = image
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if streamers.count >= indexPath.item + 1 {
            let streamer = streamers[indexPath.item]
            
            if streamer.stream != nil {
                return CGSize(width: view.frame.width - 20, height: (view.frame.width / (16/9)) + 80)
            } else {
                return CGSize(width: view.frame.width - 20, height: 80)
            }
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let streamer = streamers[indexPath.item]
        
        if streamer.stream != nil {
            let streamController = TwitchStreamController()
            streamController.streamerName = streamers[indexPath.item].name
            streamController.streamerImageUrl = streamers[indexPath.item].profilePicURL
            streamController.modalPresentationStyle = .overFullScreen
            
            present(streamController, animated: true, completion: nil)
        }
    }
}
