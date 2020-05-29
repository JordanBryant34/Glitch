//
//  YoutubeVideoInfo.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/30/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class YoutubeVideoInfo {
    
    var channelId: String
    var channelName: String
    var viewAndDateString: String
    var title: String
    var videoId: String
    
    var channelImage: UIImage
    
    init(channelId: String, channelName: String, videoId: String, title: String, viewAndDateString: String, channelImage: UIImage) {
        self.channelId = channelId
        self.channelName = channelName
        self.channelImage = channelImage
        self.title = title
        self.viewAndDateString = viewAndDateString
        self.videoId = videoId
    }
}
