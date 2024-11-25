//
//  MixedReality_Actions.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func mixedRealityAction(node: SCNNode, VC: ViewController){
    
    if node.opacity <= kLeftButtonsAlphaDown {
        
        if gMRClickActivated{
            VC.displayNormalMessage(title: kMRHowToTitle, message: kMRHowToText)
        }
        
        let fadeIn = SCNAction.fadeIn(duration: 0.1)
        node.runAction(fadeIn)
        
        activateMR(activate: true, VC: VC)
    } else {
        let fadeOut = SCNAction.fadeOpacity(to: kLeftButtonsAlphaDown, duration: 0.1)
        node.runAction(fadeOut)
        
        activateMR(activate: false, VC: VC)
    }
    
}
