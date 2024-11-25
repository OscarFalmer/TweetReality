//
//  Reply_Action.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 13/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func replyAction(node: SCNNode, sceneView: ARSCNView){
    
    replyTweetAnimation(node: node, sceneView: sceneView, position: .back)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        writeTweetAction(node: node, sceneView: sceneView, reply: true)
    }
    
}

func replyTweetAnimation(node: SCNNode, sceneView: ARSCNView, position: SearchBarPosition){ //nothing to do with SearchBarPosition : update enumeration, change the function title because it's used also in expandedtweet_action
    let parentNode = node.parent
    var fade: SCNAction? = nil
    var movePosition: SCNVector3? = nil
    
    if position == .back {
        fade = SCNAction.fadeOpacity(to: kLeftButtonsAlphaDown, duration: 0.2)
        
        let (nodePosition, _) = originalNodeNameToPositionAndOrientation(nodeName: (parentNode?.name)!, radius: kDistanceCloseToUser+0.1)
        
        movePosition = nodePosition
    } else if position == .front {
        fade = SCNAction.fadeOpacity(to: 1.0, duration: 0.2)
        
        let (nodePosition, _) = originalNodeNameToPositionAndOrientation(nodeName: (parentNode?.name)!, radius: kDistanceCloseToUser)
        
        movePosition = nodePosition
    }
    
    let movement = SCNAction.move(to: movePosition!, duration: 0.2)
    let sequence = SCNAction.group([fade!, movement])
    parentNode?.runAction(sequence)
}
