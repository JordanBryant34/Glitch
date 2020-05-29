//
//  TwitterTweet.swift
//  Glitch
//
//  Created by Jordan Bryant on 2/19/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import SwiftyJSON

class TwitterTweet {
    
    var text: String?
    var profilePicUrl: String
    var verified: Bool
    var name: String
    var createdAt: String
    var displayName: String
    var retweetedBy: String?
    var likeCount: Int
    var retweetCount: Int
    var media: [TwitterMedia]?
    var replyingTo: String
    var urls: JSON?
    var quoteTweet: TwitterQuoteTweet?
    var user: JSON
    var id: Int
    var inReplyToId: Int?
    
    init(text: String?, profilePicUrl: String, createdAt: String, verified: Bool, name: String, displayName: String, retweetedBy: String?, likeCount: Int, retweetCount: Int, media: [TwitterMedia]?, replyingTo: String, id: Int, inReplyToId: Int?, urls: JSON?, user: JSON, quoteTweet: TwitterQuoteTweet?) {
        self.text = text
        self.profilePicUrl = profilePicUrl
        self.verified = verified
        self.name = name
        self.displayName = displayName
        self.retweetedBy = retweetedBy
        self.likeCount = likeCount
        self.retweetCount = retweetCount
        self.media = media
        self.createdAt = createdAt
        self.replyingTo = replyingTo
        self.urls = urls
        self.user = user
        self.quoteTweet = quoteTweet
        self.id = id
        self.inReplyToId = inReplyToId
    }
}
