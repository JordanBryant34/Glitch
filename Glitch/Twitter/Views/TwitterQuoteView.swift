//
//  TwitterQuoteView.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/25/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AVKit
import NVActivityIndicatorView

class TwitterQuoteView: UIView, UITextViewDelegate {
    
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
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        tv.textContainer.lineFragmentPadding = 0
        tv.dataDetectorTypes = .link
        return tv
    }()
    
    let profilePicImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .red
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let mediaView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterDarkBlue()
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
        return imageView
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitterLightBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let mediaSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.twitterGrayText().withAlphaComponent(0.2)
        return view
    }()
    
    var quoteTweet: TwitterQuoteTweet? = nil {
        didSet {
            guard let quoteTweet = quoteTweet else { return }
            setupQuoteTweet(quoteTweet: quoteTweet)
        }
    }
    
    var viewController: UIViewController?
    var mediaViewHeightConstraint: NSLayoutConstraint?
    var mediaViewTopAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView.delegate = self
        
        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor.twitterGrayText().withAlphaComponent(0.2).cgColor
        layer.borderWidth = 0.5
        
        isUserInteractionEnabled = true
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(profilePicImageView)
        addSubview(nameLabel)
        addSubview(textView)
        addSubview(mediaView)
        addSubview(mediaSeparatorView)
        addSubview(thumbnailImageView)
        addSubview(activityIndicator)
        
        profilePicImageView.anchor(topAnchor, left: leftAnchor, bottom: textView.topAnchor, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        nameLabel.anchor(profilePicImageView.topAnchor, left: profilePicImageView.rightAnchor, bottom: profilePicImageView.bottomAnchor, right: textView.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        textView.anchor(profilePicImageView.bottomAnchor, left: leftAnchor, bottom: mediaView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        mediaView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mediaView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 100).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mediaViewTopAnchor = mediaView.topAnchor.constraint(equalTo: textView.bottomAnchor)
        mediaViewHeightConstraint = mediaView.heightAnchor.constraint(equalToConstant: 0)
        mediaViewTopAnchor?.isActive = true
        mediaViewHeightConstraint?.isActive = true
        
        mediaSeparatorView.anchor(nil, left: leftAnchor, bottom: mediaView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        thumbnailImageView.anchor(mediaView.topAnchor, left: mediaView.leftAnchor, bottom: mediaView.bottomAnchor, right: mediaView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: mediaView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: mediaView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1).isActive = true
                
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        let profilePicTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        let viewTapped = UITapGestureRecognizer(target: self, action: #selector(tweetTapped))
        addGestureRecognizer(viewTapped)
        nameLabel.addGestureRecognizer(nameTap)
        profilePicImageView.addGestureRecognizer(profilePicTap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if quoteTweet?.media?[0].type == "video" || quoteTweet?.media?[0].type == "animated_gif" {
            avPlayerLayer.frame = mediaView.bounds
            mediaView.layoutIfNeeded()
            layoutIfNeeded()
        }
    }
    
    private func setupQuoteTweet(quoteTweet: TwitterQuoteTweet) {
        var text = quoteTweet.text
        
        profilePicImageView.loadImageUsingUrlString(urlString: quoteTweet.profilePicUrl as NSString)
        
        nameLabel.attributedText = HelperFunctions.getTwitterUsernameString(username: quoteTweet.username, displayName: quoteTweet.displayName, verified: quoteTweet.verified, fontSize: 16, blueCheckSize: 15)
        
        if let medias = quoteTweet.media {
            for media in medias {
                text = text.replacingOccurrences(of: media.displayUrl, with: "")
            }
        }
        
        if let urls = quoteTweet.urls?.array {
            for url in urls {
                text = text.replacingOccurrences(of: url["url"].stringValue, with: url["display_url"].stringValue)
            }
        }
        
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
        
        if let media = quoteTweet.media {
            mediaSeparatorView.isHidden = false
            
            let width = media[0].dimensions?[0] ?? 16
            let height = media[0].dimensions?[1] ?? 9

            mediaViewHeightConstraint?.constant = (UIScreen.main.bounds.size.width - 100) * (CGFloat(height) / CGFloat(width))
            mediaView.layoutIfNeeded()
            layoutIfNeeded()
            
            setupMedia(tweetMedia: media)
        } else {
            activityIndicator.stopAnimating()
            mediaSeparatorView.isHidden = true
            mediaView.subviews.forEach({ $0.removeFromSuperview() })
            mediaViewHeightConstraint?.constant = 0
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
                    activityIndicator.stopAnimating()
                    thumbnailImageView.isHidden = true
                } else {
                    activityIndicator.startAnimating()
                }
            }
        }
    }
    
    @objc private func presentMedia() {
        if quoteTweet?.media?[0].type == "video" || quoteTweet?.media?[0].type == "animated_gif" {
            if let urlString = quoteTweet?.media?[0].url, let url = URL(string: urlString) {
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
        } else if quoteTweet?.media?[0].type == "photo" {
            guard let tweetMedia = quoteTweet?.media else { return }
        
            let imageViewer = TwitterImageViewerController()
            imageViewer.media = tweetMedia
            imageViewer.modalPresentationStyle = .overFullScreen
        
            viewController?.present(imageViewer, animated: true, completion: nil)
        }
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
    
    @objc func profileTapped() {
        let profileController = TwitterProfileViewController()
        profileController.userJson = quoteTweet?.user
        
        viewController?.present(profileController, animated: true, completion: nil)
    }
    
    @objc func tweetTapped() {
        let threadController = TwitterThreadViewController()
        threadController.tweetId = quoteTweet?.id
        
        viewController?.present(threadController, animated: true, completion: nil)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: .zero, completionHandler: nil)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
