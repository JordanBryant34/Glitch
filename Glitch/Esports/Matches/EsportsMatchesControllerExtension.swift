//
//  EsportsMatchesControllerExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/25/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension EsportsMatchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if liveMatches.count > 2 { return 2 }
            return liveMatches.count
        } else if section == 1 {
            if upcomingMatches.count > 3 { return 3 }
            return upcomingMatches.count
        } else if section == 2 {
            if pastMatches.count > 3 { return 3 }
            return pastMatches.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: liveCellId) as! LiveMatchTableViewCell
            cell.match = nil
            cell.match = liveMatches[indexPath.row]
            cell.rootViewController = self
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: matchCellId) as! MatchTableViewCell
            cell.match = nil
            cell.match = upcomingMatches[indexPath.row]
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: matchCellId) as! MatchTableViewCell
            cell.match = nil
            cell.match = pastMatches[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: matchCellId) as! MatchTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && liveMatches[indexPath.row].liveStreamUrl.contains("https://www.twitch.tv/") {
            return 205
        } else {
            return 175
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.textLabel?.font = .boldSystemFont(ofSize: 30)
        header.textLabel?.frame = header.frame
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        header.backgroundView = backgroundView
        
        if section == 0 {
            header.textLabel?.text = "Live Matches"
        } else if section == 1 {
            header.textLabel?.text = "Upcoming Matches"
        } else if section == 2 {
            header.textLabel?.text = "Past Matches"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && liveMatches.count == 0 {
            return 0
        }
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return ShowMoreFooterView()
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? ShowMoreFooterView else { return }
        footer.label.textColor = .esportsBlue()
        footer.backgroundColor = .twitchLightGray()
        footer.button.tag = section
        footer.button.addTarget(self, action: #selector(presentMoreMatches), for: .touchUpInside)
        footer.label.text = "Show More"
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            if liveMatches.count <= 2 {
                return 0
            } else {
                return 50
            }
        } else if section == 1 {
            if upcomingMatches.count <= 3 {
                return 0
            } else {
                return 50
            }
        } else if section == 2 {
            if pastMatches.count <= 3 {
                return 0
            } else {
                return 50
            }
        }
        return 0
    }
    
    @objc func presentMoreMatches(sender: UIButton) {
        let moreMatchesController = AllMatchesViewController()
        if sender.tag == 0 {
            moreMatchesController.matches = liveMatches
        } else if sender.tag == 1 {
            moreMatchesController.matches = upcomingMatches
        } else if sender.tag == 2 {
            moreMatchesController.matches = pastMatches
        }
        
        present(moreMatchesController, animated: true, completion: nil)
    }
}
