//
//  MixerService.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/10/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import OAuthSwift
import Alamofire
import SwiftyJSON

class MixerService {
    
    let clientId = "35513418ba3b5457fb6b26674dd8d78e90bf43d62c88b771"
    static var baseURL = "https://mixer.com/api/v1"
    
    static var oauthSwift = OAuth2Swift(consumerKey: "35513418ba3b5457fb6b26674dd8d78e90bf43d62c88b771",
                             consumerSecret: "",
                             authorizeUrl: "https://mixer.com/oauth/authorize?approval_prompt=force",
                             accessTokenUrl: "https://mixer.com/api/v1/oauth/token",
                             responseType: "token")
    
    static func signIn(withViewController viewController: UIViewController, completion: @escaping (_ signedIn: Bool)->()) {
        oauthSwift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthSwift)
        
        oauthSwift.authorize(withCallbackURL: "player3Glitch://glitch.mixer", scope: "channel:details:self", state: "MIXER") { (result) in
            switch result {
            case .success(let (credential, response, parameters)):
                print(response ?? "no response")
                print(parameters)
                UserDefaults.standard.set(credential.oauthToken, forKey: "mixerAccessToken")
                completion(true)
            case .failure(let error):
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
    
    static func getTopGames(completion: @escaping(_ streamers: [MixerGame])->()) {
        let parameters: Parameters = [
            "limit" : 99,
            "order" : "viewersCurrent:DESC"
        ]
        
        AF.request("\(baseURL)/types", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard let value = response.value else { return }

            var games: [MixerGame] = []
            let json = JSON(value)
            
            if let itemsArray = json.array {
                var count = 0

                for item in itemsArray {
                    count += 1
                    
                    let id = item["id"].stringValue
                    let name = item["name"].stringValue
                    let backgroundURL = item["backgroundUrl"].stringValue
                    let coverURL = item["coverUrl"].stringValue
                    let viewerCount = item["viewersCurrent"].intValue
                    
                    let game = MixerGame(id: id, name: name, backgroundURL: backgroundURL, coverURL: coverURL, viewerCount: viewerCount)
                    games.append(game)
                    
                    if count == itemsArray.count {
                        completion(games)
                    }
                }
            }
        }
    }
    
    static func getStreams(url: String, parameters: [String : Any], completion: @escaping(_ streams: [MixerStream])->()) {
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard let value = response.value else { return }
            let items = JSON(value)

            var streams: [MixerStream] = []
            
            if let itemsArray = items.array {
                var count = 0
                for item in itemsArray {
                    count += 1
                    
                    let streamerName = item["user"]["username"].stringValue
                    let profilePicUrl = item["user"]["avatarUrl"].stringValue
                    let viewers = item["viewersCurrent"].intValue
                    let thumbnailUrl = item["thumbnail"]["url"].stringValue
                    let title = item["name"].stringValue
                    let channelId = item["id"].stringValue
                    
                    let stream = MixerStream(streamerName: streamerName, thumbnailUrl: thumbnailUrl, profilePicUrl: profilePicUrl, title: title, channelId: channelId, viewerCount: viewers)
                    
                    streams.append(stream)
                    
                    if count == itemsArray.count {
                        completion(streams)
                    }
                }
            }
        }
    }
    
    static func getUser(completion: @escaping(_ user: String?)->()) {
        guard let accessToken = UserDefaults.standard.string(forKey: "mixerAccessToken") else { completion(nil); return }
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(accessToken)"]
        
        AF.request("\(baseURL)/users/current", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            let json = JSON(response.value as Any)
            let id = json["id"].stringValue
            
            completion(id)
        }
    }
    
    static func getFollowedChannels(completion: @escaping(_ channels: [MixerChannel])->()) {
        getUser { (userId) in
            guard let id = userId else { return }
            guard let accessToken = UserDefaults.standard.string(forKey: "mixerAccessToken") else { return }
            let headers: HTTPHeaders = ["Authorization" : "Bearer \(accessToken)"]
            
            AF.request("\(baseURL)/users/\(id)/follows", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                guard let value = response.value else { return }
                var channels: [MixerChannel] = []
                let items = JSON(value)
                                
                if let itemsArray = items.array {
                    
                    if itemsArray.count == 0 {
                        completion([])
                    }
                    
                    var count = 0
                    for item in itemsArray {
                        count += 1
                        
                        let profilePicUrl = item["user"]["avatarUrl"].stringValue
                        let id = item["id"].stringValue
                        let username = item["user"]["username"].stringValue
                        let isOnline = item["online"].intValue
                        let game = item["type"]["name"].stringValue
                        
                        let channel = MixerChannel(id: id, username: username, profilePicUrl: profilePicUrl, isOnline: isOnline, game: game)
                        channels.append(channel)
                        
                        if count == itemsArray.count {
                            completion(channels)
                        }
                    }
                } else {
                    completion([])
                }
                
            }
        }
    }
    
    static func getOneMixerStream(fromUsername username: String, completion: @escaping(_ stream: MixerStream?)->()) {
        AF.request("\(baseURL)/channels/\(username)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            let json = JSON(response.value as Any)
            
            print(json)
            let id = json["id"].stringValue
            let username = json["user"]["username"].stringValue
            let profilePicUrl = json["user"]["avatarUrl"].stringValue
            
            let stream = MixerStream(streamerName: username, thumbnailUrl: "", profilePicUrl: profilePicUrl, title: "", channelId: id, viewerCount: 0)
            completion(stream)
        }
    }
}
