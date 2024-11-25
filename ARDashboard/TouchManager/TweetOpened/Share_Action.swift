//
//  Share_Actions.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func shareAction(node: SCNNode, VC: ViewController){
    
    // text to share
    let tweetOpened = getTweetOpened(nodeParent: node.parent!, VC: VC)
    let text = tweetOpened.permalink.absoluteString
    
    // set up activity view controller
    let textToShare = [ text ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = VC.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
    
    // present the view controller
    VC.present(activityViewController, animated: true, completion: nil)
    
}
