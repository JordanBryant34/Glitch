//
//  MixerFollowingController.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/15/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MixerFollowingController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
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
        view.imageView.image = UIImage(named: "mixerBackground")
        view.label.text = "Sign in to view followed streamers"
        view.subLabel.text = "In order to view your followed streamers, sign into your Mixer account."
        view.subLabel.textColor = .mixerGrayTextColor()
        view.button.setTitle("Sign In", for: .normal)
        view.button.backgroundColor = .mixerLightBlue()
        view.isHidden = true
        return view
    }()
    
    let noFollowsView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "mixerBackground")
        view.label.text = "You don't follow any streamers"
        view.subLabel.text = "Follow streamers on Mixer to view them here."
        view.subLabel.textColor = .mixerGrayTextColor()
        view.button.setTitle("Mixer", for: .normal)
        view.button.backgroundColor = .mixerLightBlue()
        view.isHidden = true
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .mixerLightBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var cellId = "cellId"
    
    var channels: [MixerChannel] = [] {
        didSet {
            if channels.count != 0 {
                noFollowsView.isHidden = true
                notLoggedInView.isHidden = true
            } else {
                if let _ = UserDefaults.standard.string(forKey: "mixerAccessToken") {
                    notLoggedInView.isHidden = true
                    noFollowsView.isHidden = false
                } else {
                    notLoggedInView.isHidden = false
                    noFollowsView.isHidden = true
                }
            }
            
            activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notLoggedInView.button.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        noFollowsView.button.addTarget(self, action: #selector(goToMixer), for: .touchUpInside)
        
        collectionView.register(MixerFollowCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfSignedIn()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(noFollowsView)
        view.addSubview(notLoggedInView)
        view.addSubview(activityIndicator)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        notLoggedInView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        noFollowsView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    private func checkIfSignedIn() {
        if let _ = UserDefaults.standard.string(forKey: "mixerAccessToken") {
            if channels.count == 0 {
                getFollowedStreamers()
            }
        } else {
            channels = []
            reloadData()
            notLoggedInView.isHidden = false
        }
    }
    
    private func getFollowedStreamers() {
        activityIndicator.startAnimating()
        MixerService.getFollowedChannels { (channels) in
            self.channels = channels
            
            var liveArray: [MixerChannel] = []
            var offlineArray: [MixerChannel] = []
            for channel in channels {
                if channel.isOnline == 1 {
                    liveArray.append(channel)
                } else {
                    offlineArray.append(channel)
                }
            }
            liveArray = liveArray.sorted(by: { $0.username < $1.username })
            offlineArray = offlineArray.sorted(by: { $0.username < $1.username })
            self.channels = liveArray + offlineArray
        }
    }
    
    @objc private func signInPressed() {
        MixerService.signIn(withViewController: self) { (signedIn) in
            if signedIn {
                self.getFollowedStreamers()
            }
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    @objc private func goToMixer() {
        guard let mixerUrl = URL(string: "https://www.mixer.com") else { return }
        UIApplication.shared.open(mixerUrl, options: [:], completionHandler: nil)
    }
}
