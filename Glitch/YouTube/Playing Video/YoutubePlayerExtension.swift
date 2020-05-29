//
//  YoutubePlayerExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/30/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension YoutubeVideoController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RelatedVideoCell
        let video = relatedVideos[indexPath.item]
        
        ImageService.getImage(withURL: URL(string: video.thumbnailURL)!) { (image) in
            cell.thumbnailImageView.image = image
        }
        
        let title = video.title.replacingOccurrences(of: "&#39;", with: "'")
        cell.titleLabel.text = title
        cell.channelNameLabel.text = video.channelTitle
        
        if let viewCount = video.viewCount {
            cell.viewCountLabel.text = "\(HelperFunctions.formatPoints(from: viewCount)) views"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let _ = nativeAd {
           return CGSize(width: view.frame.width, height: 115)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! NativeAdCollectionViewCell
        
        if let nativeAd = nativeAd {
            header.adView.nativeAd = nativeAd
            header.headlineLabel.text = nativeAd.headline
            header.advertiserNameLabel.text = nativeAd.advertiser
            header.callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
            header.iconImageView.image = nativeAd.icon?.image
        }
        
        header.advertiserNameLabel.textColor = .youtubeLightGray()
        header.adLabel.layer.borderColor = UIColor.youtubeRed().cgColor
        header.adLabel.textColor = .youtubeRed()
        header.callToActionButton.backgroundColor = .youtubeRed()
        header.iconImageView.backgroundColor = .youtubeGray()
        header.bottomSeparatorView.backgroundColor = .youtubeGray()
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        video = relatedVideos[indexPath.item]
        
        setupVideo()
        getRelatedVideos()
    }
}
