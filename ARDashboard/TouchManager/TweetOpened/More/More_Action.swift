//
//  More_Action.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 02/12/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func moreAction(sceneView: ARSCNView){
    
    let fadeIn = SCNAction.fadeIn(duration: 0.3)
    let fadeOut = SCNAction.fadeOut(duration: 0.3)
    
    sceneView.scene.rootNode.childNode(withName: kMoreName, recursively: true)?.runAction(fadeOut)
    
    sceneView.scene.rootNode.childNode(withName: kMuteName, recursively: true)?.runAction(fadeIn)
    sceneView.scene.rootNode.childNode(withName: kBlockName, recursively: true)?.runAction(fadeIn)
    sceneView.scene.rootNode.childNode(withName: kReportName, recursively: true)?.runAction(fadeIn)
    
}
