//
//  TwitchGamesExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension TwitchGamesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return games.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 290)
        } else {
            return CGSize(width: (view.frame.width - 50) / 3, height: 230)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topStreamsCellId, for: indexPath) as! TwitchTopStreamsCell
            cell.viewController = self            
            if cell.streams.count == 0 {
                cell.getStreams()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TwitchBrowseCell
            let game = games[indexPath.item]
            
            cell.boxArtImageView.image = nil
            
            cell.nameLabel.text = game.name
            
            var url = game.boxArtURL
            url = url.replacingOccurrences(of: "{width}", with: "250")
            url = url.replacingOccurrences(of: "{height}", with: "375")
            
            if let boxArtUrl = URL(string: url) {
                ImageService.getImage(withURL: boxArtUrl) { (image) in
                    cell.boxArtImageView.image = image
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let game = games[indexPath.item]
            
            let browseStreamsController = TwitchBrowseStreamsController()
            browseStreamsController.game = game
            
            present(browseStreamsController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.item + 1 < games.count {
                let game = games[indexPath.item]
                
                var url = game.boxArtURL
                url = url.replacingOccurrences(of: "{width}", with: "250")
                url = url.replacingOccurrences(of: "{height}", with: "375")
                
                guard let boxArtUrl = URL(string: url) else { return }
                ImageService.getImage(withURL: boxArtUrl) { (image) in }
            }
        }
    }
}
