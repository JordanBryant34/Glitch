//
//  ExplorePageExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension ExplorePageController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("item count: \(exploreItems.count)")
        return exploreItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if exploreItems.indices.contains(indexPath.item) {
            if let channel = exploreItems[indexPath.item] as? MixerChannel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mixerCellId, for: indexPath) as! ExploreMixerCell
                cell.channel = channel
                return cell
            } else if let stream = exploreItems[indexPath.item] as? TwitchStream {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: twitchCellId, for: indexPath) as! ExploreTwitchCell
                cell.stream = stream
                return cell
            } else if let video = exploreItems[indexPath.item] as? YoutubeVideo {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: youtubeCellId, for: indexPath) as! ExploreYoutubeCell
                cell.video = video
                return cell
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath)
            }
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if exploreItems.indices.contains(indexPath.item) {
            if exploreItems[indexPath.item] is MixerChannel {
                return CGSize(width: view.frame.width - 20, height: 80)
            } else if exploreItems[indexPath.item] is YoutubeVideo || exploreItems[indexPath.item] is TwitchStream {
                return CGSize(width: (view.frame.width - 20), height: ((view.frame.width - 20) / (16/9)) + 80)
            } else {
                return CGSize(width: 0, height: 0)
            }
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! ExploreHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let channel = exploreItems[indexPath.item] as? MixerChannel {
            let mixerStreamController = MixerWatchStreamController()
            mixerStreamController.stream = MixerStream(streamerName: channel.username, thumbnailUrl: "", profilePicUrl: channel.profilePicUrl, title: "", channelId: channel.id, viewerCount: 0)
            mixerStreamController.modalPresentationStyle = .overFullScreen
            present(mixerStreamController, animated: true, completion: nil)
        } else if let stream = exploreItems[indexPath.item] as? TwitchStream {
            let twitchStreamController = TwitchStreamController()
            twitchStreamController.streamerName = stream.steamerName
            twitchStreamController.modalPresentationStyle = .overFullScreen
            present(twitchStreamController, animated: true, completion: nil)
        } else if let video = exploreItems[indexPath.item] as? YoutubeVideo {
            let youtubeVideoController = YoutubeVideoController()
            youtubeVideoController.video = video
            youtubeVideoController.modalPresentationStyle = .overFullScreen
            present(youtubeVideoController, animated: true, completion: nil)
        }
    }
}
