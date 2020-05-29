//
//  MixerGame.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/11/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class MixerGame {
    
    var id: String
    var name: String
    var backgroundURL: String
    var coverURL: String
    var viewerCount: Int
    
    init(id: String, name: String, backgroundURL: String, coverURL: String, viewerCount: Int) {
        self.id = id
        self.name = name
        self.backgroundURL = backgroundURL
        self.coverURL = coverURL
        self.viewerCount = viewerCount
    }
}
