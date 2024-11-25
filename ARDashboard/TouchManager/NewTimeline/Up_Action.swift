//
//  Up_Action.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func upAction(node: SCNNode, sceneView: ARSCNView, VC: ViewController){
    
    if gTweetsIdsUpDown[gCurrentIndexUpDown][0] != "-1"{
        
        let fadeIn = SCNAction.fadeIn(duration: 0.1)
        let fadeOut = SCNAction.fadeOpacity(to: kLeftButtonsAlphaDown, duration: 0.3)
        let fadeSequence = SCNAction.sequence([fadeIn, fadeOut])
        
        node.runAction(fadeSequence)
        
        if gCurrentView != .search{
            newSetup(kind: gCurrentView, max_id: gTweetsIdsUpDown[gCurrentIndexUpDown][0], upDown: "up", sceneView: sceneView, VC: VC)
        } else if gCurrentView == .search{
            newSetup(kind: .search, query: VC.searchBarInvisbleTextField.text, max_id: gTweetsIdsUpDown[gCurrentIndexUpDown][0], upDown: "up", sceneView: sceneView, VC: VC)
        }
        
    }
    
}
