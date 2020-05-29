//
//  TwitterQuoteCell.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/25/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AVKit
import NVActivityIndicatorView

class TwitterQuoteCell: UITableViewCell, UITextViewDelegate {
    
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
    
    let mediaView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterDarkBlue()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.twitterGrayText().withAlphaComponent(0.2).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitterLightBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let quoteView: TwitterQuoteView = {
        let view = TwitterQuoteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avPlayerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer()
        layer.videoGravity = .resizeAspect
        layer.player = nil
        return layer
    }()
    
    let thumbnailImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.isHidden = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
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
            guard let tweet = tweet else { return }
            setData(tweet: tweet)
        }
    }
    
    var viewController: UIViewController?
    
    var mediaViewHeightConstraint: NSLayoutConstraint?
    var mediaViewBottomConstraint: NSLayoutConstraint?
    var mediaViewTopAnchor: NSLayoutConstraint?
    
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
        contentView.addSubview(retweetCountLabel)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(textView)
        contentView.addSubview(quoteView)
        contentView.addSubview(mediaView)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(activityIndicator)
        
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
        
        profilePicImageView.anchor(retweetedLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        
        usernameLabel.topAnchor.constraint(equalTo: retweetedLabel.bottomAnchor, constant: 5).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        
        textView.anchor(usernameLabel.bottomAnchor, left: profilePicImageView.rightAnchor, bottom: mediaView.topAnchor, right: contentView.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 7.5, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        mediaView.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        mediaView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 100).isActive = true
        mediaViewTopAnchor = mediaView.topAnchor.constraint(equalTo: textView.bottomAnchor)
        mediaViewBottomConstraint = mediaView.bottomAnchor.constraint(equalTo: quoteView.topAnchor, constant: -5)
        mediaViewHeightConstraint = mediaView.heightAnchor.constraint(equalToConstant: 0)
        mediaViewTopAnchor?.isActive = true
        mediaViewHeightConstraint?.isActive = true
        mediaViewBottomConstraint?.isActive = true
        
        thumbnailImageView.anchor(mediaView.topAnchor, left: mediaView.leftAnchor, bottom: mediaView.bottomAnchor, right: mediaView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        quoteView.topAnchor.constraint(equalTo: mediaView.bottomAnchor).isActive = true
        quoteView.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        quoteView.bottomAnchor.constraint(equalTo: retweetCountLabel.topAnchor, constant: -5).isActive = true
        quoteView.rightAnchor.constraint(equalTo: textView.rightAnchor).isActive = true
        quoteView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        retweetCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        retweetCountLabel.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        retweetCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        retweetCountLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true

        likeCountLabel.centerYAnchor.constraint(equalTo: retweetCountLabel.centerYAnchor).isActive = true
        likeCountLabel.leftAnchor.constraint(equalTo: retweetCountLabel.rightAnchor).isActive = true
        likeCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeCountLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: mediaView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: mediaView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true

        dateLabel.centerYAnchor.constraint(equalTo: retweetCountLabel.centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: likeCountLabel.rightAnchor).isActive = true
        
        avPlayerLayer.frame = mediaView.bounds
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        let profilePicTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        usernameLabel.addGestureRecognizer(nameTap)
        profilePicImageView.addGestureRecognizer(profilePicTap)

        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        avPlayerLayer.frame = mediaView.bounds
    }
    
    private func setData(tweet: TwitterTweet) {
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
        
        if let medias = tweet.media {
            for media in medias {
                text = text.replacingOccurrences(of: media.displayUrl, with: "")
            }
        }
        
        if let quoteTweetDisplayUrl = tweet.quoteTweet?.displayUrl {
            text = text.replacingOccurrences(of: quoteTweetDisplayUrl, with: "")
        }
        
        if let urls = tweet.urls?.array {
            for url in urls {
                text = text.replacingOccurrences(of: url["url"].stringValue, with: url["display_url"].stringValue)
            }
        }
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        mediaViewTopAnchor?.isActive = false
        if text != "" {
            mediaViewTopAnchor = mediaView.topAnchor.constraint(equalTo: textView.bottomAnchor)
            mediaViewTopAnchor?.isActive = true
        } else {
            mediaViewTopAnchor = mediaView.topAnchor.constraint(equalTo: textView.topAnchor, constant: 10)
            mediaViewTopAnchor?.isActive = true
        }
        
        textView.attributedText = HelperFunctions.getTwitterText(text: text)
        
        avPlayerLayer.player = nil
        thumbnailImageView.image = nil
        
        if let media = tweet.media {
            let width = media[0].dimensions?[0] ?? 16
            let height = media[0].dimensions?[1] ?? 9

            let heightConstant = (UIScreen.main.bounds.size.width - 100) * (CGFloat(height) / CGFloat(width))
            
            mediaViewHeightConstraint?.constant = heightConstant
            mediaViewBottomConstraint?.constant = -10
                
            mediaView.layoutIfNeeded()
            layoutIfNeeded()
            
            setupMedia(tweetMedia: media)
        } else {
            activityIndicator.stopAnimating()
            mediaView.subviews.forEach({ $0.removeFromSuperview() })
            mediaViewHeightConstraint?.constant = 0
            mediaViewBottomConstraint?.constant = 0
            mediaView.layoutIfNeeded()
            layoutIfNeeded()
        }
    }
    
    private func setupMedia(tweetMedia: [TwitterMedia]) {
        mediaView.subviews.forEach({ $0.removeFromSuperview() })
        
        
        mediaView.layoutIfNeeded()
        layoutIfNeeded()

        if tweetMedia[0].type == "video" || tweetMedia[0].type == "animated_gif" {
            guard let url = URL(string: tweetMedia[0].url) else { return }
            
            if let thumbnailUrl = tweetMedia[0].mediaUrl {
                thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailUrl as NSString)
                thumbnailImageView.isHidden = false
            }
            
            activityIndicator.startAnimating()
            
            let avPlayer = AVPlayer(url: url)
            avPlayer.volume = 0
            avPlayer.actionAtItemEnd = .none
            
            avPlayerLayer.player = avPlayer
            
            self.mediaView.layer.insertSublayer(avPlayerLayer, at: 0)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayerLayer.player?.currentItem)
        
            avPlayer.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
            avPlayer.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        } else {
            activityIndicator.stopAnimating()
            thumbnailImageView.image = nil
            
            setupPictures(twitterPics: tweetMedia)
        }
        
        let mediaTap = UITapGestureRecognizer(target: self, action: #selector(presentMedia))
        mediaView.addGestureRecognizer(mediaTap)
        mediaView.isUserInteractionEnabled = true
    }
    
    private func setupPictures(twitterPics: [TwitterMedia]) {
        
        switch twitterPics.count {
        case 1:
            handleOnePicture(tweetMedia: twitterPics)
        case 2:
            handleTwoPictures(tweetMedia: twitterPics)
        case 3:
            handleThreePictures(tweetMedia: twitterPics)
        case 4:
            handleFourPictures(tweetMedia: twitterPics)
        default:
            handleOnePicture(tweetMedia: twitterPics)
        }
        
        mediaView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    private func handleOnePicture(tweetMedia: [TwitterMedia]) {
        let imageView = AsyncImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        mediaView.addSubview(imageView)
        
        imageView.anchor(mediaView.topAnchor, left: mediaView.leftAnchor, bottom: mediaView.bottomAnchor, right: mediaView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageView.loadImageUsingUrlString(urlString: tweetMedia[0].url as NSString)
        
        layoutIfNeeded()
    }
    
    private func handleTwoPictures(tweetMedia: [TwitterMedia]) {
        let imageView1 = AsyncImageView()
        let imageView2 = AsyncImageView()
        
        let imageViews = [imageView1, imageView2]
        
        for imageView in imageViews {
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            mediaView.addSubview(imageView)
        }
        
        imageView1.anchor(mediaView.topAnchor, left: mediaView.leftAnchor, bottom: mediaView.bottomAnchor, right: mediaView.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        imageView2.anchor(mediaView.topAnchor, left: mediaView.centerXAnchor, bottom: mediaView.bottomAnchor, right: mediaView.rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageView1.loadImageUsingUrlString(urlString: tweetMedia[0].url as NSString)
        imageView2.loadImageUsingUrlString(urlString: tweetMedia[1].url as NSString)
        
        layoutIfNeeded()
    }
    
    private func handleThreePictures(tweetMedia: [TwitterMedia]) {
        let imageView1 = AsyncImageView()
        let imageView2 = AsyncImageView()
        let imageView3 = AsyncImageView()
        
        let imageViews = [imageView1, imageView2, imageView3]
        
        for imageView in imageViews {
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            mediaView.addSubview(imageView)
        }
        
        imageView1.anchor(mediaView.topAnchor, left: mediaView.leftAnchor, bottom: mediaView.bottomAnchor, right: mediaView.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        imageView2.anchor(mediaView.topAnchor, left: mediaView.centerXAnchor, bottom: mediaView.centerYAnchor, right: mediaView.rightAnchor, topConstant: 0, leftConstant: 2.5, bottomConstant: 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        imageView3.anchor(mediaView.centerYAnchor, left: mediaView.centerXAnchor, bottom: mediaView.bottomAnchor, right: mediaView.rightAnchor, topConstant: 2.5, leftConstant: 2.5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        imageView1.loadImageUsingUrlString(urlString: tweetMedia[0].url as NSString)
        imageView2.loadImageUsingUrlString(urlString: tweetMedia[1].url as NSString)
        imageView3.loadImageUsingUrlString(urlString: tweetMedia[2].url as NSString)
        
        layoutIfNeeded()
    }
    
    private func handleFourPictures(tweetMedia: [TwitterMedia]) {
        let imageView1 = AsyncImageView()
        let imageView2 = AsyncImageView()
        let imageView3 = AsyncImageView()
        let imageView4 = AsyncImageView()
        
        let imageViews = [imageView1, imageView2, imageView3, imageView4]
        
        for imageView in imageViews {
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            mediaView.addSubview(imageView)
        }
        
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === avPlayerLayer.player {
            if keyPath == "status" {
                if avPlayerLayer.player?.status == .readyToPlay {
                    avPlayerLayer.player?.play()
                }
            } else if keyPath == "timeControlStatus" {
                if avPlayerLayer.player?.timeControlStatus == .playing {
                    
                    if avPlayerLayer.frame != mediaView.bounds {
                        avPlayerLayer.frame = mediaView.bounds
                        layoutIfNeeded()
                    }
                    
                    if activityIndicator.isAnimating {
                        activityIndicator.stopAnimating()
                    }
                    
                    thumbnailImageView.isHidden = true
                } else {
                    activityIndicator.startAnimating()
                }
            }
        }
    }
    
    @objc private func presentMedia() {
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
        } else if tweet?.media?[0].type == "photo" {
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
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: .zero, completionHandler: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
