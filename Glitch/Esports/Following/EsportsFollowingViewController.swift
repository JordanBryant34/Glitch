//
//  EsportsFollowingViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/1/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class EsportsFollowingViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        let insets = UIEdgeInsets(top: 49, left: 0, bottom: 20, right: 0)
        tableView.contentInset = insets
        tableView.backgroundColor = .clear
        tableView.backgroundView?.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.isHidden = true
        return tableView
    }()
    
    let noFollowsView: BackgroundView = {
        let view = BackgroundView()
        view.imageView.image = UIImage(named: "esportsBackground")
        view.label.text = "You don't follow any teams"
        view.subLabel.text = "Search for teams to follow."
        view.subLabel.textColor = .twitchGrayTextColor()
        view.button.setTitle("Search", for: .normal)
        view.button.backgroundColor = .esportsBlue()
        view.isHidden = true
        return view
    }()
    
    let unfollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Unfollow", for: .normal)
        button.setTitleColor(.esportsBlue(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .esportsBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let followingCellId = "followingCellId"
    let matchCellId = "matchCellId"
    let liveCellId = "liveCellId"
    
    var matches: [EsportsMatch] = []
    var filteredMatches: [EsportsMatch] = []
    var teamIdNamesDict: [Int : String] = [:]
    
    var selectedTeamId: Int? = nil {
        didSet {
            if let id = selectedTeamId {
                unfollowButton.isHidden = false
                filterMatches(teamId: id)
            } else {
                unfollowButton.isHidden = true
                filteredMatches = matches
            }
            
            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EsportsFollowingContainerCell.self, forCellReuseIdentifier: followingCellId)
        tableView.register(MatchTableViewCell.self, forCellReuseIdentifier: matchCellId)
        tableView.register(LiveMatchTableViewCell.self, forCellReuseIdentifier: liveCellId)
        
        unfollowButton.addTarget(self, action: #selector(handleUnfollow), for: .touchUpInside)
        noFollowsView.button.addTarget(self, action: #selector(presentSearchController), for: .touchUpInside)
        
        setupViews()
        
        guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
        let ref = Database.database().reference().child("users").child(id).child("esports").child("following")
        
        ref.observe(.value) { (snapshot) in
            if snapshot.hasChildren() {
                self.getFollowedTeamMatches()
                self.tableView.isHidden = false
                self.noFollowsView.isHidden = true
            } else {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = true
                self.noFollowsView.isHidden = false
            }
        }
        
        activityIndicator.startAnimating()
    }
    
    private func setupViews() {
        let animator = CustomAnimator()
        animator.label.textColor = .esportsBlue()
        animator.activityIndicator.color = .esportsBlue()
        
        tableView.cr.addHeadRefresh(animator: animator) {
            self.getFollowedTeamMatches()
        }
        
        view.addSubview(tableView)
        view.addSubview(noFollowsView)
        view.addSubview(activityIndicator)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        noFollowsView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }
    
    private func getFollowedTeamMatches() {
        EsportsService.getFollowedTeamsMatches { (matches) in
            var matches = matches
            
            var index = -1
            for match in matches {
                index += 1
                if match.status == "running" {
                    matches.remove(at: index)
                    matches.insert(match, at: 0)
                }
            }
            
            self.matches = matches
            self.filteredMatches = matches
            self.selectedTeamId = nil
            
            self.reloadData()
        }
    }
    
    private func filterMatches(teamId: Int) {
        if matches.count == 0 { return }
        
        filteredMatches = matches.filter({$0.opponents[0].id == teamId || $0.opponents[1].id == teamId})
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.cr.endHeaderRefresh()
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc func handleUnfollow() {
        if let teamId = selectedTeamId {
            let teamName = teamIdNamesDict[teamId]
            let alertController = UIAlertController(title: "Unfollow \(teamName ?? "this team")?", message: nil, preferredStyle: .actionSheet)
             
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Unfollow", style: .destructive, handler: { (action) in
                guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
                let ref = Database.database().reference().child("users").child(id).child("esports").child("following").child("\(teamId)")

                ref.removeValue()
                self.selectedTeamId = nil
            }))
             
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func presentSearchController() {
        present(FollowTeamController(), animated: true, completion: nil)
    }
}
