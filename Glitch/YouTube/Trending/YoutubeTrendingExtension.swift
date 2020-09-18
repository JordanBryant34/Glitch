//
//  YoutubeTrendingExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/27/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension YoutubeTrendingController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let video = videos[indexPath.item] as? YoutubeVideo {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! YoutubeVideoCell
            
            cell.thumbnailImageView.image = nil
            cell.channelImageView.image = nil
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 3
            cell.layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.1).cgColor
            cell.layer.borderWidth = 1
            cell.bottomView.backgroundColor = .twitchLightGray()
            
            let viewCount = HelperFunctions.formatPoints(from: video.viewCount ?? 0)
            
            let timeSincePublished = HelperFunctions.getYoutubeTimeAgo(fromString: video.publishedAt)
                    
            cell.titleLabel.text = video.title
            
            if viewCount == "0" {
                cell.detailsLabel.text = "\(video.channelTitle) • \(timeSincePublished)"
            } else {
                cell.detailsLabel.text = "\(video.channelTitle) • \(viewCount) views • \(timeSincePublished)"
            }
            
            let imageUrl = "https://img.youtube.com/vi/\(video.videoId)/maxresdefault.jpg"
            
            cell.thumbnailImageView.loadImageUsingUrlString(urlString: imageUrl as NSString)
        
            if let picString = video.channelImageURL {
                let channelImageURL = URL(string: picString)!
                ImageService.getImage(withURL: channelImageURL) { (image) in
                    if let image = image {
                        cell.channelImageView.image = image
                    } else {
                        cell.channelImageView.image = nil
                    }
                }
            } else {
                cell.channelImageView.image = nil
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adCellId, for: indexPath) as! LargeNativeAdCollectionViewCell
            //do native ad stuff here
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if videos[indexPath.item] is YoutubeVideo {
            return CGSize(width: view.frame.width - 20, height: (view.frame.width / (16/9)) + 80)
        } else {
            return CGSize(width: view.frame.width - 20, height: (view.frame.width / (16/9)) + 110)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if keyboardIsVisible {
            dismissKeyboard()
        } else if let video = videos[indexPath.item] as? YoutubeVideo {
            print(keyboardIsVisible)
            let videoController = YoutubeVideoController()
            
            let videoToPlay = YoutubeVideo(title: video.title, videoId: video.videoId, thumbnailURL: video.thumbnailURL, publishedAt: video.publishedAt, channelTitle: video.channelTitle, channelId: video.channelId, viewCount: video.viewCount, duration: nil, channelImageURL: video.channelImageURL)
            
            videoController.video = videoToPlay
            videoController.modalPresentationStyle = .overFullScreen
            
            present(videoController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! YoutubeTrendingHeaderCell
        header.searchBar.delegate = self
        return header
    }
}
