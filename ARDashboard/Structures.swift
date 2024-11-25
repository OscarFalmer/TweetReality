//
//  Structures.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 22/09/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import SceneKit

struct tweetContent {
    var title: String
    var twitterId: String
    var content: String
    var logo: String
    var image: String
    var date: Date
    var tweetID: String
    var like: Bool
    var retweet: Bool
}

struct boxAngles {
    var x: CGFloat
    var y: CGFloat
}
