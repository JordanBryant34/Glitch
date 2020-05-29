//
//  YoutubeSubscription.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/29/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class YoutubeSubscription {
    
    var channelName: String
    var channelId: String
    var smallThumbnailURL: String
    var description: String
    var totalItems: Int
    
    init(channelName: String, channelId: String, smallThumbnailURL: String, description: String, totalItems: Int) {
        self.channelName = channelName
        self.channelId = channelId
        self.smallThumbnailURL = smallThumbnailURL
        self.description = description
        self.totalItems = totalItems
    }
}
