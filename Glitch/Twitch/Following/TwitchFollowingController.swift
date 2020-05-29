//
//  TwitchFollowingController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/5/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CRRefresh

class TwitchFollowingController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let notLoggedInView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "twitchBackground")
        view.label.text = "Sign in to view followed streamers"
        view.subLabel.text = "In order to view your followed streamers, sign into your Twitch account."
        view.subLabel.textColor = .twitchGrayTextColor()
        view.button.setTitle("Sign In", for: .normal)
        view.button.backgroundColor = .twitchPurple()
        view.isHidden = true
        return view
    }()
    
    let noFollowsView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "twitchBackground")
        view.label.text = "You don't follow any streamers"
        view.subLabel.text = "Follow streamers on Twitch to view them here."
        view.subLabel.textColor = .twitchGrayTextColor()
        view.button.setTitle("Twitch", for: .normal)
        view.button.backgroundColor = .twitchPurple()
        view.isHidden = true
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitchPurple(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
        
    let offlineCellId = "offlineCellId"
    let liveCellId = "liveCellId"
    
    var streamers: [TwitchStreamer] = [] {
        didSet {
            if streamers.count != 0 {
                noFollowsView.isHidden = true
                notLoggedInView.isHidden = true
            } else {
                if let _ = UserDefaults.standard.string(forKey: "twitchUserId"), let _ = UserDefaults.standard.string(forKey: "twitchAccessToken") {
                    notLoggedInView.isHidden = true
                    noFollowsView.isHidden = false
                } else {
                    notLoggedInView.isHidden = false
                    noFollowsView.isHidden = true
                }
            }
            
            activityIndicator.stopAnimating()
            collectionView.cr.endHeaderRefresh()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    var thumbnailDict: [String : String] = [:]
    var profilePicDict: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.register(TwitchStreamerOfflineCell.self, forCellWithReuseIdentifier: offlineCellId)
        collectionView.register(TwitchStreamCell.self, forCellWithReuseIdentifier: liveCellId)
        
        notLoggedInView.button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        noFollowsView.button.addTarget(self, action: #selector(goToTwitch), for: .touchUpInside)
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfLoggedIn()
    }
    
    private func setupViews() {
        let animator = CustomAnimator()
        animator.label.textColor = .twitchPurple()
        animator.activityIndicator.color = .twitchPurple()
        
        collectionView.cr.addHeadRefresh(animator: animator) {
            self.getFollowedStreamers()
        }
        
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(notLoggedInView)
        view.addSubview(noFollowsView)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        
        notLoggedInView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        noFollowsView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    @objc private func checkIfLoggedIn() {
        if let _ = UserDefaults.standard.string(forKey: "twitchUserId"), let _ = UserDefaults.standard.string(forKey: "twitchAccessToken") {
            if streamers.count == 0 {
                getFollowedStreamers()
            }
        } else {
            streamers = []
            collectionView.cr.endHeaderRefresh()
        }
    }
    
    @objc private func getFollowedStreamers() {
        if noFollowsView.isHidden {
            activityIndicator.startAnimating()
        }
        
        if let _ = UserDefaults.standard.string(forKey: "twitchUserId"), let _ = UserDefaults.standard.string(forKey: "twitchAccessToken") {
            TwitchService.getFollowedStreamers { (streamers) in
                var liveArray: [TwitchStreamer] = []
                var offlineArray: [TwitchStreamer] = []
                for streamer in streamers {
                    if streamer.stream != nil {
                        liveArray.append(streamer)
                    } else {
                        offlineArray.append(streamer)
                    }
                }
                liveArray = liveArray.sorted(by: { $0.name < $1.name })
                offlineArray = offlineArray.sorted(by: { $0.name < $1.name })
                self.streamers = liveArray + offlineArray
            }
        }
    }
    
    @objc private func handleSignIn() {
        TwitchService.signIn(withViewController: self) { (status) in
            if status == .validAccessToken {
                print("Access Token Is Valid")
                self.getFollowedStreamers()
            }
        }
    }
    
    @objc private func goToTwitch() {
        guard let twitchURL = URL(string: "twitch://open") else { return }
        if UIApplication.shared.canOpenURL(twitchURL) {
            UIApplication.shared.open(twitchURL, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "You don't have the Twitch app", message: "Download Twitch?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                if let url = URL(string: "itms-apps://itunes.apple.com/app/id460177396") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
    }
}
