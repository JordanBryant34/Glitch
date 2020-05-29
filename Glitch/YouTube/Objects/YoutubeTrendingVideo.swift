//
//  YoutubeVideo.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/27/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class YoutubeTrendingVideo {
    
    var title: String
    var thumbnailURL: String
    var id: String
    var publishedAt: String
    var viewCount: Int
    var channelId: String
    var channelName: String
    
    init(title: String, thumbnailURL: String, id: String, publishedAt: String, viewCount: Int, channelId: String, channelName: String) {
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.id = id
        self.publishedAt = publishedAt
        self.viewCount = viewCount
        self.channelId = channelId
        self.channelName = channelName
    }
}
