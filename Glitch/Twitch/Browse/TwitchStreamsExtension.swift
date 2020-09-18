//
//  TwitchStreamsExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension TwitchBrowseStreamsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let stream = streams[indexPath.item] as? TwitchStream {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TwitchStreamCell
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 3
            cell.layer.borderWidth = 1

            cell.layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.1).cgColor
            cell.liveLabel.text = "LIVE"
            
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
                    
            if var profilePicURL = stream.streamerPicURL {
                profilePicURL = profilePicURL.replacingOccurrences(of: "{width}", with: "90")
                profilePicURL = profilePicURL.replacingOccurrences(of: "{height}", with: "90")
                cell.profilePicImageView.loadImageUsingUrlString(urlString: profilePicURL as NSString)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adCellId, for: indexPath) as! LargeNativeAdCollectionViewCell
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 3
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.1).cgColor
            cell.callToActionButton.backgroundColor = .twitchPurple()
            cell.advertiserNameLabel.textColor = .twitchGrayTextColor()
            cell.adLabel.layer.borderColor = UIColor.twitchPurple().cgColor
            cell.adLabel.textColor = .twitchPurple()
            cell.iconImageView.backgroundColor = .twitchLightGray()
            
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
        if streams[indexPath.item] is TwitchStream {
            return CGSize(width: view.frame.width - 20, height: (view.frame.width / (16/9)) + 80)
        } else {
            return CGSize(width: view.frame.width - 20, height: (view.frame.width / (16/9)) + 110)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let stream = streams[indexPath.item] as? TwitchStream {
            let streamController = TwitchStreamController()
            streamController.streamerName = stream.streamerName
            streamController.streamerImageUrl = stream.streamerPicURL
            streamController.modalPresentationStyle = .overFullScreen
            
            present(streamController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! TwitchStreamsHeader
        guard let game = self.game else { return header }
        
        if let headerImage = headerImage {
            header.backgroundImageView.image = headerImage
            
            UIView.animate(withDuration: 0.2) {
                header.backgroundImageView.alpha = 1.0
            }
        }
        
        header.nameLabel.text = game.name
        
        if streams.count > 0 {
            var totalViewers = 0
            for stream in streams {
                if let stream = stream as? TwitchStream {
                    totalViewers += stream.viewerCount
                }
            }
            
            header.viewersLabel.text = "\(HelperFunctions.formatPoints(from: totalViewers)) viewers"
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.item + 1 < streams.count {
                guard let stream = streams[indexPath.item] as? TwitchStream else { return }
                
                var url = stream.thumbnailURL
                url = url.replacingOccurrences(of: "{width}", with: "250")
                url = url.replacingOccurrences(of: "{height}", with: "375")
                
                guard let thumbnailImageUrl = URL(string: url) else { return }
                ImageService.getImage(withURL: thumbnailImageUrl) { (image) in }
            }
        }
    }
}
