//
//  EsportsMatch.swift
//  Glitch
//
//  Created by Jordan Bryant on 6/26/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class EsportsMatch {
    
    var status: String
    var numberOfGames: Int
    var scheduledTime: String
    var gameName: String
    var liveStreamUrl: String
    var opponents: [EsportsTeam]
    var leagueName: String
    var matchType: String
    
    init(status: String, numberOfGames: Int, scheduledTime: String, gameName: String, liveStreamUrl: String, opponents: [EsportsTeam], leagueName: String, matchType: String) {
        self.status = status
        self.numberOfGames = numberOfGames
        self.scheduledTime = scheduledTime
        self.gameName = gameName
        self.liveStreamUrl = liveStreamUrl
        self.opponents = opponents
        self.leagueName = leagueName
        self.matchType = matchType
    }
}
