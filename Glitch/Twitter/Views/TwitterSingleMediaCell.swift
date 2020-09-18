//
//  TwitterSingleMediaCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/20/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AVKit
import NVActivityIndicatorView

class TwitterSingleMediaCell: UITableViewCell, UITextViewDelegate {
    
    let textView: TwitterTextView = {
        let tv = TwitterTextView()
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = true
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.isSelectable = true
        tv.tintColor = .twitterLightBlue()
        tv.isEditable = false
        tv.font = .systemFont(ofSize: 15)
        tv.textContainerInset = UIEdgeInsets(top: 1.5, left: 0, bottom: 7, right: 0)
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
        label.font = .boldSystemFont(ofSize: 16)
        label.isUserInteractionEnabled = true
        label.textColor = .white
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
    
    let mediaImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitterDarkBlue()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.twitterDarkBlue().cgColor
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let videoPlayerView: UIView = {
        let videoView = UIView()
        videoView.layer.masksToBounds = true
        videoView.layer.cornerRadius = 10
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.backgroundColor = .clear
        videoView.isUserInteractionEnabled = true
        return videoView
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
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitterLightBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
    
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
            
            if videoPlayerItem == nil {
                activityIndicator.stopAnimating()
            } else {
                activityIndicator.startAnimating()
            }
        }
    }
    
    var tweet: TwitterTweet? {
        didSet {
            setData()
        }
    }
    
    var viewController: UIViewController?
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    
    var videoHeightConstraint: NSLayoutConstraint?
    var videoPlayerTopAnchor: NSLayoutConstraint?
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
        contentView.addSubview(mediaImageView)
        contentView.addSubview(videoPlayerView)
        
        isReplyView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        isReplyView.bottomAnchor.constraint(equalTo: profilePicImageView.centerYAnchor).isActive = true
        isReplyView.centerXAnchor.constraint(equalTo: profilePicImageView.centerXAnchor).isActive = true
        isReplyView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        hasReplyView.topAnchor.constraint(equalTo: profilePicImageView.centerYAnchor).isActive = true
        hasReplyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        hasReplyView.centerXAnchor.constraint(equalTo: profilePicImageView.centerXAnchor).isActive = true
        hasReplyView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        videoPlayerView.addSubview(activityIndicator)
        
        retweetedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        retweetedLabel.leftAnchor.constraint(equalTo: profilePicImageView.rightAnchor, constant: 10).isActive = true
        
        replyingToLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3).isActive = true
        replyingToLabel.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor).isActive = true
        
        profilePicImageView.anchor(retweetedLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        textView.anchor(nil, left: profilePicImageView.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        usernameLabel.topAnchor.constraint(equalTo: retweetedLabel.bottomAnchor, constant: 5).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        
        videoPlayerView.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        videoPlayerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        videoPlayerTopAnchor = videoPlayerView.topAnchor.constraint(equalTo: textView.bottomAnchor)
        videoPlayerTopAnchor?.isActive = true
        videoHeightConstraint = videoPlayerView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 100) / (16/9))
        videoHeightConstraint?.isActive = true
        
        mediaImageView.anchor(videoPlayerView.topAnchor, left: videoPlayerView.leftAnchor, bottom: videoPlayerView.bottomAnchor, right: videoPlayerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        retweetCountLabel.topAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: 10).isActive = true
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
        
        activityIndicator.centerXAnchor.constraint(equalTo: videoPlayerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: videoPlayerView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        let profilePicTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        usernameLabel.addGestureRecognizer(nameTap)
        profilePicImageView.addGestureRecognizer(profilePicTap)
        
        setupVideoPlayer()
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
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        videoPlayerTopAnchor?.isActive = false
        if text != "" {
            videoPlayerTopAnchor = videoPlayerView.topAnchor.constraint(equalTo: textView.bottomAnchor)
            videoPlayerTopAnchor?.isActive = true
        } else {
            videoPlayerTopAnchor = videoPlayerView.topAnchor.constraint(equalTo: textView.topAnchor, constant: 10)
            videoPlayerTopAnchor?.isActive = true
        }

        textView.attributedText = HelperFunctions.getTwitterText(text: text)
        
        videoPlayerItem = nil
        mediaImageView.image = nil
        if tweet.media?[0].type == "video" || tweet.media?[0].type == "animated_gif" {
            videoPlayerView.isHidden = false
            mediaImageView.isHidden = false
            
            if let mediaUrl = tweet.media?[0].mediaUrl {
                mediaImageView.loadImageUsingUrlString(urlString: mediaUrl as NSString)
            }
            
            if let mediaUrl = tweet.media?[0].url, let url = URL(string: mediaUrl) {
                videoPlayerItem = AVPlayerItem(url: url)
                avPlayer?.play()
            }
        } else if tweet.media?[0].type == "photo" {
            let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            mediaImageView.addGestureRecognizer(pictureTap)
            
            videoPlayerView.isHidden = true
            mediaImageView.isHidden = false
            if let mediaUrl = tweet.media?[0].url {
                mediaImageView.loadImageUsingUrlString(urlString: mediaUrl as NSString)
            }
        } else {
            videoPlayerView.isHidden = true
            mediaImageView.isHidden = true
        }
        
        let width = tweet.media?[0].dimensions?[0] ?? 16
        let height = tweet.media?[0].dimensions?[1] ?? 9
        
        videoHeightConstraint?.constant = (UIScreen.main.bounds.width - 100) * CGFloat(height) / CGFloat(width)
        avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 100), height: (UIScreen.main.bounds.width - 100) * CGFloat(height) / CGFloat(width))
        
        layoutIfNeeded()
    }
    
    func setupVideoPlayer() {
        self.avPlayer = AVPlayer(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = .resizeAspect
        avPlayer?.volume = 0
        avPlayer?.actionAtItemEnd = .none
        
        videoPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoTapped)))
        
        avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 100) / (16/9), height: (UIScreen.main.bounds.width - 100) / (9/16))
        self.videoPlayerView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem)
        
        avPlayer?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === avPlayer {
            if keyPath == "status" {
                if avPlayer?.status == .readyToPlay {
                    avPlayer?.play()
                }
            } else if keyPath == "timeControlStatus" {
                if avPlayer?.timeControlStatus == .playing {
                    if activityIndicator.isAnimating {
                        activityIndicator.stopAnimating()
                    }
                }
            }
        }
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
    
    @objc private func videoTapped() {
        print("video tapped")
        if tweet?.media?[0].type == "video" || tweet?.media?[0].type == "animated_gif" {
            if let urlString = tweet?.media?[0].url, let url = URL(string: urlString) {
                let videoController = AVPlayerViewController()
                videoController.player = AVPlayer(url: url)
                videoController.player?.automaticallyWaitsToMinimizeStalling = false
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print(error)
                }

                videoController.modalPresentationStyle = .overFullScreen
                viewController?.present(videoController, animated: true) {
                    videoController.player?.playImmediately(atRate: 1.0)
                }
            }
        }
    }
    
    func startPlayback() {
        avPlayer?.play()
    }
    
    func stopPlayback() {
        avPlayer?.pause()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: .zero, completionHandler: nil)
    }
    
    @objc func profileTapped() {
        let profileController = TwitterProfileViewController()
        profileController.userJson = tweet?.user
        
        viewController?.present(profileController, animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        var urlString = URL.absoluteString
        
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
