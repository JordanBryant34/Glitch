//
//  TwitchStream.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class TwitchStream {
    
    var steamerName: String
    var title: String
    var thumbnailURL: String
    var viewerCount: Int
    var streamerPicURL: String?
    
    init(streamerName: String, title: String, thumbnailURL: String, viewerCount: Int, streamerPicURL: String?) {
        self.steamerName = streamerName
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.viewerCount = viewerCount
        self.streamerPicURL = streamerPicURL
    }
}
