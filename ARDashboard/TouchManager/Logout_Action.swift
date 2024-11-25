//
//  Logout_Action.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit
import TwitterKit

func logoutAction(node: SCNNode, sceneView: ARSCNView, VC:ViewController){
    
    if VC.view.viewWithTag(9999999) != nil { //resetButton
        VC.view.viewWithTag(9999999)?.removeFromSuperview()
    }
    
    let fadeIn = SCNAction.fadeIn(duration: 0.1)
    node.runAction(fadeIn)
    
    // logout
    let store = TWTRTwitter.sharedInstance().sessionStore
    
    if let userID = store.session()?.userID {
        store.logOutUserID(userID)
    }
    
    let myGroup = DispatchGroup()
    sceneView.scene.rootNode.enumerateChildNodes{ (node, stop) -> Void in
        
        myGroup.enter()
        
        let fadeIn = SCNAction.fadeOut(duration: 0.2)
        node.runAction(fadeIn)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            node.removeFromParentNode()
            myGroup.leave()
        }
        
    }
    
    myGroup.notify(queue: .main){
        // remettre verification internet ici
        VC.worldReadyToBeShown = false
        VC.worldShown = false
        VC.worldStabilizationReady = false
        
        addLoginView(VC: VC)
        LoginViewAppear(VC: VC)
    }
    
}
