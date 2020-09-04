//
//  EsportsTeam.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/26/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class EsportsTeam {
    
    var name: String
    var picUrl: String
    var id: Int
    var score: Int
    var game: String
    
    init(name: String, picUrl: String, id: Int, score: Int, game: String) {
        self.name = name
        self.picUrl = picUrl
        self.id = id
        self.score = score
        self.game = game
    }
}
