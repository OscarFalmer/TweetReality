//
//  Mute_Action.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 02/12/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit
import JGProgressHUD

func muteBlockReportAction(node: SCNNode, more: More, sceneView: ARSCNView, VC: ViewController){
    
    let tweetScreenName = getTweetOpened(nodeParent: node.parent!, VC: VC).author.screenName
    
    postMuteBlockReport(screenName: tweetScreenName, more: more)
    
    var hudText = String()
    
    if more == .mute {
        hudText = "Muted"
    } else if more == .block {
        hudText = "Blocked"
    } else if more == .report {
        hudText = "Reported"
    }
    
    hud = JGProgressHUD(style: .extraLight)
    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
    //hud.detailTextLabel.text = "0% Complete"
    hud.textLabel.text = hudText
    hud.detailTextLabel.text = "This user will not appear\nanymore once you reload."
    hud.position = .center
    hud.show(in: sceneView, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        hud.dismiss(animated: true)
    }
    
}
