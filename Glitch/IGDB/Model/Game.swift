//
//  Game.swift
//  Glitch
//
//  Created by Jordan Bryant on 9/12/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class Game {
    
    var name: String
    var id: String
    var coverUrl: String
    var screenshotUrl: String
    
    init(name: String, id: String, coverUrl: String, screenshotUrl: String) {
        self.name = name
        self.id = id
        self.coverUrl = coverUrl
        self.screenshotUrl = screenshotUrl
    }
}

extension Game: Equatable {}

func == (lhs: Game, rhs: Game) -> Bool {
    return lhs.name == rhs.name && lhs.id == rhs.id && lhs.coverUrl == rhs.coverUrl
}
