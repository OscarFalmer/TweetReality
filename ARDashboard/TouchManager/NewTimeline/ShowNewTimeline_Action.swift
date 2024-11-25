//
//  ShowNewTimeline_Action.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func showNewTimelineAction(node: SCNNode, sceneView: ARSCNView, VC: ViewController){
    
    if node.opacity <= kLeftButtonsAlphaDown {
        let fadeIn = SCNAction.fadeIn(duration: 0.1)
        let fadeOut = SCNAction.fadeOpacity(to: kLeftButtonsAlphaDown, duration: 0.1)
        
        node.runAction(fadeIn)
        
        let childNodes:[SCNNode] = (sceneView.scene.rootNode.childNode(withName: kRootNodeName, recursively: false)?.childNodes)!
        
        for i in childNodes{
            if i.name != node.name && (node.name == kHomeName || node.name == kProfilePictureName || node.name == kNotificationsName || node.name == kSearchName){
                i.runAction(fadeOut)
            }
        }
    }
    
    //fadeAnimation(sceneView: sceneView, inOut: "out")
    
    if node.name == kHomeName{
        gSearchBarInOpened = false
        removeSearchBar(sceneView: sceneView)
        newSetup(kind: KindOfTweet.timeline, sceneView: sceneView, VC: VC)
    } else if node.name == kProfilePictureName{
        gSearchBarInOpened = false
        removeSearchBar(sceneView: sceneView)
        newSetup(kind: KindOfTweet.profile, sceneView: sceneView, VC: VC)
    } else if node.name == kNotificationsName{
        gSearchBarInOpened = false
        removeSearchBar(sceneView: sceneView)
        newSetup(kind: KindOfTweet.mentions, sceneView: sceneView, VC: VC)
    } else if node.name == kSearchName{
        if !gSearchBarInFront{
            searchSetup(sceneView: sceneView, VC: VC)
        }
    } else {
        gSearchBarInOpened = false
        removeSearchBar(sceneView: sceneView)
        newSetup(kind: KindOfTweet.timeline, sceneView: sceneView, VC: VC)
    }
    
}

