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
            
            cell.thumbnailImageView.image = nil
            cell.profilePicImageView.image = nil
            
            cell.streamerNameLabel.text = stream.steamerName
            cell.titleLabel.text = stream.title
            
            cell.viewerCountLabel.text = "\(HelperFunctions.formatPoints(from: stream.viewerCount)) viewers"
            
            var thumbnailURL = stream.thumbnailURL
            thumbnailURL = thumbnailURL.replacingOccurrences(of: "{width}", with: "1280")
            thumbnailURL = thumbnailURL.replacingOccurrences(of: "{height}", with: "720")            
            cell.thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailURL as NSString)
            
            var profilePicURL = streamer.profilePicURL
            profilePicURL = profilePicURL.replacingOccurrences(of: "{width}", with: "90")
            profilePicURL = profilePicURL.replacingOccurrences(of: "{height}", with: "90")
            cell.profilePicImageView.loadImageUsingUrlString(urlString: profilePicURL as NSString)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: offlineCellId, for: indexPath) as! TwitchStreamerOfflineCell
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
        let streamer = streamers[indexPath.item]
        
        if streamer.stream != nil {
            return CGSize(width: view.frame.width, height: (view.frame.width / (16/9)) + 80)
        } else {
            return CGSize(width: view.frame.width, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let streamer = streamers[indexPath.item]
        
        if streamer.stream != nil {
            let streamController = TwitchStreamController()
            streamController.streamerName = streamers[indexPath.item].name
            streamController.modalPresentationStyle = .overFullScreen
            
            present(streamController, animated: true, completion: nil)
        }
    }
}
