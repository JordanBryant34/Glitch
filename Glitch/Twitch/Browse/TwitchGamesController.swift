//
//  TwitchGamesController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/5/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import Alamofire

class TwitchGamesController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = StretchyHeaderLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        cv.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 20, right: 15)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        return cv
    }()
    
    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "twitchBackground")
        view.label.text = "Sign in to browse Twitch"
        view.subLabel.text = "In order to browse games and streams, sign into your Twitch account."
        view.subLabel.textColor = .twitchGrayTextColor()
        view.button.setTitle("Sign In", for: .normal)
        view.button.backgroundColor = .twitchPurple()
        view.isHidden = true
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .twitchPurple(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let clientId = "pmov7ap2zve53d1amuv97v07ik930y"
    let cellId = "cellId"
    let topStreamsCellId = "topStreamsCellId"
    
    var games: [TwitchGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        
        collectionView.register(TwitchTopStreamsCell.self, forCellWithReuseIdentifier: topStreamsCellId)
        collectionView.register(TwitchBrowseCell.self, forCellWithReuseIdentifier: cellId)
            
        checkIfLoggedIn()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = UserDefaults.standard.string(forKey: "twitchUserId"), let _ = UserDefaults.standard.string(forKey: "twitchAccessToken") {
            if games.count == 0 {
                getTopGames()
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(backgroundView)
        
        backgroundView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    @objc private func checkIfLoggedIn() {
        if let _ = UserDefaults.standard.string(forKey: "twitchUserId"), let _ = UserDefaults.standard.string(forKey: "twitchAccessToken") {
            getTopGames()
        } else {
            games = []
            DispatchQueue.main.async {
                self.backgroundView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func getTopGames() {
        activityIndicator.startAnimating()
        games = []
        TwitchService.getTopGames { (games) in
            self.games = games
            self.reloadData()
            if games.count == 0 {
                self.backgroundView.isHidden = false
                self.collectionView.isHidden = true
            } else {
                self.backgroundView.isHidden = true
                self.collectionView.isHidden = false
            }
        }
    }
    
    @objc func presentStreamController() {
        let streamController = TwitchStreamController()
        present(streamController, animated: true, completion: nil)
    }
    
    @objc private func handleSignIn() {
        TwitchService.signIn(withViewController: self) { (status) in
            if status == .validAccessToken {
                self.getTopGames()
            }
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
}
