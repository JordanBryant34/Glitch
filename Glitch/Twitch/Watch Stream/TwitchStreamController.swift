//
//  TwitchStreamController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/26/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView
import GoogleMobileAds
import Purchases

class TwitchStreamController: UIViewController, WKNavigationDelegate, GADRewardBasedVideoAdDelegate {
    
    let streamWebView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.backgroundColor = .black
        wv.scrollView.bounces = false
        wv.isOpaque = false
        wv.scrollView.pinchGestureRecognizer?.isEnabled = false
        wv.scrollView.showsHorizontalScrollIndicator = false
        wv.isHidden = false
        return wv
    }()
    
    let chatWebView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.scrollView.bounces = false
        wv.isOpaque = false
        wv.scrollView.pinchGestureRecognizer?.isEnabled = false
        wv.scrollView.showsHorizontalScrollIndicator = false
        wv.isHidden = false
        return wv
    }()
    
    let streamerInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchLightGray()
        return view
    }()
    
    let streamerImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = .twitchGray()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.twitchPurple().cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let streamerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 17.5)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.twitchGrayTextColor().withAlphaComponent(0.1)
        return view
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchGray()
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitchPurple(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let adsAlertView: AdsAlertView = {
        let view = AdsAlertView()
        view.alertView.backgroundColor = .twitchLightGray()
        view.alertView.layer.borderColor = UIColor.twitchPurple().cgColor
        view.imageView.contentMode = .scaleToFill
        view.imageView.image = UIImage(named: "twitchLogoLarge")
        view.imageView.contentMode = .scaleAspectFit
        view.titleLabel.text = "Sorry for the interruption"
        view.detailsLabel.text = "Watch a short ad in order to view this stream?"
        view.detailsLabel.textColor = .twitchGrayTextColor()
        view.confirmButton.setTitle("Watch ad", for: .normal)
        view.cancelButton.setTitle("No thanks", for: .normal)
        view.confirmButton.backgroundColor = .twitchPurple()
        view.cancelButton.backgroundColor = .twitchPurple()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .twitchPurple()
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3
        button.isHidden = true
        return button
    }()
    
    let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchGray()
        return view
    }()
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var contentCount: Int = 0
    var streamerName: String?
    var streamerImageUrl: String?
    let adInstance = GADRewardBasedVideoAd.sharedInstance()
    var adWatched = false
    
    let source: String = "var meta = document.createElement('meta');" +
                         "meta.name = 'viewport';" +
                         "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                         "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streamWebView.navigationDelegate = self
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler))
        view.addGestureRecognizer(pan)
        
        adsAlertView.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        adsAlertView.confirmButton.addTarget(self, action: #selector(watchAdPressed), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(handleFollowPressed), for: .touchUpInside)
        
        setupViews()
        
        contentCount = UserDefaults.standard.integer(forKey: "contentWatchedCount")

        if contentCount < 2 {
            setupStream()
            UserDefaults.standard.set(contentCount + 1, forKey: "contentWatchedCount")
        }

        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print("Error with purchaser info in twitch stream controller: \(error.localizedDescription)")
            }

            if purchaserInfo?.entitlements["remove-ads"]?.isActive == true && self.contentCount >= 2{
                self.setupStream()
            }
        }
        
        activityIndicator.startAnimating()
        getStreamerPic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (contentCount >= 2) && (UserDefaults.standard.integer(forKey: "contentWatchedCount") >= 2) {
            Purchases.shared.purchaserInfo { (purchaserInfo, error) in
                if let error = error {
                    print("Error with purchaser info in twitch stream controller: \(error.localizedDescription)")
                }

                if purchaserInfo?.entitlements["remove-ads"]?.isActive != true {
                    self.adsAlertView.show()
                }
            }
        } else if adWatched == true {
            adWatched = false
            setupStream()
            present(SubscriptionViewController(), animated: true, completion: nil)
        }
    }
    
    private func setupStream() {
        if let streamer = streamerName?.lowercased().replacingOccurrences(of: " ", with: "") {
            let url = URL(string: "https://player.twitch.tv/?channel=\(streamer)&enableExtensions=false&muted=false&parent=twitch.tv&player=popout&volume=1")!
            let urlRequest = URLRequest(url: url)
            let chatUrl = URL(string: "https://nightdev.com/hosted/obschat/?channel=\(streamer)")!
            let chatUrlRequest = URLRequest(url: chatUrl)
            
            streamWebView.load(urlRequest)
            chatWebView.load(chatUrlRequest)
            
            let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            
            streamWebView.configuration.userContentController.addUserScript(script)
            streamWebView.scrollView.contentInsetAdjustmentBehavior = .never
            chatWebView.configuration.userContentController.addUserScript(script)
            chatWebView.scrollView.contentInsetAdjustmentBehavior = .never
            
            checkFollows(streamer: streamer)
        }
    }
    
    private func getStreamerPic() {
        if let imageUrl = streamerImageUrl {
            streamerImageView.loadImageUsingUrlString(urlString: imageUrl as NSString)
        } else if let _ = UserDefaults.standard.string(forKey: "twitchAccessToken"), let streamerName = streamerName {
            TwitchService.getStreamerPicture(streamerName: streamerName) { (picUrl) in
                if let url = picUrl {
                    if picUrl != "" {
                        self.streamerImageView.loadImageUsingUrlString(urlString: url as NSString)
                    } else {
                        self.streamerImageView.image = UIImage(named: "streamerDefault")
                    }
                } else {
                    self.streamerImageView.image = UIImage(named: "streamerDefault")
                }
            }
        } else {
            streamerImageView.image = UIImage(named: "streamerDefault")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(statusBarView)
        view.addSubview(activityIndicator)
        view.addSubview(chatWebView)
        view.addSubview(streamerInfoView)
        view.addSubview(streamWebView)
        view.addSubview(adsAlertView)
        
        streamerInfoView.addSubview(separatorView)
        streamerInfoView.addSubview(streamerImageView)
        streamerInfoView.addSubview(streamerNameLabel)
        streamerInfoView.addSubview(followButton)
        
        backgroundView.anchor(statusBarView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        streamWebView.anchor(statusBarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.width * (9/16))
        streamerInfoView.anchor(streamWebView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 90)
        separatorView.anchor(nil, left: view.leftAnchor, bottom: streamerInfoView.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        chatWebView.anchor(streamerInfoView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: -5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        adsAlertView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        streamerNameLabel.anchor(streamerInfoView.topAnchor, left: streamerImageView.rightAnchor, bottom: streamerInfoView.bottomAnchor, right: followButton.leftAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        followButton.anchor(streamerInfoView.topAnchor, left: nil, bottom: streamerInfoView.bottomAnchor, right: streamerInfoView.rightAnchor, topConstant: 27.5, leftConstant: 0, bottomConstant: 27.5, rightConstant: 15, widthConstant: 110, heightConstant: 0)
        statusBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UIApplication.shared.windows[0].safeAreaInsets.top)
        
        activityIndicator.centerXAnchor.constraint(equalTo: chatWebView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: chatWebView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        
        streamerImageView.centerYAnchor.constraint(equalTo: streamerInfoView.centerYAnchor).isActive = true
        streamerImageView.leftAnchor.constraint(equalTo: streamerInfoView.leftAnchor, constant: 15).isActive = true
        streamerImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        streamerImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        streamerNameLabel.text = streamerName ?? ""
    }
    
    @objc private func watchAdPressed() {
        adsAlertView.hide()
        adWatched = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.rewardAdInstance.isReady {
            appDelegate.rewardAdInstance.present(fromRootViewController: self)
        } else {
            UserDefaults.standard.set(0, forKey: "contentWatchedCount")
            appDelegate.rewardAdInstance = GADRewardBasedVideoAd.sharedInstance()
            appDelegate.rewardAdInstance.load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
            
        }
    }
    
    @objc private func handleFollowPressed() {
        if followButton.titleLabel?.text == "Follow", let streamer = streamerName {
            let alertController = UIAlertController(title: "Follow \(streamer)?", message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Follow", style: .default, handler: { (action) in
                TwitchService.handleFollowAndUnfollow(streamer: streamer.lowercased(), httpMethod: .post) { (success) in
                    if success == true {
                        self.followButton.setTitle("Following", for: .normal)
                        self.followButton.backgroundColor = .twitchGray()
                    }
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        } else if followButton.titleLabel?.text == "Following", let streamer = streamerName {
            let alertController = UIAlertController(title: "Unfollow \(streamer)?", message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Unfollow", style: .destructive, handler: { (action) in
                TwitchService.handleFollowAndUnfollow(streamer: streamer.lowercased(), httpMethod: .delete) { (success) in
                    if success == true {
                        self.followButton.setTitle("Follow", for: .normal)
                        self.followButton.backgroundColor = .twitchPurple()
                    }
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func checkFollows(streamer: String) {
        if let _ = UserDefaults.standard.string(forKey: "twitchAccessToken") {
            TwitchService.getFollowedStreamers { (streamers) in
                self.followButton.setTitle("Follow", for: .normal)
                self.followButton.backgroundColor = .twitchPurple()
                for twitchStreamer in streamers {
                    if twitchStreamer.name.lowercased() == streamer {
                        self.followButton.setTitle("Following", for: .normal)
                        self.followButton.backgroundColor = .twitchGray()
                    }
                }
                
                self.followButton.isHidden = false
            }
        }
    }
    
    @objc private func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        setupStream()
        UserDefaults.standard.set(0, forKey: "contentWatchedCount")
        present(SubscriptionViewController(), animated: true, completion: nil)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        setupStream()
        UserDefaults.standard.set(0, forKey: "contentWatchedCount")
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
                        self.statusBarView.backgroundColor = .twitchGray()
                        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    })
                }
            }
        }
    }
}
