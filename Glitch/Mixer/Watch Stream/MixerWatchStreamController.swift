//
//  MixerWatchStreamController.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/13/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import WebKit
import AVKit
import GoogleMobileAds

class MixerWatchStreamController: UIViewController {
    
    let chatWebView: WKWebView = {
        let config = WKWebViewConfiguration()
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.scrollView.bounces = false
        wv.isOpaque = false
        return wv
    }()
    
    let chatBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .mixerDarkBlue()
        return view
    }()
    
    let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .mixerDarkBlue()
        return view
    }()
    
    let streamerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profilePicImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.mixerLightBlue().cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .mixerGrayTextColor()
        view.alpha = 0.1
        return view
    }()
    
    let adsAlertView: AdsAlertView = {
        let view = AdsAlertView()
        view.alertView.backgroundColor = .mixerDarkBlue()
        view.alertView.layer.borderColor = UIColor.mixerLightBlue().cgColor
        view.imageView.contentMode = .scaleToFill
        view.imageView.image = UIImage(named: "mixerLogoLarge")
        view.imageView.contentMode = .scaleAspectFit
        view.titleLabel.text = "Sorry for the interruption"
        view.detailsLabel.text = "Watch a short ad in order to view this stream?"
        view.detailsLabel.textColor = .mixerGrayTextColor()
        view.confirmButton.setTitle("Watch ad", for: .normal)
        view.cancelButton.setTitle("No thanks", for: .normal)
        view.confirmButton.backgroundColor = .mixerLightBlue()
        view.cancelButton.backgroundColor = .mixerLightBlue()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var stream: MixerStream?
    var contentCount: Int = 0
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    let avController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler))
        view.addGestureRecognizer(pan)
        
        adsAlertView.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        adsAlertView.confirmButton.addTarget(self, action: #selector(watchAdPressed), for: .touchUpInside)
        
        setupViews()
        setupChat()
        setupStreamVideo()
        
        contentCount = UserDefaults.standard.integer(forKey: "contentWatchedCount")
        
        if contentCount < 2 {
            UserDefaults.standard.set(contentCount + 1, forKey: "contentWatchedCount")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (contentCount >= 2) && (UserDefaults.standard.integer(forKey: "contentWatchedCount") >= 2) {
            avController.player?.pause()
            adsAlertView.show()
        } else {
            avController.player?.play()
        }
    }
    
    private func setupViews() {
        view.addSubview(statusBarView)
        view.addSubview(avController.view)
        view.addSubview(chatBackgroundView)
        view.addSubview(streamerView)
        view.addSubview(chatWebView)
        view.addSubview(adsAlertView)
        
        streamerView.addSubview(profilePicImageView)
        streamerView.addSubview(nameLabel)
        streamerView.addSubview(separatorView)
        
        adsAlertView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        statusBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UIApplication.shared.windows[0].safeAreaInsets.top)
        avController.view.anchor(statusBarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.width / (16/9))
        streamerView.anchor(avController.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        chatBackgroundView.anchor(avController.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        chatWebView.anchor(streamerView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        profilePicImageView.centerYAnchor.constraint(equalTo: streamerView.centerYAnchor).isActive = true
        profilePicImageView.leftAnchor.constraint(equalTo: streamerView.leftAnchor, constant: 10).isActive = true
        profilePicImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profilePicImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true

        nameLabel.centerYAnchor.constraint(equalTo: profilePicImageView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profilePicImageView.rightAnchor, constant: 10).isActive = true
        
        separatorView.anchor(nil, left: streamerView.leftAnchor, bottom: streamerView.bottomAnchor, right: streamerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        if let profilePicUrl = stream?.profilePicUrl {
            profilePicImageView.loadImageUsingUrlString(urlString: profilePicUrl as NSString)
        }
        
        nameLabel.text = stream?.streamerName ?? ""
    }
    
    private func setupStreamVideo() {
        let url = "https://mixer.com/api/v1/channels/\(stream?.channelId ?? "")/manifest.m3u8"

        let player = AVPlayer(url: URL(string: url)!)
        avController.player = player
        self.addChild(avController)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        player.play()
    }
    
    private func setupChat() {
        let url = URL(string: "https://mixer.com/embed/chat/\(stream?.channelId ?? "")?composer=false")
        let request = URLRequest(url: url!)
        chatWebView.load(request)
        
        let source: String = "var meta = document.createElement('meta');" +
        "meta.name = 'viewport';" +
        "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
        "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
        
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        chatWebView.configuration.userContentController.addUserScript(script)
    }
    
    @objc private func watchAdPressed() {
        adsAlertView.hide()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.rewardAdInstance.isReady {
            appDelegate.rewardAdInstance.present(fromRootViewController: self)
        } else {
            UserDefaults.standard.set(0, forKey: "contentWatchedCount")
            appDelegate.rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()
            appDelegate.rewardAdInstance.load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        }
    }
    
    @objc private func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        if adsAlertView.isShown == false {
            let touchPoint = sender.location(in: self.view?.window)

            if sender.state == UIGestureRecognizer.State.began {
                initialTouchPoint = touchPoint
            } else if sender.state == UIGestureRecognizer.State.changed {
                statusBarView.backgroundColor = .clear
                if touchPoint.y - initialTouchPoint.y > 0 {
                    self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
            } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
                if touchPoint.y > view.frame.height * 0.7 {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.statusBarView.backgroundColor = .mixerDarkBlue()
                        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    })
                }
            }
        }
    }
}
