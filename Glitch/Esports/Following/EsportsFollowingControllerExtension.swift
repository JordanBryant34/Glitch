//
//  EsportsFollowingControllerExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 7/1/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension EsportsFollowingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return filteredMatches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: followingCellId, for: indexPath) as! EsportsFollowingContainerCell
            cell.rootViewController = self
            return cell
        } else if filteredMatches[indexPath.row].status == "running" {
            let cell = tableView.dequeueReusableCell(withIdentifier: liveCellId, for: indexPath) as! LiveMatchTableViewCell
            cell.match = filteredMatches[indexPath.row]
            cell.rootViewController = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: matchCellId, for: indexPath) as! MatchTableViewCell
            cell.match = filteredMatches[indexPath.row]
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        } else {
            if filteredMatches[indexPath.row].status == "running" {
                return 205
            }
            return 175
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.textLabel?.font = .boldSystemFont(ofSize: 30)
        header.textLabel?.frame = header.frame
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        header.backgroundView = backgroundView
        
        header.addSubview(unfollowButton)
        unfollowButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -10).isActive = true
        unfollowButton.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: -2).isActive = true
        unfollowButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        unfollowButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        if filteredMatches.count == 0 {
            header.textLabel?.text = "No matches to show."
        } else {
            header.textLabel?.text = "Followed Matches"
        }
    }
}

