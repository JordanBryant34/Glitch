//
//  EsportsMatchesViewController.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/24/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import NVActivityIndicatorView

class EsportsMatchesViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        tableView.contentInset = insets
        tableView.backgroundColor = .clear
        tableView.backgroundView?.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.isHidden = true
        return tableView
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballClipRotateMultiple, color: .esportsBlue(), padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var liveMatches: [EsportsMatch] = []
    var pastMatches: [EsportsMatch] = []
    var upcomingMatches: [EsportsMatch] = []
    
    let liveCellId = "liveCellId"
    let matchCellId = "matchCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LiveMatchTableViewCell.self, forCellReuseIdentifier: liveCellId)
        tableView.register(MatchTableViewCell.self, forCellReuseIdentifier: matchCellId)
        
        setupViews()
        getMatches()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
    }
    
    private func getMatches() {
        let ref = Database.database().reference().child("esports").child("matches")
        activityIndicator.startAnimating()
        
        ref.observe(.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary {
                self.liveMatches = []
                self.pastMatches = []
                self.upcomingMatches = []
                
                
                if let liveValues = values["live"] as? String {
                    let liveJson = JSON(parseJSON: liveValues)
                    self.parseMatchJson(json: liveJson)
                }

                if let pastValues = values["past"] as? String {
                    let pastJson = JSON(parseJSON: pastValues)
                    self.parseMatchJson(json: pastJson)
                }

                if let upcomingValues = values["upcoming"] as? String {
                    let upcomingJson = JSON(parseJSON: upcomingValues)
                    self.parseMatchJson(json: upcomingJson)
                }
            } else {
                print("cant get values")
            }
        }
    }
    
    private func parseMatchJson(json: JSON) {
        guard let matchesJson = json.array else { return }
        
        let totalMatches = matchesJson.count
        var count = 0
        
        for match in matchesJson {
            count += 1
            if let opponentsJson = match["opponents"].array, let resultsJson = match["results"].array {
                let status = match["status"].stringValue
                let numberOfGames = match["number_of_games"].intValue
                let scheduledTime = match["scheduled_at"].stringValue
                let gameName = match["videogame"]["name"].stringValue
                let liveStreamUrl = match["official_stream_url"].stringValue
                let leagueName = match["league"]["name"].stringValue
                let matchType = match["match_type"].stringValue
                var opponents: [EsportsTeam] = []
                
                for opponent in opponentsJson {
                    let picUrl = opponent["opponent"]["image_url"].stringValue
                    let name = opponent["opponent"]["name"].stringValue
                    let id = opponent["opponent"]["id"].intValue
                    var score = 0
                    
                    if status != "not_started" {
                        for result in resultsJson {
                            if result["team_id"].intValue == id {
                                score = result["score"].intValue
                                opponents.append(EsportsTeam(name: name, picUrl: picUrl, id: id, score: score, game: gameName))
                            }
                        }
                    } else {
                        opponents.append(EsportsTeam(name: name, picUrl: picUrl, id: id, score: 0, game: gameName))
                    }
                }
                
                let esportsMatch = EsportsMatch(status: status, numberOfGames: numberOfGames, scheduledTime: scheduledTime, gameName: gameName, liveStreamUrl: liveStreamUrl, opponents: opponents, leagueName: leagueName, matchType: matchType)
                
                if opponents.count == 2 {
                    if status == "running" {
                        if liveStreamUrl.contains("https://www.twitch.tv/") {
                            liveMatches.insert(esportsMatch, at: 0)
                        } else {
                            liveMatches.append(esportsMatch)
                        }
                    } else if status == "finished" {
                        pastMatches.append(esportsMatch)
                    } else if status == "not_started" {
                        let scheduledDate = DateFormatter.iso8601.date(from: scheduledTime) ?? Date()
                        if scheduledDate > Date() {
                            upcomingMatches.append(esportsMatch)
                        }
                    }
                }
            }
            
            if count == totalMatches {
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }
}
