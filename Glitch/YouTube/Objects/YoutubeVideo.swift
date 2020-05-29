//
//  YoutubeVideo.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/3/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class YoutubeVideo {
    
    var title: String
    var videoId: String
    var thumbnailURL: String
    var publishedAt: String
    var channelTitle: String
    var channelId: String
    
    var viewCount: Int?
    var duration: String?
    var channelImageURL: String?
    
    init(title: String, videoId: String, thumbnailURL: String, publishedAt: String, channelTitle: String, channelId: String, viewCount: Int?, duration: String?, channelImageURL: String?) {
        self.title = title
        self.videoId = videoId
        self.thumbnailURL = thumbnailURL
        self.publishedAt = publishedAt
        self.channelTitle = channelTitle
        self.channelId = channelId
        self.viewCount = viewCount
        self.duration = duration
        self.channelImageURL = channelImageURL
    }
}
