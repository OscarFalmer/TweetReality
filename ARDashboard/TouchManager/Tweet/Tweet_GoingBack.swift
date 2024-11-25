//
//  Tweet_GoingBack.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func tweetGoingBack(node: SCNNode){
    
    let fadeOut = SCNAction.fadeOut(duration: 0.2)
    
    node.childNode(withName: kExpandName, recursively: true)?.runAction(fadeOut)
    node.childNode(withName: kShareName, recursively: true)?.runAction(fadeOut)
    node.childNode(withName: kLikeName, recursively: true)?.runAction(fadeOut)
    node.childNode(withName: kRetweetName, recursively: true)?.runAction(fadeOut)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        node.childNode(withName: kAddReplyName, recursively: true)?.runAction(fadeOut)
        node.childNode(withName: kMoreName, recursively: true)?.runAction(fadeOut)
        node.childNode(withName: kMuteName, recursively: true)?.runAction(fadeOut)
        node.childNode(withName: kBlockName, recursively: true)?.runAction(fadeOut)
        node.childNode(withName: kReportName, recursively: true)?.runAction(fadeOut)
        
        node.enumerateChildNodes{ (node, stop) -> Void in
            if node.name == kTopTweetName || node.name == kDownTweetName{
                node.runAction(fadeOut)
            }
        }
        
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        
        node.childNode(withName: kExpandName, recursively: true)?.removeFromParentNode()
        node.childNode(withName: kShareName, recursively: true)?.removeFromParentNode()
        node.childNode(withName: kLikeName, recursively: true)?.removeFromParentNode()
        node.childNode(withName: kRetweetName, recursively: true)?.removeFromParentNode()
        
        node.childNode(withName: kAddReplyName, recursively: true)?.removeFromParentNode()
        node.childNode(withName: kMoreName, recursively: true)?.removeFromParentNode()
        node.childNode(withName: kMuteName, recursively: true)?.removeFromParentNode()
        node.childNode(withName: kBlockName, recursively: true)?.removeFromParentNode()
        node.childNode(withName: kReportName, recursively: true)?.removeFromParentNode()
        
        node.enumerateChildNodes{ (node, stop) -> Void in
            if node.name == kTopTweetName || node.name == kDownTweetName{
                node.removeFromParentNode()
            }
        }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        gActionInProgress = false
        print("-----DONE 2------")
    }
    
}
