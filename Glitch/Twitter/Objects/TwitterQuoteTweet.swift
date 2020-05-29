//
//  TwitterQuoteTweet.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/1/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import SwiftyJSON

class TwitterQuoteTweet {
    
    var username: String
    var displayName: String
    var verified: Bool
    var profilePicUrl: String
    var text: String
    var media: [TwitterMedia]?
    var replyingTo: String?
    var displayUrl: String
    var urls: JSON?
    var user: JSON
    var id: Int
    var inReplyToId: Int?

    init(username: String, displayName: String, verified: Bool, profilePicUrl: String, text: String, media: [TwitterMedia]?, replyingTo: String?, displayUrl: String, id: Int, inReplyToId: Int?, urls: JSON?, user: JSON) {
        self.username = username
        self.displayName = displayName
        self.verified = verified
        self.profilePicUrl = profilePicUrl
        self.text = text
        self.media = media
        self.replyingTo = replyingTo
        self.displayUrl = displayUrl
        self.urls = urls
        self.user = user
        self.id = id
        self.inReplyToId = inReplyToId
    }
}
