//
//  MixedReality.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 10/10/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import UIKit
import ARKit

func activateMR(activate: Bool, VC: ViewController) {
    
    if activate{
        
        VC.sceneView.showsStatistics = false
        VC.sceneView3.showsStatistics = false
        
        VC.sceneView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(VC.view.snp.height).dividedBy(2)
        }
        
        VC.view.addSubview(VC.sceneView3)
        VC.sceneView3.scene = VC.sceneView.scene
        VC.sceneView3.isPlaying = true
        
        VC.sceneView3.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(VC.view.snp.height).dividedBy(2)
        }
        
        if gMRClickActivated {
            VC.listenVolumeButton(activated: true)
        }
        
        gMRActivated = true
    } else {
        
        if gMRClickActivated {
            VC.listenVolumeButton(activated: false)
        }
        
        VC.sceneView3.isPlaying = false
        VC.sceneView3.removeFromSuperview()
        
        VC.sceneView.showsStatistics = false
        
        VC.sceneView.snp.remakeConstraints{ (make) -> Void in
            
            //make.height.equalToSuperview()
            make.height.equalTo(VC.view.snp.height)
            
            make.top.equalTo(VC.view.snp.top)
            make.left.equalTo(VC.view.snp.left)
            make.right.equalTo(VC.view.snp.right)
            make.bottom.equalTo(VC.view.snp.bottom)
            
            //make.centerY.equalTo(self.view.snp.centerY)
            //make.height.equalTo(self.view.snp.height)
            
        }
        
        gMRActivated = false
        
    }
}

//VR
func updateFrame(VC: ViewController) {
    
    // Clone pointOfView for Second View
    let pointOfView : SCNNode = (VC.sceneView.pointOfView?.clone())!
    
    // Add calculations for right-eye position ...
    // Determine Adjusted Position for Right Eye
    let orientation : SCNQuaternion = pointOfView.orientation
    let orientationQuaternion : GLKQuaternion = GLKQuaternionMake(orientation.x, orientation.y, orientation.z, orientation.w)
    let eyePos : GLKVector3 = GLKVector3Make(0.0, 1.0, 0.0) // quand les 2 views sont à gauche et droite : GLKVector3Make(1.0, 0.0, 0.0)
    let rotatedEyePos : GLKVector3 = GLKQuaternionRotateVector3(orientationQuaternion, eyePos)
    let rotatedEyePosSCNV : SCNVector3 = SCNVector3Make(rotatedEyePos.x, rotatedEyePos.y, rotatedEyePos.z)
    
    let mag : Float = 0.066 // This is the value for the distance between two pupils (in metres). The Interpupilary Distance (IPD).
    pointOfView.position.x += rotatedEyePosSCNV.x * mag
    pointOfView.position.y += rotatedEyePosSCNV.y * mag
    pointOfView.position.z += rotatedEyePosSCNV.z * mag
    
    if gMRActivated{
        VC.sceneView3.pointOfView = pointOfView
    }
    
}

