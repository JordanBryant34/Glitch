//
//  YoutubeSubscriptionsController.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/27/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import AppAuth
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class YoutubeSubscriptionsController: UIViewController {
    
    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "youtubeBackground")
        view.label.text = "Sign in to view subscriptions"
        view.subLabel.text = "In order to view your subscription box, sign into your YouTube account with Google."
        view.button.setTitle("Sign In", for: .normal)
        view.button.backgroundColor = .youtubeRed()
        view.isHidden = true
        return view
    }()
    
    let tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        tv.backgroundColor = .clear
        return tv
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .youtubeRed(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .youtubeRed()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle("Privacy Policy", for: .normal)
        return button
    }()
    
    let tosButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .youtubeRed()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle("Terms of Service", for: .normal)
        return button
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeGray()
        return view
    }()
    
    let cellId = "cellId"
    
    var subscriptions: [YoutubeSubscription] = []
    
    var lastUpdated: Double = 0
    var gettingSubscriptions = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.register(YoutubeSubscriptionCell.self, forCellReuseIdentifier: cellId)
        
        backgroundView.button.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(openPrivacyPolicy), for: .touchUpInside)
        tosButton.addTarget(self, action: #selector(openToS), for: .touchUpInside)
        
        setupViews()
        
        getSubscriptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let currentTime = Date().timeIntervalSince1970 / 60
        
        if (currentTime - lastUpdated) > 20 {
            getSubscriptions()
        }
        
        if let _ = UserDefaults.standard.string(forKey: "youtubeAccessToken"), let _ = UserDefaults.standard.string(forKey: "youtubeRefreshToken") {
            if subscriptions.count == 0 {
                getSubscriptions()
                backgroundView.isHidden = true
                tableView.isHidden = false
            }
        } else {
            subscriptions = []
            backgroundView.isHidden = false
            tableView.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    func setupViews() {
        view.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        view.addSubview(bottomView)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        bottomView.addSubview(privacyPolicyButton)
        bottomView.addSubview(tosButton)
        
        privacyPolicyButton.anchor(bottomView.topAnchor, left: bottomView.leftAnchor, bottom: nil, right: bottomView.centerXAnchor, topConstant: 15, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 35)
        tosButton.anchor(bottomView.topAnchor, left: bottomView.centerXAnchor, bottom: nil, right: bottomView.rightAnchor, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 35)
        
        backgroundView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bottomView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 85)
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: bottomView.topAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    @objc func signInPressed() {
        YoutubeService.signIn(withViewController: self) { (isSignedIn) in
            if isSignedIn {
                self.backgroundView.isHidden = true
                self.tableView.isHidden = false
                self.getSubscriptions()
            }
        }
    }
    
    //add private back to this
    func getSubscriptions() {
        if gettingSubscriptions == false {
            gettingSubscriptions = true
            activityIndicator.startAnimating()
            
            lastUpdated = Date().timeIntervalSince1970 / 60
            
            YoutubeService.getSubscriptions { (subscriptions) in
                self.gettingSubscriptions = false
                self.subscriptions = subscriptions ?? []
                self.sortSubscriptions()
                self.backgroundView.isHidden = true
                self.tableView.isHidden = false
            }
        }
    }
    
    private func sortSubscriptions() {
        var newArray: [YoutubeSubscription] = []
        var oldArray: [YoutubeSubscription] = []
        for subscription in subscriptions {
            let prevItemCount = UserDefaults.standard.integer(forKey: "\(subscription.channelId)_totalItems")
            if subscription.totalItems > prevItemCount && prevItemCount > 0 {
                newArray.append(subscription)
            } else {
                oldArray.append(subscription)
            }
        }
        newArray = newArray.sorted(by: { $0.channelName < $1.channelName })
        oldArray = oldArray.sorted(by: { $0.channelName < $1.channelName })
        subscriptions = newArray + oldArray
        reloadData()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    @objc func openPrivacyPolicy() {
        UIApplication.shared.open(URL(string: "https://policies.google.com/privacy")!, options: [:], completionHandler: nil)
    }
    
    @objc func openToS() {
        UIApplication.shared.open(URL(string: "https://www.youtube.com/t/terms")!, options: [:], completionHandler: nil)
    }
}
