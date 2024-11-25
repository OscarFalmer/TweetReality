//
//  Tweet_Actions.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit
import TwitterKit

func tweetAction(node: SCNNode, boxSize: CGSize, sceneView: ARSCNView, VC: ViewController, changingScreen: Bool? = false){
    
    if let test = getTweetOpened(nodeParent: node, VC: VC) as TWTRTweet?{
        gTweetOpened = test
    }
    
    gActionInProgress = true
    print("-----IN PROGRESS------")

    // real tweet movements
    tweetNodeMovement(node: node, changingScreen: changingScreen)
    
    // movements of what goes with it
    // making the tweet coming forward
    // add like/retweet/comments/add reply boxes with opacity 0 and fade out from top to bottom
    if gNodeShowedUp{
        tweetComingForward(node: node, boxSize: boxSize, sceneView: sceneView, VC: VC)
    } else { //making the tweet coming back
        tweetGoingBack(node: node)
    }
    
}
