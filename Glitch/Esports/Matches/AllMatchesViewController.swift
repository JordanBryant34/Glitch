//
//  AllMatchesViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/28/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AllMatchesViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.backgroundView?.backgroundColor = .clear
        tableView.allowsSelection = false
        return tableView
    }()
    
    var matches:[Any] = []
    
    let liveCellId = "liveCellId"
    let matchCellId = "matchCellId"
    let adCellId = "adCellId"
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LiveMatchTableViewCell.self, forCellReuseIdentifier: liveCellId)
        tableView.register(MatchTableViewCell.self, forCellReuseIdentifier: matchCellId)
        tableView.register(NativeAdTableViewCell.self, forCellReuseIdentifier: adCellId)
        
        setupViews()
        injectAds()
    }
    
    private func setupViews() {
        view.backgroundColor = .twitchGray()
        
        view.addSubview(tableView)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    private func injectAds() {
        if matches.count > 6 {
            let nativeAds = delegate.nativeAds
            
            if nativeAds.count <= 0 { return }
            if matches.count <= 0 { return }
            
            matches = matches.adding(GADUnifiedNativeAd(), afterEvery: 5)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
