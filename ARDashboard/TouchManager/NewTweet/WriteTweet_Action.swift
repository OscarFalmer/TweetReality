//
//  WriteTweet_Actions.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func writeTweetAction(node: SCNNode, sceneView: ARSCNView, reply: Bool = false){
    
    var fadeIn = SCNAction.fadeIn(duration: 0.1)
    node.runAction(fadeIn)
    
    if reply{
        gNewReplyOpened = true
    } else {
        gNewTweetOpened = true
    }
    
    var angles = boxAngles(x: 0, y: 0)
    let newTweetHeight = boxSizeMini.height*1.15
    let boxSize = CGSize(width: boxSizeMini.width, height: newTweetHeight)
    var distanceFromUser: CGFloat = kDistanceCloseToUserSearch
    
    if reply{
        let xAngle = nameToXangle(nodeName: (node.parent?.name)!)
        angles = boxAngles(x: xAngle, y: 0)
        distanceFromUser = kDistanceCloseToUser
    }
    
    addBoxWithAngles(radius: distanceFromUser, boxAngles: angles, boxSize: boxSize, name: kNewTweetBox, sceneView: sceneView, opacity: 0, newTweet: true)
    
    let margin = (boxSize.height)/12
    
    let newTweet = tweetContent(title: "", twitterId: "", content: "", logo: "", image: "", date: Date(), tweetID: "", like: false, retweet: false)
    let postTweetBoxSize = CGSize(width: boxSizeMini.width, height: boxSizeMini.height/3)
    let eulerAngle = SCNVector3(0, 0, 0)
    
    let titleTweetY = newTweetHeight/2 + margin + boxSizeMini.height/6
    let titleTweetPosition = SCNVector3(0, titleTweetY, 0)
    
    let postTweetY = -newTweetHeight/2 - margin - boxSizeMini.height/6
    let postTweetPosition = SCNVector3(0, postTweetY, 0)
    
    let closeTweetY = postTweetY - margin - boxSizeMini.height/3
    let closePostTweetPosition = SCNVector3(0, closeTweetY, 0)
    
    let tweetNode = sceneView.scene.rootNode.childNode(withName: kNewTweetBox, recursively: true)
    
    var newTweetString = "New Tweet"
    
    if reply {
        newTweetString = "Add Reply"
    }
    
    addBox(tweetContent: newTweet,
           boxSize: postTweetBoxSize,
           position: titleTweetPosition,
           eulerAngle: eulerAngle,
           opacity: 1.0,
           name: kNewTweetTitleName,
           rootNode: tweetNode,
           testNoContent: false,
           text: true,
           textString: newTweetString)
    
    addBox(tweetContent: newTweet,
           boxSize: postTweetBoxSize,
           position: postTweetPosition,
           eulerAngle: eulerAngle,
           opacity: 1.0,
           name: kPostTweetName,
           rootNode: tweetNode,
           testNoContent: false,
           text: true,
           textString: "Tweet")
    
    addBox(tweetContent: newTweet,
           boxSize: postTweetBoxSize,
           position: closePostTweetPosition,
           eulerAngle: eulerAngle,
           opacity: 1.0,
           name: kClosePostTweetName,
           rootNode: tweetNode,
           testNoContent: false,
           text: true,
           textString: "Close")
    
    fadeIn = SCNAction.fadeIn(duration: 0.3)
    sceneView.scene.rootNode.childNode(withName: kNewTweetTitleName, recursively: true)?.runAction(fadeIn)
    sceneView.scene.rootNode.childNode(withName: kNewTweetBox, recursively: true)?.runAction(fadeIn)
    sceneView.scene.rootNode.childNode(withName: kPostTweetName, recursively: true)?.runAction(fadeIn)
    sceneView.scene.rootNode.childNode(withName: kClosePostTweetName, recursively: true)?.runAction(fadeIn)
    
}
