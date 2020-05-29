//
//  YoutubeChannelExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/31/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension YoutubeChannelController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RelatedVideoCell
        let video = videos[indexPath.item]
        
        let title = video.title.replacingOccurrences(of: "&#39;", with: "'")
        
        cell.channelNameLabel.text = video.channelTitle
        cell.titleLabel.text = title
        cell.viewCountLabel.text = "\(HelperFunctions.formatPoints(from: video.viewCount ?? 0)) views"
        
        ImageService.getImage(withURL: URL(string: video.thumbnailURL)!) { (image) in
            cell.thumbnailImageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 275)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ChannelHeaderCell
        if let channel = channel {
            ImageService.getImage(withURL: URL(string: channel.channelBannerURL)!) { (image) in
                header.bannerImageView.image = image
            }
            
            ImageService.getImage(withURL: URL(string: channel.channelMediumImageURL)!) { (image) in
                header.channelImageView.image = image
            }
            
            header.channelNameLabel.text = channel.name
            header.videosLabel.text = "\(HelperFunctions.formatPoints(from: channel.videoCount))\nvideos"
            header.subscriberLabel.text = "\(HelperFunctions.formatPoints(from: channel.subCount))\nsubscribers"
            header.viewsLabel.text = "\(HelperFunctions.formatPoints(from: channel.viewCount))\nviews"
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.item]
        let playerController = YoutubeVideoController()
        
        playerController.video = video
        playerController.modalPresentationStyle = .overFullScreen
        present(playerController, animated: true, completion: nil)
    }
}
