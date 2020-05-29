//
//  TwitterMedia.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/20/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class TwitterMedia {
    
    var type: String
    var url: String
    var displayUrl: String
    var dimensions: [Int]?
    var mediaUrl: String?
    
    init(type: String, url: String, displayUrl: String, dimensions: [Int]?, mediaUrl: String?) {
        self.type = type
        self.url = url
        self.displayUrl = displayUrl
        self.dimensions = dimensions
        self.mediaUrl = mediaUrl
    }
}
