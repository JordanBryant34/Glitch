//
//  TwitchStreamer.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class TwitchStreamer {
    
    var profilePicURL: String
    var name: String
    var stream: TwitchStream?
    
    init(profilePicURL: String, name: String, stream: TwitchStream?) {
        self.profilePicURL = profilePicURL
        self.name = name
        self.stream = stream
    }
}
