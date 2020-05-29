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

class TwitchStreamController: UIViewController, WKNavigationDelegate, GADRewardBasedVideoAdDelegate {
    
    let videoWebView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.scrollView.bounces = false
        wv.isOpaque = false
        wv.scrollView.pinchGestureRecognizer?.isEnabled = false
        wv.scrollView.showsHorizontalScrollIndicator = false
        wv.isHidden = true
        return wv
    }()
    
    let chatWebView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.scrollView.bounces = false
        wv.isOpaque = false
        wv.scrollView.pinchGestureRecognizer?.isEnabled = false
        wv.scrollView.showsHorizontalScrollIndicator = false
        wv.isUserInteractionEnabled = false
        wv.isHidden = true
        return wv
    }()
    
    let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchGray()
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
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var contentCount: Int = 0
    var streamerName: String?
    let adInstance = GADRewardBasedVideoAd.sharedInstance()
    var adWatched = false
    
    let source: String = "var meta = document.createElement('meta');" +
                         "meta.name = 'viewport';" +
                         "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                         "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoWebView.navigationDelegate = self
        chatWebView.navigationDelegate = self
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler))
        view.addGestureRecognizer(pan)
        
        adsAlertView.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        adsAlertView.confirmButton.addTarget(self, action: #selector(watchAdPressed), for: .touchUpInside)
        
        setupViews()
        setupChat()
        
        contentCount = UserDefaults.standard.integer(forKey: "contentWatchedCount")
        
        if contentCount < 2 {
            setupStreamVideo()
            UserDefaults.standard.set(contentCount + 1, forKey: "contentWatchedCount")
        }
        
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (contentCount >= 2) && (UserDefaults.standard.integer(forKey: "contentWatchedCount") >= 2) {
            adsAlertView.show()
        } else if adWatched == true {
            setupStreamVideo()
        }
    }
    
    private func setupStreamVideo() {
        if let streamer = streamerName {
            let videoHtmlString = """
                <iframe
                    src = "https://player.twitch.tv/?channel=\(streamer)"
                    height = "\(UIScreen.main.bounds.width * (9/16))"
                    width = "\(UIScreen.main.bounds.width)"
                    frameborder = "0"
                    scrolling = "no"
                    allowfullscreen = "true">
                </iframe>
            """
            
            let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            
            videoWebView.loadHTMLString(videoHtmlString, baseURL: nil)
            videoWebView.configuration.userContentController.addUserScript(script)
            videoWebView.scrollView.contentInset = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            videoWebView.scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func setupChat() {
        var heightOffset: CGFloat = 25
        if UIApplication.shared.windows[0].safeAreaInsets.top < 40 {
            heightOffset = 57.5
        }
        
        let chatHeight = heightOffset + (UIScreen.main.bounds.height) - (UIScreen.main.bounds.width * (9/16))
        
        if let streamerName = streamerName {
            let chatHtmlString = """
                <iframe frameborder = "0"
                        scrolling = "no"
                        id = "\(streamerName)"
                        src = "https://www.twitch.tv/embed/\(streamerName)/chat?darkpopout"
                        height = "\(chatHeight)"
                        width = "\(UIScreen.main.bounds.width)">
                </iframe>
            """
            
            
            chatWebView.loadHTMLString(chatHtmlString, baseURL: nil)

            let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            chatWebView.configuration.userContentController.addUserScript(script)
            chatWebView.scrollView.contentInset = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            chatWebView.scrollView.contentInsetAdjustmentBehavior = .never
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
        view.addSubview(videoWebView)
        view.addSubview(chatWebView)
        view.addSubview(adsAlertView)
        
        backgroundView.anchor(statusBarView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        statusBarView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: UIApplication.shared.windows[0].safeAreaInsets.top)
        videoWebView.anchor(statusBarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.width * (9/16) + 15)
        chatWebView.anchor(videoWebView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -20, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        adsAlertView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
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
    
    @objc private func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        setupStreamVideo()
        UserDefaults.standard.set(0, forKey: "contentWatchedCount")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        setupStreamVideo()
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
