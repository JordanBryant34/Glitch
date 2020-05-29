//
//  MixerBrowseExtension.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/11/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension MixerBrowseController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return games.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 290)
        } else {
            return CGSize(width: (view.frame.width - 50) / 3, height: 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topStreamsCellId, for: indexPath) as! MixerTopStreamsCell
            cell.viewController = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MixerGameCell
            let game = games[indexPath.item]
            
            cell.imageView.loadImageUsingUrlString(urlString: game.coverURL as NSString)
            cell.nameLabel.text = game.name
            cell.viewersLabel.text = "\(HelperFunctions.formatPoints(from: game.viewerCount)) viewers"
            
            if cell.imageView.image == nil {
                cell.imageView.image = UIImage(named: "mixerNoCover")
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = games[indexPath.item]
            
        let streamsController = MixerStreamsController()
        streamsController.game = game
            
        present(streamsController, animated: true, completion: nil)
    }
}
