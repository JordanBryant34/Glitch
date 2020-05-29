//
//  TwitchStreamsExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension TwitchBrowseStreamsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let stream = streams[indexPath.item] as? TwitchStream {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TwitchStreamCell
            
            cell.thumbnailImageView.image = nil
            cell.profilePicImageView.image = nil
            
            cell.streamerNameLabel.text = stream.steamerName
            cell.titleLabel.text = stream.title
            
            cell.viewerCountLabel.text = "\(HelperFunctions.formatPoints(from: stream.viewerCount)) viewers"
            
            var thumbnailURL = stream.thumbnailURL
            thumbnailURL = thumbnailURL.replacingOccurrences(of: "{width}", with: "1280")
            thumbnailURL = thumbnailURL.replacingOccurrences(of: "{height}", with: "720")
            cell.thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailURL as NSString)
            
            if var profilePicURL = stream.streamerPicURL {
                profilePicURL = profilePicURL.replacingOccurrences(of: "{width}", with: "90")
                profilePicURL = profilePicURL.replacingOccurrences(of: "{height}", with: "90")
                cell.profilePicImageView.loadImageUsingUrlString(urlString: profilePicURL as NSString)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adCellId, for: indexPath) as! LargeNativeAdCollectionViewCell
            
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
            return CGSize(width: view.frame.width, height: (view.frame.width / (16/9)) + 80)
        } else {
            return CGSize(width: view.frame.width, height: (view.frame.width / (16/9)) + 110)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let stream = streams[indexPath.item] as? TwitchStream {
            let streamController = TwitchStreamController()
            streamController.streamerName = stream.steamerName
            streamController.modalPresentationStyle = .overFullScreen
            
            present(streamController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! TwitchStreamsHeader
        guard let game = self.game else { return header }
        
        header.nameLabel.text = game.name
        
        var url = game.boxArtURL
        url = url.replacingOccurrences(of: "{width}", with: "250")
        url = url.replacingOccurrences(of: "{height}", with: "375")
        
        ImageService.getImage(withURL: URL(string: url)!) { (image) in
            header.boxArtImageView.image = image
        }
        
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
        return CGSize(width: view.frame.width, height: 200)
    }
}
