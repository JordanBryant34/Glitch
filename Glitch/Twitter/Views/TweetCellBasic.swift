//
//  TweetCellBasic.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/19/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TweetCellBasic: UITableViewCell, UITextViewDelegate {
    
    let textView: TwitterTextView = {
        let tv = TwitterTextView()
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = true
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isUserInteractionEnabled = true
        tv.isSelectable = true
        tv.font = .systemFont(ofSize: 15)
        tv.tintColor = .twitterLightBlue()
        tv.textContainerInset = UIEdgeInsets.zero
        tv.textContainer.lineFragmentPadding = 0
        tv.dataDetectorTypes = .link
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let profilePicImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textColor = .white
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let retweetedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .twitterGrayText()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let retweetCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .twitterGrayText()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .twitterGrayText()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .twitterGrayText()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let replyingToLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .twitterGrayText()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let isReplyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.twitterGrayText().withAlphaComponent(0.2)
        view.isHidden = true
        return view
    }()
    
    let hasReplyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.twitterGrayText().withAlphaComponent(0.2)
        view.isHidden = true
        return view
    }()
    
    var tweet: TwitterTweet? {
        didSet {
            setData()
        }
    }
    
    var viewController: UIViewController?
    
    var textViewTopAnchor: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textView.delegate = self
        
        selectionStyle = .none
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        backgroundColor = .clear
        
        contentView.addSubview(isReplyView)
        contentView.addSubview(hasReplyView)
        contentView.addSubview(retweetedLabel)
        contentView.addSubview(profilePicImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(replyingToLabel)
        contentView.addSubview(retweetCountLabel)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(textView)
        
        isReplyView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        isReplyView.bottomAnchor.constraint(equalTo: profilePicImageView.centerYAnchor).isActive = true
        isReplyView.centerXAnchor.constraint(equalTo: profilePicImageView.centerXAnchor).isActive = true
        isReplyView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        hasReplyView.topAnchor.constraint(equalTo: profilePicImageView.centerYAnchor).isActive = true
        hasReplyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        hasReplyView.centerXAnchor.constraint(equalTo: profilePicImageView.centerXAnchor).isActive = true
        hasReplyView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        retweetedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        retweetedLabel.leftAnchor.constraint(equalTo: profilePicImageView.rightAnchor, constant: 10).isActive = true
        
        replyingToLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3).isActive = true
        replyingToLabel.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor).isActive = true
        
        profilePicImageView.anchor(retweetedLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        textView.anchor(nil, left: profilePicImageView.rightAnchor, bottom: retweetCountLabel.topAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 5, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        usernameLabel.anchor(profilePicImageView.topAnchor, left: textView.leftAnchor, bottom: nil, right: textView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        retweetCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        retweetCountLabel.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        retweetCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        retweetCountLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        likeCountLabel.centerYAnchor.constraint(equalTo: retweetCountLabel.centerYAnchor).isActive = true
        likeCountLabel.leftAnchor.constraint(equalTo: retweetCountLabel.rightAnchor).isActive = true
        likeCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeCountLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        dateLabel.centerYAnchor.constraint(equalTo: retweetCountLabel.centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: likeCountLabel.rightAnchor).isActive = true
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        let profilePicTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        usernameLabel.addGestureRecognizer(nameTap)
        profilePicImageView.addGestureRecognizer(profilePicTap)
    }
    
    private func setData() {
        guard let tweet = tweet else { return }
        
        let likeCount = HelperFunctions.formatPoints(from: tweet.likeCount)
        let retweetCount = HelperFunctions.formatPoints(from: tweet.retweetCount)
        var text = tweet.text ?? ""
        
        usernameLabel.attributedText = HelperFunctions.getTwitterUsernameString(username: tweet.name, displayName: tweet.displayName, verified: tweet.verified, fontSize: 16, blueCheckSize: 15)
        profilePicImageView.loadImageUsingUrlString(urlString: tweet.profilePicUrl as NSString)
        likeCountLabel.attributedText = HelperFunctions.textWithImageBefore(text: "\(likeCount)", image: UIImage(named: "twitterLikeIcon")!, yValue: -2, height: 13, width: 13)
        retweetCountLabel.attributedText = HelperFunctions.textWithImageBefore(text: "\(retweetCount)", image: UIImage(named: "twitterRetweetIcon")!, yValue: -2, height: 13, width: 13)
        dateLabel.text = HelperFunctions.getTwitterTimeAgo(fromString: tweet.createdAt)
        
        if let urls = tweet.urls?.array {
            for url in urls {
                text = text.replacingOccurrences(of: url["url"].stringValue, with: url["display_url"].stringValue)
            }
        }
        
        if let retweetedBy = tweet.retweetedBy {
            retweetedLabel.attributedText = HelperFunctions.textWithImageBefore(text: "\(retweetedBy) Retweeted", image: UIImage(named: "twitterRetweetIcon")!, yValue: -1, height: 12, width: 12)
        } else { retweetedLabel.attributedText = NSAttributedString(string: "") }
        

        textViewTopAnchor?.isActive = false
        textViewTopAnchor = nil
            
        if tweet.replyingTo != "" {
            replyingToLabel.text = "Replying to @\(tweet.replyingTo)"
            textViewTopAnchor = textView.topAnchor.constraint(equalTo: replyingToLabel.bottomAnchor, constant: 3)
            textViewTopAnchor?.isActive = true
        } else {
            replyingToLabel.text = ""
            textViewTopAnchor = textView.topAnchor.constraint(equalTo: replyingToLabel.topAnchor)
            textViewTopAnchor?.isActive = true
        }
        
        if let medias = tweet.media {
            for media in medias {
                text = text.replacingOccurrences(of: media.displayUrl, with: "")
            }
        }
        
        let attributedText = HelperFunctions.getTwitterText(text: text)
        textView.attributedText = attributedText
        
        layoutIfNeeded()
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
    
    @objc func profileTapped() {
        let profileController = TwitterProfileViewController()
        profileController.userJson = tweet?.user
        
        viewController?.present(profileController, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
