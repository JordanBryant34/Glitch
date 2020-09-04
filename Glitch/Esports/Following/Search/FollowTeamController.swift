//
//  FollowTeamController.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/30/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

class FollowTeamController: UIViewController, UISearchBarDelegate {
    
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
        search.searchTextField.backgroundColor = .twitchLightGray()
        search.searchTextField.textColor = .white
        search.tintColor = .white
        return search
    }()
    
    let searchLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.text = "Search Teams"
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitchLightGray()
        return view
    }()
    
    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "esportsBackground")
        view.label.text = "Search for teams to follow"
        view.button.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .esportsBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var results: [EsportsTeam] = []
    var followedTeams: [String] = []
    let cellId = "cellId"
    
    var cellBackgroundColor = UIColor.twitchLightGray()
    
    lazy var functions = Functions.functions()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TeamSearchCell.self, forCellReuseIdentifier: cellId)
        
        setupViews()
        getFollowedTeams()
    }
    
    private func setupViews() {
        view.backgroundColor = .twitchGray()
        
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
    
    private func getFollowedTeams() {
        guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
        let ref = Database.database().reference().child("users").child(id).child("esports").child("following")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let followingDict = snapshot.value as? NSDictionary else { return }
            guard let ids = followingDict.allKeys as? [String] else { return }
            
            self.followedTeams = ids
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchForTeams(text: text)
            searchBar.resignFirstResponder()
        }
    }
    
    @objc private func searchForTeams(text: String) {
        results = []
        
        activityIndicator.startAnimating()
        
        EsportsService.searchTeams(searchString: text) { (teams) in
            self.results = teams
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
