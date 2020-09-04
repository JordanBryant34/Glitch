//
//  MixerStreamsExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/11/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AVFoundation

extension MixerStreamsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MixerStreamCell
        let stream = streams[indexPath.item]
                
        cell.thumbnailImageView.loadImageUsingUrlString(urlString: stream.thumbnailUrl as NSString)
        cell.profilePicImageView.loadImageUsingUrlString(urlString: stream.profilePicUrl as NSString)
        
        if stream.thumbnailUrl == "" {
            cell.thumbnailImageView.image = UIImage(named: "mixerNoCover")
        }
        
        cell.nameLabel.text = stream.streamerName
        cell.titleLabel.text = stream.title
        cell.viewersLabel.text = "\(HelperFunctions.formatPoints(from: stream.viewerCount)) viewers"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 25, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! MixerStreamsHeader
        guard let game = self.game else { return header }
        
        header.nameLabel.text = game.name
        header.viewersLabel.text = "\(HelperFunctions.formatPoints(from: game.viewerCount)) viewers"
        
        header.backgroundImageView.loadImageUsingUrlString(urlString: game.backgroundURL as NSString)
        if header.backgroundImageView.image == nil {
            header.backgroundImageView.image = UIImage(named: "mixerNoBackground")
        }
        
        header.coverImageView.loadImageUsingUrlString(urlString: game.coverURL as NSString)
        if header.coverImageView.image == nil {
            header.coverImageView.image = UIImage(named: "mixerNoCover")
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width / (16/9))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stream = streams[indexPath.item]
        let streamController = MixerWatchStreamController()
            
        streamController.stream = stream
        streamController.modalPresentationStyle = .overFullScreen
        
        present(streamController, animated: true, completion: nil)
    }
}

