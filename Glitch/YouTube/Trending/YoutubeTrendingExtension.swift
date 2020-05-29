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
            
            let viewCount = HelperFunctions.formatPoints(from: video.viewCount ?? 0)
            
            let timeSincePublished = HelperFunctions.getYoutubeTimeAgo(fromString: video.publishedAt)
                    
            cell.titleLabel.text = video.title
            cell.detailsLabel.text = "\(video.channelTitle) • \(viewCount) views • \(timeSincePublished)"
            
            if video.thumbnailURL == "" {
                cell.thumbnailImageView.loadImageUsingUrlString(urlString: "https://img.youtube.com/vi/\(video.videoId)/sddefault.jpg" as NSString)
            } else {
                cell.thumbnailImageView.loadImageUsingUrlString(urlString: video.thumbnailURL as NSString)
            }
            
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
            
            cell.callToActionButton.backgroundColor = .youtubeRed()
            cell.advertiserNameLabel.textColor = .youtubeLightGray()
            cell.adLabel.layer.borderColor = UIColor.youtubeRed().cgColor
            cell.adLabel.textColor = .youtubeRed()
            cell.iconImageView.backgroundColor = .youtubeLightGray()
            
            let nativeAds = delegate.nativeAds
            if nativeAds.count > 0 {
                let newNativeAd = nativeAds.randomElement()
                cell.nativeAd = newNativeAd
            } else {
                print("No native ads to show")
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if videos[indexPath.item] is YoutubeVideo {
            return CGSize(width: view.frame.width, height: (view.frame.width / (16/9)) + 80)
        } else {
            return CGSize(width: view.frame.width, height: (view.frame.width / (16/9)) + 110)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let video = videos[indexPath.item] as? YoutubeVideo {
            let videoController = YoutubeVideoController()
            
            let videoToPlay = YoutubeVideo(title: video.title, videoId: video.videoId, thumbnailURL: video.thumbnailURL, publishedAt: video.publishedAt, channelTitle: video.channelTitle, channelId: video.channelId, viewCount: video.viewCount, duration: nil, channelImageURL: video.channelImageURL)
            
            videoController.video = videoToPlay
            videoController.modalPresentationStyle = .overFullScreen
            
            present(videoController, animated: true, completion: nil)
        }
    }
}
