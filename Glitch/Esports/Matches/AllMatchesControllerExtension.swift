//
//  AllMatchesControllerExtension.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/28/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

extension AllMatchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let match = matches[indexPath.row] as? EsportsMatch {
            if match.status == "running" {
                let cell = tableView.dequeueReusableCell(withIdentifier: liveCellId) as! LiveMatchTableViewCell
                cell.match = match
                cell.rootViewController = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: matchCellId) as! MatchTableViewCell
                cell.match = match
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: adCellId) as! NativeAdTableViewCell
            cell.callToActionButton.backgroundColor = .esportsBlue()
            cell.advertiserNameLabel.textColor = .twitchGrayTextColor()
            cell.adLabel.layer.borderColor = UIColor.esportsBlue().cgColor
            cell.adLabel.textColor = .esportsBlue()
            cell.iconImageView.backgroundColor = .twitchGray()
            
            let nativeAds = delegate.nativeAds
            if nativeAds.count > 0 {
                let newNativeAd = nativeAds.randomElement()
                cell.nativeAd = newNativeAd
            } else {
                print("No native ads to show")
            }
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let match = matches[indexPath.row] as? EsportsMatch {
            if match.status == "running" && match.liveStreamUrl.contains("https://www.twitch.tv/") {
                return 205
            } else {
                return 175
            }
        } else {
            return 110
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
        
        if matches.count > 0 {
            if let match = matches[0] as? EsportsMatch {
                if match.status == "running" {
                    header.textLabel?.text = "Live Matches"
                } else if match.status == "not_started" {
                    header.textLabel?.text = "Upcoming Matches"
                } else if match.status == "finished" {
                    header.textLabel?.text = "Past Matches"
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
}

