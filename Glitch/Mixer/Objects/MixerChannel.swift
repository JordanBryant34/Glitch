//
//  MixerChannel.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/16/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class MixerChannel {
    
    var id: String
    var username: String
    var profilePicUrl: String
    var isOnline: Int
    var game: String
    
    init(id: String, username: String, profilePicUrl: String, isOnline: Int, game: String) {
        self.id = id
        self.username = username
        self.profilePicUrl = profilePicUrl
        self.isOnline = isOnline
        self.game = game
    }
}
