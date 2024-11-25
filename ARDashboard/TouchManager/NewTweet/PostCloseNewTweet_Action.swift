//
//  PostCloseNewTweet_Action.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit
import TwitterKit

// also use for reply
func postCloseNewTweetAction(node: SCNNode, sceneView: ARSCNView, VC: ViewController, tweetAnimation: Bool = true){
    
    var fadeOut = SCNAction.fadeOpacity(to: kLeftButtonsAlphaDown, duration: 0.1)
    sceneView.scene.rootNode.childNode(withName: kWriteTweetName, recursively: true)?.runAction(fadeOut)
    
    if (node.name == kPostTweetName){
        VC.newTweetInvisbleTextField.resignFirstResponder()
        
        if gNewReplyOpened{
            //let tweetOpened:TWTRTweet = getTweetOpened(nodeParent: node.p, VC: VC)
            if let statusID = gTweetOpened?.tweetID{
                postTweet(text: "@\(gTweetOpened!.author.screenName) " + VC.newTweetInvisbleTextField.text!, inReplyToStatusID: statusID)
            }
        } else {
            postTweet(text: VC.newTweetInvisbleTextField.text!)
        }
    
        VC.newTweetInvisbleTextField.text = ""
    } else { // Close
        
        VC.newTweetInvisbleTextField.resignFirstResponder()
        VC.newTweetInvisbleTextField.text = ""
    }
    
    if gNewReplyOpened {
        gNewReplyOpened = false
        
        if tweetAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let replyNode = sceneView.scene.rootNode.childNode(withName: kAddReplyName, recursively: true){
                    // put ba k the tweet at the front
                    replyTweetAnimation(node: replyNode, sceneView: sceneView, position: .front)
                }
            }
        }
        
    } else {
        gNewTweetOpened = false
    }
    
    fadeOut = SCNAction.fadeOut(duration: 0.2)
    sceneView.scene.rootNode.childNode(withName: kNewTweetTitleName, recursively: true)?.runAction(fadeOut)
    sceneView.scene.rootNode.childNode(withName: kNewTweetBox, recursively: true)?.runAction(fadeOut)
    sceneView.scene.rootNode.childNode(withName: kPostTweetName, recursively: true)?.runAction(fadeOut)
    //sceneView.scene.rootNode.childNode(withName: kAddContentNewTweetName, recursively: true)?.runAction(fadeOut)
    sceneView.scene.rootNode.childNode(withName: kClosePostTweetName, recursively: true)?.runAction(fadeOut)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
        sceneView.scene.rootNode.childNode(withName: kNewTweetTitleName, recursively: true)?.removeFromParentNode()
        sceneView.scene.rootNode.childNode(withName: kNewTweetBox, recursively: true)?.removeFromParentNode()
        sceneView.scene.rootNode.childNode(withName: kPostTweetName, recursively: true)?.removeFromParentNode()
        //sceneView.scene.rootNode.childNode(withName: kAddContentNewTweetName, recursively: true)?.removeFromParentNode()
        sceneView.scene.rootNode.childNode(withName: kClosePostTweetName, recursively: true)?.removeFromParentNode()
    }
    
}
