//
//  YoutubeFollowingExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 5/3/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase

extension YoutubeFollowingController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! YoutubeVideoCell
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 3
        cell.layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.1).cgColor
        cell.layer.borderWidth = 1
        cell.bottomView.backgroundColor = .youtubeDarkGray()
        
        let video = videos[indexPath.item]
                
        let timeSincePublished = HelperFunctions.getYoutubeTimeAgo(fromString: video.publishedAt)
                        
        cell.thumbnailImageView.image = nil
        cell.channelImageView.image = nil
        
        cell.titleLabel.text = video.title
        cell.detailsLabel.text = "\(video.channelTitle) • \(timeSincePublished)"
        
        if video.thumbnailURL == "" {
            cell.thumbnailImageView.loadImageUsingUrlString(urlString: "https://img.youtube.com/vi/\(video.videoId)/sddefault.jpg" as NSString)
        } else {
            cell.thumbnailImageView.loadImageUsingUrlString(urlString: video.thumbnailURL as NSString)
        }
        
        if let channelImageUrl = video.channelImageURL {
            cell.channelImageView.loadImageUsingUrlString(urlString: channelImageUrl as NSString)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: (view.frame.width / (16/9)) + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let _ = selectedChannel {
            return CGSize(width: view.frame.width, height: 160)
        } else {
            return CGSize(width: view.frame.width, height: 122.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! YoutubeFollowsChannelsController
        
        header.addNewFollowButton.addTarget(self, action: #selector(presentSearchController), for: .touchUpInside)
        header.viewController = self
        header.unfollowButton.addTarget(self, action: #selector(unfollowChannel), for: .touchUpInside)
        
        if let _ = selectedChannel {
            header.unfollowButton.isHidden = false
        } else {
            header.unfollowButton.isHidden = true
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerController = YoutubeVideoController()
        let video = videos[indexPath.item]
        
        playerController.video = video
        playerController.modalPresentationStyle = .overFullScreen
        
        present(playerController, animated: true, completion: nil)
    }
    
    @objc func presentSearchController() {
        let searchController = YoutubeSearchController()
        
        self.present(searchController, animated: true, completion: nil)
    }
    
    @objc func unfollowChannel() {
        if let channel = selectedChannel {
            let alertController = UIAlertController(title: "Unfollow \(channel.name)?", message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Unfollow", style: .destructive, handler: { (action) in
                guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
                let ref = Database.database().reference().child("users").child(id).child("youtube").child("following").child(channel.id)
                
                ref.removeValue()
                self.selectedChannel = nil
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
