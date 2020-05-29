//
//  TwitchService.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/5/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import OAuthSwift

class TwitchService {
    static let clientId = "pmov7ap2zve53d1amuv97v07ik930y"
        
    static var oauthSwift = OAuth2Swift(consumerKey: "pmov7ap2zve53d1amuv97v07ik930y",
                             consumerSecret: "",
                             authorizeUrl: "https://id.twitch.tv/oauth2/authorize",
                             accessTokenUrl: "https://id.twitch.tv/oauth2/token",
                             responseType: "token")
    
    enum UserStatus {
        case validAccessToken
        case invalidAccessToken
        case noToken
    }
    
    static func signIn(withViewController viewController: UIViewController, completion: @escaping (_ userStatus: UserStatus)->()) {
        
        oauthSwift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthSwift)
        
        oauthSwift.authorize(withCallbackURL: "player3Glitch://twitch", scope: "analytics:read:games", state: "TWITCH") { (result) in
            switch result {
            case .success(let (credential, response, parameters)):
                print(response ?? "no response")
                print(parameters)
                UserDefaults.standard.set(credential.oauthToken, forKey: "twitchAccessToken")
                validateToken { (status) in
                    print(status)
                    completion(.validAccessToken)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.invalidAccessToken)
            }
        }
    }
    
    static func validateToken(completion: @escaping (_ userStatus: UserStatus)->()) {
        guard let accessToken = UserDefaults.standard.string(forKey: "twitchAccessToken") else { completion(.noToken); return }
        let headers: HTTPHeaders = [ "Authorization" : "OAuth \(accessToken)" ]
        let validateURL = "https://id.twitch.tv/oauth2/validate"
        
        AF.request(validateURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.response?.statusCode != 200 {
                print("twitch validate token: status code \(response.response?.statusCode ?? 9999)")
                UserDefaults.standard.removeObject(forKey: "twitchAccessToken")
                UserDefaults.standard.removeObject(forKey: "twitchUserId")
            } else {
                guard let value = response.value else { return }
                let json = JSON(value)
                let expiration = json["expires_in"].intValue
                let userId = json["user_id"].stringValue
                    
                UserDefaults.standard.set(userId, forKey: "twitchUserId")
                
                if expiration <= 259200 {
                    UserDefaults.standard.removeObject(forKey: "twitchAccessToken")
                    UserDefaults.standard.removeObject(forKey: "twitchUserId")
                } else {
                    completion(.validAccessToken)
                }
            }
        }
    }
    
    static func getFollowedStreamers(completion: @escaping (_ streamers: [TwitchStreamer])->()) {
        guard let fromUserId = UserDefaults.standard.string(forKey: "twitchUserId") else { print("no twitch user id"); return }
        guard let accessToken = UserDefaults.standard.string(forKey: "twitchAccessToken") else { print("no twitch access token"); return }
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)",
            "Client-ID": clientId,
            "Accept": "application/json"
        ]
        
        let parameters: Parameters = [ "from_id" : fromUserId ]
        let followsURL = "https://api.twitch.tv/helix/users/follows"
        
        AF.request(followsURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (followsResponse) in
            if followsResponse.response?.statusCode == 401 {
                print("Twitch follows, error code: 401")
                validateToken { (status) in
                    if status == .validAccessToken {
                        getFollowedStreamers { (streamers) in
                            completion(streamers)
                        }
                    }
                }
            }
            
            let json = JSON(followsResponse.value!)
            let items = json["data"]
            var userIds: [String] = []
            
            if let itemsArray = items.array {
                
                if itemsArray.count == 0 {
                    print("Twitch no follows")
                    completion([])
                }
                
                var count = 0
                for item in itemsArray {
                    count += 1
                    let userId = item["to_id"].stringValue
                    userIds.append(userId)
                    
                    if count == itemsArray.count {
                        getUsers(userIds: userIds) { (streamers) in
                            completion(streamers)
                        }
                    }
                }
            } else { completion([]) }
        }
    }
    
    static func getUsers(userIds: [String], completion: @escaping(_ streamers: [TwitchStreamer])->()) {
        guard let accessToken = UserDefaults.standard.string(forKey: "twitchAccessToken") else { return }
        let url = "https://api.twitch.tv/helix/users?id=\(userIds.joined(separator:"&id="))"
    
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)",
            "Client-ID": clientId,
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let value = response.value else { return }
            let json = JSON(value)
            let items = json["data"]
                                            
            var users: [TwitchStreamer] = []
            
            if let itemsArray = items.array {
                var count = 0
                for item in itemsArray {
                    let profilePicURL = item["profile_image_url"].stringValue
                    let name = item["display_name"].stringValue
                    let id = item["id"].stringValue
                    
                    let parameters: Parameters = [ "user_id" : id ]
                    let streamUrl = "https://api.twitch.tv/helix/streams"
                    
                    AF.request(streamUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (streamResponse) in
                        count += 1
                        let json = JSON(streamResponse.value!)
                                            
                        if json["data"][0]["type"].stringValue == "live" {
                            let title = json["data"][0]["title"].stringValue
                            let thumbnailURL = json["data"][0]["thumbnail_url"].stringValue
                            let viewerCount = json["data"][0]["viewer_count"].intValue

                            let stream = TwitchStream(streamerName: name, title: title, thumbnailURL: thumbnailURL, viewerCount: viewerCount, streamerPicURL: nil)

                            let streamer = TwitchStreamer(profilePicURL: profilePicURL, name: name, stream: stream)
                            users.append(streamer)

                            if count == itemsArray.count || count == 99 {
                                completion(users)
                            }
                        } else {
                            let streamer = TwitchStreamer(profilePicURL: profilePicURL, name: name, stream: nil)
                            users.append(streamer)

                            if count == itemsArray.count || count == 99 {
                                completion(users)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func getTopGames(completion: @escaping(_ streamers: [TwitchGame])->()) {
        let url = "https://api.twitch.tv/helix/games/top"
        
        guard let accessToken = UserDefaults.standard.string(forKey: "twitchAccessToken") else {
            print("no access token to get top games")
            completion([])
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)",
            "Client-ID": clientId,
            "Accept": "application/json"
        ]
        
        let parameters: Parameters = [ "first" : 100 ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let value = response.value else { return }
            var games: [TwitchGame] = []
            let json = JSON(value)
            let items = json["data"]
            
            if response.response?.statusCode == 401 {
                completion([])
            }
                                    
            if let itemsArray = items.array {
                var count = 0
                
                for item in itemsArray {
                    count += 1
                    
                    let name = item["name"].stringValue
                    let id = item["id"].stringValue
                    let boxArtURL = item["box_art_url"].stringValue
                    let game = TwitchGame(name: name, id: id, boxArtURL: boxArtURL)
                    
                    games.append(game)
                    
                    if count == itemsArray.count {
                        completion(games)
                    }
                }
            }
        }
    }
    
    static func getStreams(parameters: [String : Any], completion: @escaping(_ streams: [TwitchStream])->()) {
        guard let accessToken = UserDefaults.standard.string(forKey: "twitchAccessToken") else { completion([]); return }
        var streams: [TwitchStream] = []
        var streamerIDs: [String] = []
        
        let url = "https://api.twitch.tv/helix/streams"
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)",
            "Client-ID": clientId,
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let value = response.value else { return }
            let json = JSON(value)
            let items = json["data"]
            
            if response.response?.statusCode == 401 {
                UserDefaults.standard.removeObject(forKey: "twitchAccessToken")
                UserDefaults.standard.removeObject(forKey: "twitchUserId")
            }
            
            if let itemsArray = items.array {
                var count = 0
                for item in itemsArray {
                    count += 1
                    
                    let streamerName = item["user_name"].stringValue
                    let title = item["title"].stringValue
                    let thumbnailURL = item["thumbnail_url"].stringValue
                    let viewerCount = item["viewer_count"].intValue
                    let streamerId = item["user_id"].stringValue
                    
                    let stream = TwitchStream(streamerName: streamerName, title: title, thumbnailURL: thumbnailURL, viewerCount: viewerCount, streamerPicURL: nil)
                    streams.append(stream)
                    streamerIDs.append(streamerId)
                    
                    if count == itemsArray.count {
                        let streamerURL = "https://api.twitch.tv/helix/users?id=\(streamerIDs.joined(separator:"&id="))"
                        
                        AF.request(streamerURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                            guard let value = response.value else { return }
                            let json = JSON(value)
                            let items = json["data"]
                                                    
                            if let itemsArray = items.array {
                                var count = 0
                                for item in itemsArray {
                                    let profilePicURL = item["profile_image_url"].stringValue
                                    streams[count].streamerPicURL = profilePicURL
                                    
                                    count += 1
                                    if count == itemsArray.count {
                                        completion(streams)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
