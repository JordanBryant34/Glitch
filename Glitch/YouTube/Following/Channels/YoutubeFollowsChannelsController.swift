//
//  YoutubeFollowsChannelsController.swift
//  Glitch
//
//  Created by Jordan Bryant on 5/3/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase

class YoutubeFollowsChannelsController: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.allowsMultipleSelection = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let addNewFollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .youtubeDarkGray()
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeGray()
        return view
    }()
    
    let unfollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Unfollow", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.youtubeRed(), for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    let cellId = "cellId"
    
    var channels: [YoutubeChannel] = []
    
    var viewController: YoutubeFollowingController?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
                             
        collectionView.register(YoutubeChannelCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addSubview(addNewFollowButton)
        addSubview(separatorView)
        addSubview(unfollowButton)
        
        addNewFollowButton.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 110)
        collectionView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: addNewFollowButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 110)
        separatorView.anchor(collectionView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        unfollowButton.anchor(separatorView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 80, heightConstant: 50)
        
        observeChannels()
    }
    
    private func observeChannels() {
        guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
        let ref = Database.database().reference().child("users").child(id).child("youtube").child("following")
        
        ref.observe(.value) { (snapshot) in
            guard let items = snapshot.value as? NSDictionary else { return }
            self.channels = []
            let channelIds = items.allKeys
            
            for channelId in channelIds {
                guard let channel = items[channelId] as? NSDictionary else { return }
                guard let id = channel["channelId"] as? String else { return }
                guard let imageUrl = channel["channelImageUrl"] as? String else { return }
                guard let title = channel["channelTitle"] as? String else { return }
                guard let uploadPlaylistId = channel["channelUploadPlaylistId"] as? String else { return }
                
                let thisChannel = YoutubeChannel(name: title, id: id, channelDefaultImageURL: imageUrl, channelMediumImageURL: "", channelBannerURL: "", uploadPlaylistId: uploadPlaylistId, subCount: 0, viewCount: 0, videoCount: 0)
                
                self.channels.append(thisChannel)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! YoutubeChannelCell
        let channel = channels[indexPath.item]
        
        cell.channelImageView.image = nil
        
        cell.nameLabel.text = channel.name
        
        let imageUrl = channel.channelDefaultImageURL
        cell.channelImageView.loadImageUsingUrlString(urlString: imageUrl as NSString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var indexPaths = collectionView.indexPathsForSelectedItems
        if let index = indexPaths?.firstIndex(of: indexPath) {
            indexPaths?.remove(at: index)
            
            for selectedIndexPath in indexPaths ?? [] {
                collectionView.deselectItem(at: selectedIndexPath, animated: false)
            }
        }
        
        let channelId = channels[indexPath.item].id
        viewController?.selectedChannel = channels[indexPath.item]
        viewController?.filterByChannel(channelId: channelId)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewController?.videos = viewController?.allVideos ?? []
        viewController?.selectedChannel = nil
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: frame.height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserDefaults {
    @objc dynamic var followedChannels: [String] {
        return array(forKey: "youtubeFollowing") as! [String]
    }
}
