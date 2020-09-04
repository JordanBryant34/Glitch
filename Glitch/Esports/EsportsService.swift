//
//  EsportsService.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/30/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase

class EsportsService {
    
    static let accessToken = "AfzyUkHlPhIXKTBP0kdemK5-yxxEPU8kS8DtEHOK1G9681dWB44"
    
    static func searchTeams(searchString: String, completion: @escaping (_ teams: [EsportsTeam])->()) {
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(accessToken)"]
        let url = "https://api.pandascore.co/teams?search[name]=\(searchString)"
        var teams: [EsportsTeam] = []
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let value = response.value else { completion(teams); return }
            let json = JSON(value)
            
            if let jsonArray = json.array {
                if jsonArray.count < 1 { completion(teams) }
                let totalTeams = jsonArray.count
                var count = 0
                    
                for item in jsonArray {
                    count += 1
                    
                    let name = item["name"].stringValue
                    let id = item["id"].intValue
                    let imageUrl = item["image_url"].stringValue
                    let game = item["current_videogame"]["name"].stringValue
                    
                    let team = EsportsTeam(name: name, picUrl: imageUrl, id: id, score: 0, game: game)
                    
                    if team.game != "PUBG" {
                        teams.append(team)
                    }
                    
                    if count == totalTeams {
                        completion(teams)
                    }
                }
            } else {
                completion(teams)
            }
        }
    }
    
    static func getFollowedTeamsMatches(completion: @escaping (_ matches: [EsportsMatch])->()) {
        var matches: [EsportsMatch] = []
        guard let id = UserDefaults.standard.string(forKey: "userId") else { completion(matches); return }
        let ref = Database.database().reference().child("users").child(id).child("esports").child("following")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let followDict = snapshot.value as? NSDictionary else { completion(matches); return }
            guard let teamIds = followDict.allKeys as? [String] else { completion(matches); print("cant get team ids"); return }
            
            var count = 0
            for teamId in teamIds {
                let teamRef = Database.database().reference().child("esports").child("teams").child(teamId)
                
                teamRef.observeSingleEvent(of: .value) { (teamSnapshot) in
                    count += 1
                    if let teamDict = teamSnapshot.value as? NSDictionary, let matchIds = teamDict.allKeys as? [String] {
                        for matchId in matchIds {
                            guard let matchDict = teamDict[matchId] as? NSDictionary else { return }
                            guard let game = matchDict["game"] as? String else { print("cant get game"); return }
                            guard let leagueName = matchDict["leagueName"] as? String else { print("cant get league name"); return }
                            guard let matchType = matchDict["matchType"] as? String else { print("cant get match type"); return }
                            guard let scheduledTime = matchDict["scheduledTime"] as? String else { print("cant get scheduled time"); return }
                            guard let status = matchDict["status"] as? String else { print("cant get match status"); return }
                            guard let numberOfGames = matchDict["numberOfGames"] as? Int else { print("cant get number of games"); return }
                            guard let opponentsDict = matchDict["opponents"] as? NSDictionary else { print("cant get opponents dict"); return }
                            var liveStreamUrl = ""
                            var opponents: [EsportsTeam] = []

                            if let streamUrl = matchDict["liveStreamUrl"] as? String {
                                liveStreamUrl = streamUrl
                            }

                            for opponentId in opponentsDict.allKeys {
                                guard let opponentDict = opponentsDict[opponentId] as? NSDictionary else { print("cant get opponent dictionary"); return }
                                guard let opponentName = opponentDict["name"] as? String else { print("cant get opponent name"); return }
                                guard let opponentId = opponentDict["id"] as? Int else { print("cant get opponent id"); return }
                                guard let opponentGame = opponentDict["game"] as? String else { print("cant get opponent game"); return }
                                guard let score = opponentDict["score"] as? Int else { print("cant get opponent score"); return }
                                var imageUrl = ""
                                
                                if let url = opponentDict["imageUrl"] as? String {
                                    imageUrl = url
                                }

                                let opponent = EsportsTeam(name: opponentName, picUrl: imageUrl, id: opponentId, score: score, game: opponentGame)
                                opponents.append(opponent)
                            }

                            let match = EsportsMatch(status: status, numberOfGames: numberOfGames, scheduledTime: scheduledTime, gameName: game, liveStreamUrl: liveStreamUrl, opponents: opponents, leagueName: leagueName, matchType: matchType)
                            matches.append(match)
                        }

                    }
                    
                    if count == teamIds.count {
                        matches = matches.sorted(by: {
                            $0.scheduledTime.compare($1.scheduledTime) == .orderedDescending
                        })
                        completion(matches)
                    }
                }
            }
        }
    }
    
    static func parseMatchesJson(json: JSON, completion: @escaping (_ matches: [EsportsMatch])->()) {
        var matches: [EsportsMatch] = []
        guard let matchesJson = json.array else { completion(matches); return }
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
                    matches.append(esportsMatch)
                }
            }
            
            if count == totalMatches {
                completion(matches)
            }
        }
    }
}
