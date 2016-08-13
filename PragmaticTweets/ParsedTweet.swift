//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Michael Henry on 4/3/16.
//  Copyright © 2016 Digital Javelina, LLC. All rights reserved.
//

import Foundation

 public struct ParsedTweet {
    
    public var tweetText: String?
    public var userName: String?
    public var createdAt: String?
    public var userAvatarURL: NSURL?
    public var tweetIdString: String?
    
    public init() {
        
    }
}