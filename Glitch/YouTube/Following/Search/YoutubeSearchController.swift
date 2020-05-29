//
//  YoutubeSearchController.swift
//  Glitch
//
//  Created by Jordan Bryant on 5/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import Alamofire

class YoutubeSearchController: UIViewController, UISearchBarDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.contentInset = insets
        tableView.backgroundColor = .clear
        tableView.backgroundView?.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.returnKeyType = .search
        search.backgroundImage = UIImage()
        search.searchBarStyle = .minimal
        search.searchTextField.backgroundColor = .youtubeGray()
        search.searchTextField.textColor = .white
        search.tintColor = .white
        return search
    }()
    
    let searchLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.text = "Search Channels"
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .youtubeGray()
        return view
    }()
    
    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "youtubeBackground")
        view.label.text = "Search for channels to follow"
        view.button.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .youtubeRed(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var results: [YoutubeChannel] = []
    let cellId = "cellId"
    
    lazy var functions = Functions.functions()
    
    var channels: [String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(YoutubeSearchCell.self, forCellReuseIdentifier: cellId)
        
        setupViews()
        getFollowedChannels()
    }
    
    private func setupViews() {
        view.backgroundColor = .youtubeBlack()
        
        view.addSubview(backgroundView)
        view.addSubview(activityIndicator)
        view.addSubview(searchLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(separatorView)
        
        searchLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 55)
        searchBar.anchor(searchLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 60)
        tableView.anchor(searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        separatorView.anchor(searchBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    private func getFollowedChannels() {
        guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
        let ref = Database.database().reference().child("users").child(id).child("youtube").child("following")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let items = snapshot.value as? NSDictionary else { return }
            self.channels = items.allKeys as? [String] ?? []
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchForChannels(text: text)
            searchBar.resignFirstResponder()
        }
    }
    
    @objc private func searchForChannels(text: String) {
        results = []
        
        activityIndicator.startAnimating()
        
        YoutubeService.searchYoutubeChannels(searchText: text) { (channels) in
            self.results = channels
            self.reloadData()
        }
    }
    
    private func reloadData() {
        tableView.reloadData()
        activityIndicator.stopAnimating()
        
        if results.count == 0 {
            tableView.isHidden = true
            backgroundView.isHidden = false
            
            backgroundView.label.text = "No results found"
            backgroundView.subLabel.text = "Try different keywords and search again"
        } else {
            tableView.isHidden = false
            backgroundView.isHidden = true
        }
    }
}
