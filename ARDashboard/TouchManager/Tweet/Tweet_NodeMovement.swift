//
//  Tweet_NodeMovement.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func tweetNodeMovement(node: SCNNode, changingScreen: Bool? = false){
    
    var nodePosition = SCNVector3()
    var nodeRotation = SCNVector3()
    var nodeOpacity = CGFloat()
    
    if !gNodeShowedUp{
        gNodeShowedUp = true
        gShowedNodeName = node.name!
        
        previousPosition = node.position
        previousRotation = node.eulerAngles
        previousOpacity = node.opacity
    
        (nodePosition, nodeRotation) = originalNodeNameToPositionAndOrientation(nodeName: node.name!, radius: kDistanceCloseToUser)
            
        nodeOpacity = 1.0
    } else {
        gNodeShowedUp = false
        gShowedNodeName = ""
        
        nodePosition = previousPosition
        nodeRotation = previousRotation
        nodeOpacity = previousOpacity
        
    }
    
    let actionPosition = SCNAction.move(to: nodePosition, duration: 0.5)
    let actionRotation = SCNAction.rotateTo(x: CGFloat(nodeRotation.x), y: CGFloat(nodeRotation.y), z: CGFloat(nodeRotation.z), duration: 0.5)
    let actionOpacity = SCNAction.fadeOpacity(to: nodeOpacity, duration: 0.5)
    
    node.runAction(actionPosition)
    node.runAction(actionRotation)
    
    if changingScreen == false{
        node.runAction(actionOpacity)
    }
    
}

func nameToXangle(nodeName: String) -> CGFloat{
    let xIndex = tweetBoxStringToXIndex(name: nodeName)
    let xAngle = -CGFloat(kNumberColumns-1)/2.0 * kDistanceX + CGFloat(xIndex) * kDistanceX
    
    return xAngle
}

func originalNodeNameToPositionAndOrientation(nodeName: String, radius: CGFloat) -> (SCNVector3, SCNVector3){
    
    let xAngle = nameToXangle(nodeName: nodeName)
    
    let (newZ, newX, newY) = SphericalToCarthesianCoordinates(radius: radius, xAngle: xAngle, yAngle: CGFloat(0))
    print("-->>> newX: \(newX) - newY: \(newY) - newZ: \(newZ)")
    
    let nodePosition = SCNVector3(newX, newY, -newZ)
    let nodeRotation = SCNVector3(0, previousRotation.y, 0)
    
    return (nodePosition, nodeRotation)
}



