//
//  TwitterMultiPictureCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/23/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TwitterMultiPictureCell: UITableViewCell, UITextViewDelegate {
    
    let textView: TwitterTextView = {
        let tv = TwitterTextView()
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = true
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = true
        tv.tintColor = .twitterLightBlue()
        tv.font = .systemFont(ofSize: 15)
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
        label.font = .boldSystemFont(ofSize: 16)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.sizeToFit()
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
     
    let imageView1: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitterDarkBlue()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let imageView2: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitterDarkBlue()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let imageView3: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitterDarkBlue()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let imageView4: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitterDarkBlue()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
     
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .twitterGrayText()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mediaView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterDarkBlue()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.twitterGrayText().withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 0.5
        view.isUserInteractionEnabled = true
        return view
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
    
    var tweetMedia: [TwitterMedia]? {
        didSet {
            if let tweetMedia = tweetMedia {
                imageView1.removeFromSuperview()
                imageView2.removeFromSuperview()
                imageView3.removeFromSuperview()
                imageView4.removeFromSuperview()
                switch tweetMedia.count {
                case 1:
                    handleOnePicture(tweetMedia: tweetMedia)
                case 2:
                    handleTwoPictures(tweetMedia: tweetMedia)
                case 3:
                    handleThreePictures(tweetMedia: tweetMedia)
                case 4:
                    handleFourPictures(tweetMedia: tweetMedia)
                default:
                    handleOnePicture(tweetMedia: tweetMedia)
                }
            }
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
        contentView.addSubview(mediaView)
        
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
        textView.anchor(nil, left: profilePicImageView.rightAnchor, bottom: mediaView.topAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
         
        usernameLabel.topAnchor.constraint(equalTo: retweetedLabel.bottomAnchor, constant: 5).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
         
        mediaView.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: retweetCountLabel.topAnchor, constant: -10).isActive = true
        mediaView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        mediaView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 100) / (16/9)).isActive = true
                  
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
        
        if let retweetedBy = tweet.retweetedBy {
            retweetedLabel.attributedText = HelperFunctions.textWithImageBefore(text: "\(retweetedBy) Retweeted", image: UIImage(named: "twitterRetweetIcon")!, yValue: -1, height: 12, width: 12)
        } else { retweetedLabel.attributedText = NSAttributedString(string: "") }
        
        textViewTopAnchor?.isActive = false
        
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
        
        if let urls = tweet.urls?.array {
            for url in urls {
                text = text.replacingOccurrences(of: url["url"].stringValue, with: url["display_url"].stringValue)
            }
        }
        
        textView.attributedText = HelperFunctions.getTwitterText(text: text)
        
        tweetMedia = tweet.media
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        mediaView.addGestureRecognizer(pictureTap)
    }
    
    private func handleOnePicture(tweetMedia: [TwitterMedia]) {
        mediaView.addSubview(imageView1)
        
        imageView1.anchor(mediaView.topAnchor, left: mediaView.leftAnchor, bottom: mediaView.bottomAnchor, right: mediaView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageView1.loadImageUsingUrlString(urlString: tweetMedia[0].url as NSString)
        
        layoutIfNeeded()
    }
    
    private func handleTwoPictures(tweetMedia: [TwitterMedia]) {
        mediaView.addSubview(imageView1)
        mediaView.addSubview(imageView2)
        
        imageView1.anchor(mediaView.topAnchor, left: mediaView.leftAnchor, bottom: mediaView.bottomAnchor, right: mediaView.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        imageView2.anchor(mediaView.topAnchor, left: mediaView.centerXAnchor, bottom: mediaView.bottomAnchor, right: mediaView.rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageView1.loadImageUsingUrlString(urlString: tweetMedia[0].url as NSString)
        imageView2.loadImageUsingUrlString(urlString: tweetMedia[1].url as NSString)
        
        layoutIfNeeded()
    }
    
    private func handleThreePictures(tweetMedia: [TwitterMedia]) {
        mediaView.addSubview(imageView1)
        mediaView.addSubview(imageView2)
        mediaView.addSubview(imageView3)
        
        imageView1.anchor(mediaView.topAnchor, left: mediaView.leftAnchor, bottom: mediaView.bottomAnchor, right: mediaView.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        imageView2.anchor(mediaView.topAnchor, left: mediaView.centerXAnchor, bottom: mediaView.centerYAnchor, right: mediaView.rightAnchor, topConstant: 0, leftConstant: 2.5, bottomConstant: 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        imageView3.anchor(mediaView.centerYAnchor, left: mediaView.centerXAnchor, bottom: mediaView.bottomAnchor, right: mediaView.rightAnchor, topConstant: 2.5, leftConstant: 2.5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageView1.loadImageUsingUrlString(urlString: tweetMedia[0].url as NSString)
        imageView2.loadImageUsingUrlString(urlString: tweetMedia[1].url as NSString)
        imageView3.loadImageUsingUrlString(urlString: tweetMedia[2].url as NSString)
        
        layoutIfNeeded()
    }
    
    private func handleFourPictures(tweetMedia: [TwitterMedia]) {
        mediaView.addSubview(imageView1)
        mediaView.addSubview(imageView2)
        mediaView.addSubview(imageView3)
        mediaView.addSubview(imageView4)
        
        imageView1.anchor(mediaView.topAnchor, left: mediaView.leftAnchor, bottom: mediaView.centerYAnchor, right: mediaView.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 2, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        imageView2.anchor(mediaView.topAnchor, left: mediaView.centerXAnchor, bottom: mediaView.centerYAnchor, right: mediaView.rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        imageView3.anchor(mediaView.centerYAnchor, left: mediaView.centerXAnchor, bottom: mediaView.bottomAnchor, right: mediaView.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        imageView4.anchor(mediaView.centerYAnchor, left: mediaView.leftAnchor, bottom: mediaView.bottomAnchor, right: mediaView.centerXAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        
        imageView1.loadImageUsingUrlString(urlString: tweetMedia[0].url as NSString)
        imageView2.loadImageUsingUrlString(urlString: tweetMedia[1].url as NSString)
        imageView3.loadImageUsingUrlString(urlString: tweetMedia[2].url as NSString)
        imageView4.loadImageUsingUrlString(urlString: tweetMedia[3].url as NSString)
        
        layoutIfNeeded()
    }
    
    @objc private func imageTapped() {
        if tweet?.media?[0].type == "photo" {
            guard let tweetMedia = tweet?.media else { return }
        
            let imageViewer = TwitterImageViewerController()
            imageViewer.media = tweetMedia
            imageViewer.modalPresentationStyle = .overFullScreen
        
            viewController?.present(imageViewer, animated: true, completion: nil)
        }
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
        } else if urlString.hasPrefix("http://mixer.com/") || urlString.hasPrefix("http://Mixer.com/") {
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
