//
//  TwitterService.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/19/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import OAuthSwift
import SwiftyJSON

class TwitterService {
    
    static let apiKey = "Czt3GY9EJMhqwHWbPwsFikyJ4"
    static let consumerSecret = "a2S6jdkQj2tibv3qTQ6qI4fRV3Ifhm8axI4XJPN1XmTnqbuH8G"
    
    static let oauthSwift = OAuth1Swift(
        consumerKey: "Czt3GY9EJMhqwHWbPwsFikyJ4",
        consumerSecret: "a2S6jdkQj2tibv3qTQ6qI4fRV3Ifhm8axI4XJPN1XmTnqbuH8G",
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl: "https://api.twitter.com/oauth/authorize",
        accessTokenUrl: "https://api.twitter.com/oauth/access_token")
    
    static func signIn(withViewController viewController: UIViewController, completion: @escaping (_ isSignedIn: Bool)->()) {
        
        oauthSwift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthSwift)
        
        oauthSwift.authorize(withCallbackURL: "player3Glitch://twitter") { (result) in
            switch result {
            case .success(let (credential, response, parameters)):
                print(parameters)
                print(response ?? "")
                UserDefaults.standard.set(credential.oauthToken, forKey: "twitterAccessToken")
                UserDefaults.standard.set(credential.oauthTokenSecret, forKey: "twitterTokenSecret")
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    static func getTweet(withId id: Int, completion: @escaping (_ tweet: TwitterTweet) ->()) {
        guard let oauthToken = UserDefaults.standard.string(forKey: "twitterAccessToken") else { return }
        guard let oauthTokenSecret = UserDefaults.standard.string(forKey: "twitterTokenSecret") else { return }
        
        oauthSwift.client.credential.oauthToken = oauthToken
        oauthSwift.client.credential.oauthTokenSecret = oauthTokenSecret
        
        let url = "https://api.twitter.com/1.1/statuses/show.json"
        
        let parameters = [
            "id" : "\(id)",
            "Accept" : "application/json",
            "tweet_mode" : "extended",
            "include_entities" : "true",
        ]
        
        oauthSwift.client.get(url, parameters: parameters) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                                                            
                    if json["retweeted_status"].exists() {
                        completion(getRetweet(tweetJson: json))
                    } else if json["quoted_status"].exists()  {
                        completion(getQuoteTweet(tweetJson: json))
                    } else {
                        completion(getBasicTweet(tweetJson: json))
                    }
                } catch let parsingError {
                    print("Error: \(parsingError)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getTimeline(withUrl url: String, parameters: [String : String], completion: @escaping (_ tweets: [TwitterTweet])->()) {
        guard let oauthToken = UserDefaults.standard.string(forKey: "twitterAccessToken") else { return }
        guard let oauthTokenSecret = UserDefaults.standard.string(forKey: "twitterTokenSecret") else { return }
        
        oauthSwift.client.credential.oauthToken = oauthToken
        oauthSwift.client.credential.oauthTokenSecret = oauthTokenSecret
                
        oauthSwift.client.get(url, parameters: parameters) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                                                          
                    if let itemsArray = json.array {
                        var tweets: [TwitterTweet] = []
                        
                        if itemsArray.count == 0 {
                            completion(tweets)
                        }
                        
                        var count = 0
                        for item in itemsArray {
                            count += 1
                            
                            if item["retweeted_status"].exists() {
                                tweets.append(getRetweet(tweetJson: item))
                            } else if item["quoted_status"].exists()  {
                                tweets.append(getQuoteTweet(tweetJson: item))
                            } else {
                                tweets.append(getBasicTweet(tweetJson: item))
                            }
                            
                            if count == itemsArray.count {
                                completion(tweets)
                            }
                        }
                    }
                } catch let parsingError {
                    print("Error: \(parsingError)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func searchTweets(withUrl url: String, parameters: [String : String], completion: @escaping (_ tweets: [TwitterTweet])->()) {
        guard let oauthToken = UserDefaults.standard.string(forKey: "twitterAccessToken") else { return }
        guard let oauthTokenSecret = UserDefaults.standard.string(forKey: "twitterTokenSecret") else { return }
        
        oauthSwift.client.credential.oauthToken = oauthToken
        oauthSwift.client.credential.oauthTokenSecret = oauthTokenSecret
                
        oauthSwift.client.get(url, parameters: parameters) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                                                                 
                    if let itemsArray = json["statuses"].array {
                        var tweets: [TwitterTweet] = []
                        
                        if itemsArray.count == 0 {
                            completion(tweets)
                        }
                        
                        var count = 0
                        for item in itemsArray {
                            count += 1
                            
                            if item["retweeted_status"].exists() {
                                tweets.append(getRetweet(tweetJson: item))
                            } else if item["quoted_status"].exists()  {
                                tweets.append(getQuoteTweet(tweetJson: item))
                            } else {
                                tweets.append(getBasicTweet(tweetJson: item))
                            }
                            
                            if count == itemsArray.count {
                                completion(tweets)
                            }
                        }
                    }
                } catch let parsingError {
                    print("Error: \(parsingError)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getSignedInUser(completion: @escaping (_ screenName: String)->()) {
        guard let oauthToken = UserDefaults.standard.string(forKey: "twitterAccessToken") else { return }
        guard let oauthTokenSecret = UserDefaults.standard.string(forKey: "twitterTokenSecret") else { return }
        
        oauthSwift.client.credential.oauthToken = oauthToken
        oauthSwift.client.credential.oauthTokenSecret = oauthTokenSecret
                
        let url = "https://api.twitter.com/1.1/account/settings.json"
        
        oauthSwift.client.get(url, parameters: [:]) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    completion(json["screen_name"].stringValue)
                } catch let parsingError {
                    print("Error: \(parsingError)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private static func getRetweet(tweetJson: JSON) -> TwitterTweet {
        let text = tweetJson["retweeted_status"]["full_text"].stringValue.stringByDecodingHTMLEntities
        let verified = tweetJson["retweeted_status"]["user"]["verified"].boolValue
        let name = tweetJson["retweeted_status"]["user"]["name"].stringValue.stringByDecodingHTMLEntities
        let displayName = tweetJson["retweeted_status"]["user"]["screen_name"].stringValue
        let retweetedBy = tweetJson["user"]["name"].stringValue
        let retweetCount = tweetJson["retweeted_status"]["retweet_count"].intValue
        let likeCount = tweetJson["retweeted_status"]["favorite_count"].intValue
        let createdAt = tweetJson["retweeted_status"]["created_at"].stringValue
        let media = tweetJson["retweeted_status"]["extended_entities"]["media"]
        let replyingTo = tweetJson["retweeted_status"]["in_reply_to_screen_name"].stringValue
        let urlJson = tweetJson["retweeted_status"]["entities"]["urls"]
        let userJson = tweetJson["retweeted_status"]["user"]
        let inReplyToId = tweetJson["retweeted_status"]["in_reply_to_status_id"].intValue
        let id = tweetJson["id"].intValue
        
        var quoteTweet: TwitterQuoteTweet? = nil
        if tweetJson["retweeted_status"]["quoted_status"].exists() {
            quoteTweet = getQuotedStatus(tweetJson: tweetJson["retweeted_status"])
        }
        
        var profilePicUrl = tweetJson["retweeted_status"]["user"]["profile_image_url_https"].stringValue
        profilePicUrl = profilePicUrl.replacingOccurrences(of: "_normal", with: "_400x400")
        
        let tweetMedia = getMedia(mediaJson: media)
        
        let tweet = TwitterTweet(text: text, profilePicUrl: profilePicUrl, createdAt: createdAt, verified: verified, name: name, displayName: displayName, retweetedBy: retweetedBy, likeCount: likeCount, retweetCount: retweetCount, media: tweetMedia, replyingTo: replyingTo, id: id, inReplyToId: inReplyToId, urls: urlJson, user: userJson, quoteTweet: quoteTweet)
        
        return tweet
    }
    
    private static func getBasicTweet(tweetJson: JSON) -> TwitterTweet {
        let text = tweetJson["full_text"].stringValue.stringByDecodingHTMLEntities
        let verified = tweetJson["user"]["verified"].boolValue
        let name = tweetJson["user"]["name"].stringValue.stringByDecodingHTMLEntities
        let displayName = tweetJson["user"]["screen_name"].stringValue
        let retweetCount = tweetJson["retweet_count"].intValue
        let likeCount = tweetJson["favorite_count"].intValue
        let createdAt = tweetJson["created_at"].stringValue
        let media = tweetJson["extended_entities"]["media"]
        let replyingTo = tweetJson["in_reply_to_screen_name"].stringValue
        let inReplyToId = tweetJson["in_reply_to_status_id"].intValue
        let urlJson = tweetJson["entities"]["urls"]
        let userJson = tweetJson["user"]
        let id = tweetJson["id"].intValue
        
        var profilePicUrl = tweetJson["user"]["profile_image_url_https"].stringValue
        profilePicUrl = profilePicUrl.replacingOccurrences(of: "_normal", with: "_400x400")
        
        let tweetMedia = getMedia(mediaJson: media)
        
        let tweet = TwitterTweet(text: text, profilePicUrl: profilePicUrl, createdAt: createdAt, verified: verified, name: name, displayName: displayName, retweetedBy: nil, likeCount: likeCount, retweetCount: retweetCount, media: tweetMedia, replyingTo: replyingTo, id: id, inReplyToId: inReplyToId, urls: urlJson, user: userJson, quoteTweet: nil)
        
        return tweet
    }
    
    private static func getQuoteTweet(tweetJson: JSON) -> TwitterTweet {
        let text = tweetJson["full_text"].stringValue.stringByDecodingHTMLEntities
        let verified = tweetJson["user"]["verified"].boolValue
        let name = tweetJson["user"]["name"].stringValue.stringByDecodingHTMLEntities
        let displayName = tweetJson["user"]["screen_name"].stringValue
        let retweetCount = tweetJson["retweet_count"].intValue
        let likeCount = tweetJson["favorite_count"].intValue
        let createdAt = tweetJson["created_at"].stringValue
        let media = tweetJson["extended_entities"]["media"]
        let replyingTo = tweetJson["in_reply_to_screen_name"].stringValue
        let inReplyToId = tweetJson["in_reply_to_status_id"].intValue
        let urlJson = tweetJson["entities"]["urls"]
        let userJson = tweetJson["user"]
        let id = tweetJson["id"].intValue
        
        var profilePicUrl = tweetJson["user"]["profile_image_url_https"].stringValue
        profilePicUrl = profilePicUrl.replacingOccurrences(of: "_normal", with: "_400x400")
        
        let quoteTweet = getQuotedStatus(tweetJson: tweetJson)
        let tweetMedia = getMedia(mediaJson: media)
        
        let tweet = TwitterTweet(text: text, profilePicUrl: profilePicUrl, createdAt: createdAt, verified: verified, name: name, displayName: displayName, retweetedBy: nil, likeCount: likeCount, retweetCount: retweetCount, media: tweetMedia, replyingTo: replyingTo, id: id, inReplyToId: inReplyToId, urls: urlJson, user: userJson, quoteTweet: quoteTweet)
        
        return tweet
    }
    
    private static func getMedia(mediaJson: JSON) -> [TwitterMedia]? {
        guard let mediaArray = mediaJson.array else { return nil }
        
        var medias: [TwitterMedia] = []
        
        var count = 0
        for media in mediaArray {
            count += 0
            let type = media["type"].stringValue
            let displayUrl = media["url"].stringValue
            var url = ""
            var dimensions: [Int]?
            var mediaUrl: String?
            
            if type == "photo" {
                url = media["media_url_https"].stringValue
            } else if type == "video" || type == "animated_gif"{
                mediaUrl = media["media_url_https"].stringValue
                let variants = media["video_info"]["variants"].array ?? []
                for variant in variants {
                    if variant["content_type"].stringValue == "application/x-mpegURL" || variant["bitrate"].intValue == 0 {
                        url = variant["url"].stringValue
                    }
                }
                let vidWidthRatio = media["video_info"]["aspect_ratio"][0].intValue
                let vidHeightRatio = media["video_info"]["aspect_ratio"][1].intValue
                dimensions = [vidWidthRatio, vidHeightRatio]
            } else if type == "animated_gif" {
                let variants = media["video_info"]["variants"].array ?? []
                url = variants[0]["url"].stringValue
            }
            
            medias.append(TwitterMedia(type: type, url: url, displayUrl: displayUrl, dimensions: dimensions, mediaUrl: mediaUrl))
        }
        
        if medias.count == 0 {
            return nil
        } else {
            return medias
        }
    }
    
    private static func getQuotedStatus(tweetJson: JSON) -> TwitterQuoteTweet {
        let text = tweetJson["quoted_status"]["full_text"].stringValue.stringByDecodingHTMLEntities
        let verified = tweetJson["quoted_status"]["user"]["verified"].boolValue
        let name = tweetJson["quoted_status"]["user"]["name"].stringValue.stringByDecodingHTMLEntities
        let displayName = tweetJson["quoted_status"]["user"]["screen_name"].stringValue
        let media = tweetJson["quoted_status"]["extended_entities"]["media"]
        let replyingTo = tweetJson["quoted_status"]["in_reply_to_screen_name"].stringValue
        let inReplyToId = tweetJson["quoted_status"]["in_reply_to_status_id"].intValue
        let quoteDisplayUrl = tweetJson["quoted_status_permalink"]["url"].stringValue
        let urlJson = tweetJson["quoted_status"]["entities"]["urls"]
        let userJson = tweetJson["quoted_status"]["user"]
        let id = tweetJson["quoted_status"]["id"].intValue
        
        var profilePicUrl = tweetJson["quoted_status"]["user"]["profile_image_url_https"].stringValue
        profilePicUrl = profilePicUrl.replacingOccurrences(of: "_normal", with: "_400x400")
        
        let tweetMedia = getMedia(mediaJson: media)
        
        let quoteTweet = TwitterQuoteTweet(username: name, displayName: displayName, verified: verified, profilePicUrl: profilePicUrl, text: text, media: tweetMedia, replyingTo: replyingTo, displayUrl: quoteDisplayUrl, id: id, inReplyToId: inReplyToId, urls: urlJson, user: userJson)
        
        return quoteTweet
    }
}
