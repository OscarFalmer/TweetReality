//
//  SearchSetup.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

func searchSetup(sceneView: ARSCNView, VC: ViewController){
    
    gSearchBarInOpened = true
    
    VC.searchBarInvisbleTextField.text = ""
    
    gSearchBarInFront = true
    
    let boxSizeInfo = CGSize(width: boxSizeMini.width*3, height: boxSizeMini.height/2)
    let boxAnglesInfo = boxAngles(x: 0, y: 0) //2.75*kDistanceY)
    addBoxWithAngles(radius: kDistanceCloseToUserSearch, boxAngles: boxAnglesInfo, boxSize: boxSizeInfo, name: kSearchBarName, sceneView: sceneView, opacity: 1.0, search: true)
    
}

func removeSearchBar(sceneView: ARSCNView){
    
    sceneView.scene.rootNode.childNode(withName: kSearchBarName, recursively: true)?.removeFromParentNode()
}
