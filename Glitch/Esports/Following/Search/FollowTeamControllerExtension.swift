//
//  FollowTeamControllerExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/30/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Firebase

extension FollowTeamController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! TeamSearchCell
        let team = results[indexPath.row]
        
        cell.backgroundColor = cellBackgroundColor
        
        cell.gameImageView.image = UIImage(named: "\(team.game)_Logo")
        cell.teamNameLabel.text = team.name
        
        cell.followButton.tag = indexPath.row
        cell.followButton.addTarget(self, action: #selector(followTeam), for: .touchUpInside)
        
        if followedTeams.contains("\(team.id)") {
            cell.followButton.isEnabled = false
            cell.followButton.backgroundColor = .twitchGray()
        } else {
            cell.followButton.isEnabled = true
            cell.followButton.backgroundColor = .esportsBlue()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc private func followTeam(sender: UIButton) {
        let team = results[sender.tag]
        guard let id = UserDefaults.standard.string(forKey: "userId") else { return }
        let ref = Database.database().reference().child("users").child(id).child("esports").child("following").child("\(team.id)")
        
        ref.updateChildValues([
            "id" : team.id,
            "name" : team.name,
            "imageUrl" : team.picUrl,
            "game" : team.game
        ])
        
        sender.isEnabled = false
        sender.backgroundColor = .twitchGray()
    }
}
