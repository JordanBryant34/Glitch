//
//  MixerStream.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/12/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class MixerStream {
    
    var streamerName: String
    var thumbnailUrl: String
    var profilePicUrl: String
    var title: String
    var channelId: String
    var viewerCount: Int
    
    init(streamerName: String, thumbnailUrl: String, profilePicUrl: String, title: String, channelId: String, viewerCount: Int) {
        self.streamerName = streamerName
        self.thumbnailUrl = thumbnailUrl
        self.profilePicUrl = profilePicUrl
        self.title = title
        self.channelId = channelId
        self.viewerCount = viewerCount
    }
}
