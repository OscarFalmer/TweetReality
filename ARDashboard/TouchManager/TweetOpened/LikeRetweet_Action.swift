//
//  LikeRetweet_Actions.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func likeRetweetActions(node: SCNNode, VC: ViewController){
    
    let tweetID = getTweetOpened(nodeParent: node.parent!, VC: VC).tweetID
    
    if node.name == kLikeName && node.rotation.y == 0{
        gTweetLikes.append(tweetID)
        if gTweetUnLikes.contains(tweetID){
            let index = gTweetUnLikes.index(of: tweetID)
            gTweetUnLikes.remove(at: index!)
        }
        
        postRetweetLike(tweetID: tweetID, mode: .like)
    } else if node.name == kLikeName && node.rotation.y != 0{
        if gTweetLikes.contains(tweetID){
            let index = gTweetLikes.index(of: tweetID)
            gTweetLikes.remove(at: index!)
        }
        gTweetUnLikes.append(tweetID)
        
        postRetweetLike(tweetID: tweetID, mode: .unlike)
    } else if node.name == kRetweetName && node.rotation.y == 0{
        gTweetRetweets.append(tweetID)
        if gTweetUnRetweets.contains(tweetID){
            let index = gTweetUnRetweets.index(of: tweetID)
            gTweetUnRetweets.remove(at: index!)
        }
        
        postRetweetLike(tweetID: tweetID, mode: .retweet)
    } else if node.name == kRetweetName && node.rotation.y != 0{
        if gTweetRetweets.contains(tweetID){
            let index = gTweetRetweets.index(of: tweetID)
            gTweetRetweets.remove(at: index!)
        }
        gTweetUnRetweets.append(tweetID)
        
        postRetweetLike(tweetID: tweetID, mode: .unretweet)
    }
    
    let rotationAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 0.2)
    node.runAction(rotationAction)
    
}
