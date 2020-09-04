//
//  YoutubeService.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/31/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AppAuth

class YoutubeService {
    
    static private let apiKey = "AIzaSyAPDm4p1q4j1gyNa6ENxfKGICPvW1d7wnw"
    static private var youtubeAuthState: OIDAuthState?
    static private let clientID = "329928756367-sn0dstvtigl86srupm3fvhjgm7m08eet.apps.googleusercontent.com"
    
    static func signIn(withViewController viewController: UIViewController, completion: @escaping (_ isSignedIn: Bool) -> ()) {
        guard let redirectURL = URL(string: "jordan.Social-ly:com.googleusercontent.apps.329928756367-sn0dstvtigl86srupm3fvhjgm7m08eet") else { return }
        let authorizationEndpoint = URL(string: "https://accounts.google.com/o/oauth2/v2/auth")!
        let tokenEndpoint = URL(string: "https://www.googleapis.com/oauth2/v4/token")!
        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint, tokenEndpoint: tokenEndpoint)
        
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: nil,
                                              scopes: ["https://www.googleapis.com/auth/youtube.readonly"],
                                              redirectURL: redirectURL,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
        appDelegate.currentAuthorizationFlow =
            OIDAuthState.authState(byPresenting: request, presenting: viewController) { authState, error in
          if let authState = authState {
            youtubeAuthState = authState
                        
            UserDefaults.standard.set(authState.lastTokenResponse?.accessToken, forKey: "youtubeAccessToken")
            UserDefaults.standard.set(authState.lastTokenResponse?.refreshToken, forKey: "youtubeRefreshToken")

            completion(true)
          } else {
            print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
            youtubeAuthState = nil
          }
        }
    }

    
    static func getSubscriptions(completion: @escaping (_ subscriptions: [YoutubeSubscription]?)->()) {
        if let accessToken = UserDefaults.standard.string(forKey: "youtubeAccessToken") {
            let headers: HTTPHeaders = [
              "Authorization": "Bearer \(accessToken)",
              "Accept": "application/json"
            ]
            
            //5 Quota Cost
            AF.request("https://www.googleapis.com/youtube/v3/subscriptions?part=snippet%2CcontentDetails&maxResults=50&mine=true&key=\(apiKey)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                                
                if response.response?.statusCode == 401 {
                    refreshToken()
                } else {
                    let json = JSON(response.value!)
                    let items = json["items"]
                    var subscriptions: [YoutubeSubscription] = []
                                                                  
                    if let itemsArray = items.array {
                        var count = 0
                        for item in itemsArray {
                            count += 1
                            let channelName = item["snippet"]["title"].stringValue
                            let channelId = item["snippet"]["resourceId"]["channelId"].stringValue
                            let smallThumbnailURL = item["snippet"]["thumbnails"]["default"]["url"].stringValue
                            let description = item["snippet"]["description"].stringValue
                            let totalItems = item["contentDetails"]["totalItemCount"].intValue
                            
                            if UserDefaults.standard.integer(forKey: "\(channelId)_totalItems") <= 0 {
                                UserDefaults.standard.set(totalItems, forKey: "\(channelId)_totalItems")
                            }
                            
                            let subscription = YoutubeSubscription(channelName: channelName, channelId: channelId, smallThumbnailURL: smallThumbnailURL, description: description, totalItems: totalItems)
                            
                            subscriptions.append(subscription)
                            
                            if count == itemsArray.count {
                                completion(subscriptions)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func searchYoutubeChannels(searchText text: String, completion: @escaping (_ channel: [YoutubeChannel])->()) {
        var channels:[YoutubeChannel] = []
        let fixedText = text.replacingOccurrences(of: " ", with: "%20")
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(fixedText)&regionCode=US&type=channel&key=\(apiKey)"
    
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                let items = json["items"]
                
                for item in items.array ?? [] {
                    let channelTitle = item["snippet"]["title"].stringValue
                    let channelId = item["id"]["channelId"].stringValue
                    let channelImageUrl = item["snippet"]["thumbnails"]["default"]["url"].stringValue
                    
                    let channel = YoutubeChannel(name: channelTitle, id: channelId, channelDefaultImageURL: channelImageUrl, channelMediumImageURL: "", channelBannerURL: "", uploadPlaylistId: "", subCount: 0, viewCount: 0, videoCount: 0)
                    
                    channels.append(channel)
                }
                completion(channels)
            } else {
                print("no response")
                completion(channels)
            }
        }
    }
    
    static private func refreshToken() {
        if let refreshToken = UserDefaults.standard.string(forKey: "youtubeRefreshToken") {
            let params = [
                "client_id" : clientID,
                "refresh_token" : refreshToken,
                "grant_type" : "refresh_token"
            ]
            
            AF.request("https://oauth2.googleapis.com/token", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if let value = response.value {
                    let json = JSON(value)
                    let newAccessToken = json["access_token"].stringValue
                    
                    UserDefaults.standard.set(newAccessToken, forKey: "youtubeAccessToken")
                }
            }
        }
    }
    
    static func getChannel(withChannelId id: String, completion: @escaping (_ channel: YoutubeChannel?)->()) {
        
        let url = "https://www.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics%2C%20brandingSettings&id=\(id)&key=\(apiKey)"
        AF.request(url).responseJSON { (response) in
            guard let value = response.value else { completion(nil); return }
            let json = JSON(value)
            let item = json["items"][0]
                        
            let name = item["snippet"]["title"].stringValue
            let channelDefaultImageURL = item["snippet"]["thumbnails"]["default"]["url"].stringValue
            let channelMediumImageURL = item["snippet"]["thumbnails"]["medium"]["url"].stringValue
            let channelBannerURL = item["brandingSettings"]["image"]["bannerMobileHdImageUrl"].stringValue
            let subCount = item["statistics"]["subscriberCount"].intValue
            let viewCount = item["statistics"]["viewCount"].intValue
            let videoCount = item["statistics"]["videoCount"].intValue
            let uploadId = item["contentDetails"]["relatedPlaylists"]["uploads"].stringValue
                        
            let channel = YoutubeChannel(name: name, id: id, channelDefaultImageURL: channelDefaultImageURL, channelMediumImageURL: channelMediumImageURL, channelBannerURL: channelBannerURL, uploadPlaylistId: uploadId, subCount: subCount, viewCount: viewCount, videoCount: videoCount)
            
            completion(channel)
        }
    }
    
    static func getChannelVideos(withChannelId channelId: String, completion: @escaping (_ channel: [YoutubeVideo])->()) {
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=\(channelId)&maxResults=50&order=date&key=\(apiKey)"
        
        AF.request(url).responseJSON { (response) in
            guard let value = response.value else { return }
            var videos: [YoutubeVideo] = []
            var videoIds: [String] = []
            let json = JSON(value)
            let items = json["items"]
                                                
            if let itemsArray = items.array {
                var count = 0
                for item in itemsArray {
                    count += 1
                    
                    let title = item["snippet"]["title"].stringValue
                    let id = item["id"]["videoId"].stringValue
                    let channelTitle = item["snippet"]["channelTitle"].stringValue
                    let channelId = item["snippet"]["channelId"].stringValue
                    let publishedAt = item["snippet"]["publishedAt"].stringValue
                    let thumbnailURL = item["snippet"]["thumbnails"]["medium"]["url"].stringValue
                    
                    let video = YoutubeVideo(title: title, videoId: id, thumbnailURL: thumbnailURL, publishedAt: publishedAt, channelTitle: channelTitle, channelId: channelId, viewCount: nil, duration: nil, channelImageURL: nil)
                    videos.append(video)
                    videoIds.append(id)
                    
                    if count == itemsArray.count {
                        let videosUrl = "https://www.googleapis.com/youtube/v3/videos?part=statistics%2CcontentDetails&id=\(videoIds.joined(separator: "%2C"))&key=\(apiKey)"
                        
                        AF.request(videosUrl).responseJSON { (detailsResponse) in
                            guard let videoValue = detailsResponse.value else { return }
                            let videoJson = JSON(videoValue)
                            let videoItems = videoJson["items"]
                            
                            if let videoItemsArray = videoItems.array {
                                var videoCount = 0
                                for videoItem in videoItemsArray {
                                    let duration = videoItem["contentDetails"]["duration"].stringValue
                                    let viewCount = videoItem["statistics"]["viewCount"].intValue
                                    
                                    videos[videoCount].duration = duration
                                    videos[videoCount].viewCount = viewCount
                                    
                                    videoCount += 1
                                    
                                    if videoCount == videoItemsArray.count {
                                        completion(videos)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func getRelatedVideos(withVideoId videoId: String, completion: @escaping (_ videos: [YoutubeVideo])->()) {
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&relatedToVideoId=\(videoId)&type=video&videoEmbeddable=true&key=\(apiKey)"
        
        AF.request(url).responseJSON { (response) in
            guard let value = response.value else { return }
            var videos: [YoutubeVideo] = []
            var videoIds: [String] = []
            let json = JSON(value)
            let items = json["items"]
                                    
            if let itemsArray = items.array {
                var count = 0
                for item in itemsArray {
                    count += 1
                    
                    let title = item["snippet"]["title"].stringValue
                    let id = item["id"]["videoId"].stringValue
                    let channelTitle = item["snippet"]["channelTitle"].stringValue
                    let channelId = item["snippet"]["channelId"].stringValue
                    let publishedAt = item["snippet"]["publishedAt"].stringValue
                    let thumbnailURL = item["snippet"]["thumbnails"]["medium"]["url"].stringValue
                    
                    let video = YoutubeVideo(title: title, videoId: id, thumbnailURL: thumbnailURL, publishedAt: publishedAt, channelTitle: channelTitle, channelId: channelId, viewCount: nil, duration: nil, channelImageURL: nil)
                    videos.append(video)
                    videoIds.append(id)
                    
                    if count == itemsArray.count {
                        let videosUrl = "https://www.googleapis.com/youtube/v3/videos?part=statistics%2CcontentDetails&id=\(videoIds.joined(separator: "%2C"))&key=\(apiKey)"
                        
                        AF.request(videosUrl).responseJSON { (detailsResponse) in
                            guard let videoValue = detailsResponse.value else { return }
                            let videoJson = JSON(videoValue)
                            let videoItems = videoJson["items"]
                            
                            if let videoItemsArray = videoItems.array {
                                var videoCount = 0
                                for videoItem in videoItemsArray {
                                    let duration = videoItem["contentDetails"]["duration"].stringValue
                                    let viewCount = videoItem["statistics"]["viewCount"].intValue
                                    
                                    videos[videoCount].duration = duration
                                    videos[videoCount].viewCount = viewCount
                                    
                                    videoCount += 1
                                    
                                    if videoCount == videoItemsArray.count {
                                        completion(videos)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func getUploads(withPlaylistId playlistId: String, withChannelImageUrl channelImageUrl: String, completion: @escaping (_ videos: [YoutubeVideo])->()) {
        let url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=15&playlistId=\(playlistId)&key=\(apiKey)"
        var videos: [YoutubeVideo] = []
        
        AF.request(url).responseJSON { (response) in
            guard let value = response.value else { completion(videos); return }
            let json = JSON(value)
            let items = json["items"]
                                    
            if let itemsArray = items.array {
                var count = 0
                for item in itemsArray {
                    count += 1
                    
                    let title = item["snippet"]["title"].stringValue
                    let id = item["snippet"]["resourceId"]["videoId"].stringValue
                    let channelTitle = item["snippet"]["channelTitle"].stringValue
                    let channelId = item["snippet"]["channelId"].stringValue
                    let publishedAt = item["snippet"]["publishedAt"].stringValue
                    let thumbnailURL = item["snippet"]["thumbnails"]["maxres"]["url"].stringValue
                                                    
                    let video = YoutubeVideo(title: title, videoId: id, thumbnailURL: thumbnailURL, publishedAt: publishedAt, channelTitle: channelTitle, channelId: channelId, viewCount: 0, duration: nil, channelImageURL: channelImageUrl)
                    videos.append(video)
                    
                    if count == itemsArray.count {
                        completion(videos)
                    }
                }
            }
        }
    }
    
    static func getChannelImage(withChannelId channelId: String, completion: @escaping (_ channelImage: String)->()) {
        let url = "https://www.googleapis.com/youtube/v3/channels?part=snippet&id=\(channelId)&key=\(apiKey)"
        
        AF.request(url).responseJSON { (response) in
            guard let value = response.value else { return }
            let json = JSON(value)
            let profilePicURL = json["items"][0]["snippet"]["thumbnails"]["default"]["url"].stringValue
            
            completion(profilePicURL)
        }
    }
    
    static func searchYoutubeVideos(searchText text: String, completion: @escaping (_ videos: [YoutubeVideo])->()) {
        var videos: [YoutubeVideo] = []
        let fixedText = text.replacingOccurrences(of: " ", with: "%20")
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&q=\(fixedText)&regionCode=US&type=video&key=\(apiKey)"
    
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                let items = json["items"]
                
                if let itemsArray = items.array {
                    if itemsArray.count == 0 {
                        completion([])
                    }
                    
                    var count = 0
                    for item in itemsArray {
                        count += 1
                                                
                        let title = item["snippet"]["title"].stringValue.stringByDecodingHTMLEntities
                        let id = item["id"]["videoId"].stringValue
                        let channelTitle = item["snippet"]["channelTitle"].stringValue
                        let channelId = item["snippet"]["channelId"].stringValue
                        let publishedAt = item["snippet"]["publishedAt"].stringValue
                        let thumbnailURL = item["snippet"]["thumbnails"]["high"]["url"].stringValue
                           
                        let video = YoutubeVideo(title: title, videoId: id, thumbnailURL: thumbnailURL, publishedAt: publishedAt, channelTitle: channelTitle, channelId: channelId, viewCount: 0, duration: nil, channelImageURL: nil)
                        videos.append(video)
                        
                        if count == itemsArray.count {
                            completion(videos)
                        }
                    }
                }
            } else {
                print("no response")
                completion(videos)
            }
        }
    }
}
