//
//  TwitchTopStreamsController.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/17/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase

class TwitchTopStreamsCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 7.5
        layout.minimumLineSpacing = 7.5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.allowsMultipleSelection = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let topStreamersLabel: UILabel =  {
        let label = UILabel()
        label.text = "Top Streamers"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    let topGamesLabel: UILabel =  {
        let label = UILabel()
        label.text = "Top Games"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    var streams: [TwitchStream] = []
    
    let cellId = "cellId"
    var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        collectionView.register(TwitchTopStreamCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(topStreamersLabel)
        addSubview(collectionView)
        addSubview(topGamesLabel)
        
        topStreamersLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        collectionView.anchor(topStreamersLabel.bottomAnchor, left: leftAnchor, bottom: topGamesLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        topGamesLabel.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 15, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        getStreams()
    }
    
    func getStreams() {
        let parameters = [
            "first" : 20,
            "language" : "en"
            ] as [String : Any]
        
        TwitchService.getStreams(parameters: parameters) { (streams) in
            self.streams = streams
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TwitchTopStreamCell
        let stream = streams[indexPath.item]
        
        if let picUrl = stream.streamerPicURL {
            cell.profilePicImageView.loadImageUsingUrlString(urlString: picUrl as NSString)
        }

        cell.layer.borderColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.1).cgColor
        cell.liveLabel.text = "LIVE"

        cell.nameLabel.text = stream.streamerName
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 172.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let streamController = TwitchStreamController()
        streamController.streamerName = streams[indexPath.item].streamerName
        streamController.streamerImageUrl = streams[indexPath.item].streamerPicURL
        streamController.modalPresentationStyle = .overFullScreen
        
        viewController?.present(streamController, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
