//
//  TwitterProfileHeader.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/7/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import SwiftyJSON

class TwitterProfileHeader: UITableViewHeaderFooterView, UITextViewDelegate {
    
    let backgroundImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitchLightGray()
        return imageView
    }()
    
    let profileImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitchLightGray()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 45
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.twitchGray().cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.sizeToFit()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .twitterGrayText()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = true
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = true
        tv.tintColor = .twitterLightBlue()
        tv.font = .systemFont(ofSize: 15)
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        tv.textContainer.lineFragmentPadding = 0
        tv.dataDetectorTypes = .link
        return tv
    }()
    
    let followerCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .twitterGrayText()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .twitterGrayText()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.twitterGrayText().withAlphaComponent(0.2)
        return view
    }()
    
    var userJson: JSON? {
        didSet {
            setHeaderData()
        }
    }
    
    var viewController: UIViewController?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        bioTextView.delegate = self
        
        contentView.backgroundColor = .twitchGray()
        backgroundColor = .twitchGray()
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(bioTextView)
        contentView.addSubview(followingCountLabel)
        contentView.addSubview(followerCountLabel)
        contentView.addSubview(separatorView)
        
        backgroundImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UIScreen.main.bounds.width / 3)
        
        profileImageView.centerYAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 10).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        
        displayNameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2.5).isActive = true
        displayNameLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        
        bioTextView.anchor(displayNameLabel.bottomAnchor, left: profileImageView.leftAnchor, bottom: followingCountLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        followingCountLabel.topAnchor.constraint(equalTo: bioTextView.bottomAnchor).isActive = true
        followingCountLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        followingCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        
        followerCountLabel.topAnchor.constraint(equalTo: followingCountLabel.topAnchor).isActive = true
        followerCountLabel.leftAnchor.constraint(equalTo: followingCountLabel.rightAnchor, constant: 15).isActive = true
        
        separatorView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        layoutIfNeeded()
    }
    
    func setHeaderData() {
        guard let userJson = userJson else {
            print("No user data to fill out twitter header with")
            return
        }
                
        var profilePicUrl = userJson["profile_image_url_https"].stringValue
        profilePicUrl = profilePicUrl.replacingOccurrences(of: "_normal", with: "_400x400")
        
        profileImageView.loadImageUsingUrlString(urlString: profilePicUrl as NSString)
        backgroundImageView.loadImageUsingUrlString(urlString: userJson["profile_banner_url"].stringValue as NSString)
        
        let attributedUsername = HelperFunctions.getTwitterUsernameString(username: userJson["name"].stringValue, displayName: "", verified: userJson["verified"].boolValue, fontSize: 22, blueCheckSize: 18)
        usernameLabel.attributedText = attributedUsername
        
        displayNameLabel.text = "@\(userJson["screen_name"].stringValue)"
        
        var bioText = userJson["description"].stringValue
        
        if let urls = userJson["entities"]["description"]["urls"].array {
            for url in urls {
                bioText = bioText.replacingOccurrences(of: url["url"].stringValue, with: url["display_url"].stringValue)
            }
        }
                
        let followerCount = userJson["followers_count"].intValue
        followerCountLabel.text = "\(HelperFunctions.formatPoints(from: followerCount)) Followers"
        
        let followingCount = userJson["friends_count"].intValue
        followingCountLabel.text = "\(HelperFunctions.formatPoints(from: followingCount)) Following"
        
        bioTextView.attributedText = HelperFunctions.getTwitterText(text: bioText)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        var urlString = URL.absoluteString
        
        print(urlString)
        
        if urlString.hasPrefix("#") {
            let hashtagController = HashtagViewController()
            hashtagController.hashtag = urlString
            viewController?.present(hashtagController, animated: true, completion: nil)
        } else if urlString.hasPrefix("@") {
            urlString.remove(at: urlString.startIndex)
            
            let profileController = TwitterProfileViewController()
            profileController.screenName = urlString
            viewController?.present(profileController, animated: true, completion: nil)
        } else if urlString.hasPrefix("http://twitch.tv/") || urlString.hasPrefix("http://Twitch.tv/") {
            urlString = urlString.replacingOccurrences(of: "http://twitch.tv/", with: "")
            urlString = urlString.replacingOccurrences(of: "http://Twitch.tv/", with: "")
                        
            let twitchStreamController = TwitchStreamController()
            twitchStreamController.streamerName = urlString
            twitchStreamController.modalPresentationStyle = .overFullScreen
            
            viewController?.present(twitchStreamController, animated: true, completion: nil)
        } else if urlString.contains("mixer.com/") || urlString.contains("Mixer.com/") {
            urlString = urlString.replacingOccurrences(of: "http://mixer.com/", with: "")
            urlString = urlString.replacingOccurrences(of: "http://Mixer.com/", with: "")
            
            MixerService.getOneMixerStream(fromUsername: urlString) { (stream) in
                let mixerStreamController = MixerWatchStreamController()
                mixerStreamController.stream = stream
                mixerStreamController.modalPresentationStyle = .overFullScreen
                
                self.viewController?.present(mixerStreamController, animated: true, completion: nil)
            }
        } else {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
        
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
