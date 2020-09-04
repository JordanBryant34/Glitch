//
//  ExploreYoutubeCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 4/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class ExploreYoutubeCell: UICollectionViewCell {
    
    let thumbnailImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitchGray()
        return imageView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchLightGray()
        return view
    }()
    
    let channelImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.youtubeRed().cgColor
        imageView.layer.borderWidth = 1
        imageView.backgroundColor = .twitchGray()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textColor = .white
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = .twitchGrayTextColor()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var video: YoutubeVideo? = nil {
        didSet {
            if let video = video {
                setVideoInfo(video: video)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        layer.borderColor = UIColor.youtubeRed().cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        
        addSubview(thumbnailImageView)
        addSubview(bottomView)
        
        bottomView.addSubview(channelImageView)
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(detailsLabel)
        
        bottomView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        thumbnailImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        channelImageView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        channelImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        channelImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        channelImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: -2.5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: channelImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        detailsLabel.topAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: 2.5).isActive = true
        detailsLabel.leftAnchor.constraint(equalTo: channelImageView.rightAnchor, constant: 10).isActive = true
        detailsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
    }
    
    private func setVideoInfo(video: YoutubeVideo) {        
        let timeSincePublished = HelperFunctions.getYoutubeTimeAgo(fromString: video.publishedAt)
                
        thumbnailImageView.image = nil
        channelImageView.image = nil
        
        titleLabel.text = video.title
        detailsLabel.text = "\(video.channelTitle) • \(timeSincePublished)"
        thumbnailImageView.loadImageUsingUrlString(urlString: "https://img.youtube.com/vi/\(video.videoId)/maxresdefault.jpg" as NSString)
        
        if let channelImageUrl = video.channelImageURL {
            channelImageView.loadImageUsingUrlString(urlString: channelImageUrl as NSString)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
