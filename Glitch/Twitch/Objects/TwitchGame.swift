//
//  TwitchGame.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/2/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TwitchGame {
    
    var name: String
    var id: String
    var boxArtURL: String
    
    init(name: String, id: String, boxArtURL: String) {
        self.name = name
        self.id = id
        self.boxArtURL = boxArtURL
    }
}
