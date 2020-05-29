//
//  YoutubeChannel.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/31/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class YoutubeChannel {
    
    var name: String
    var id: String
    var channelDefaultImageURL: String
    var channelMediumImageURL: String
    var channelBannerURL: String
    var uploadPlaylistId: String
    
    var subCount: Int
    var viewCount: Int
    var videoCount: Int
    
    init(name: String, id: String, channelDefaultImageURL: String, channelMediumImageURL: String, channelBannerURL: String, uploadPlaylistId: String, subCount: Int, viewCount: Int, videoCount: Int) {
        self.name = name
        self.id = id
        self.channelDefaultImageURL = channelDefaultImageURL
        self.channelMediumImageURL = channelMediumImageURL
        self.channelBannerURL = channelBannerURL
        self.subCount = subCount
        self.viewCount = viewCount
        self.videoCount = videoCount
        self.uploadPlaylistId = uploadPlaylistId
    }
}
