//
//  Stabilization.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 12/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit

var smallImprovement = false

func testingStabilization(sceneView: ARSCNView, VC: ViewController) {
    
    DispatchQueue.main.async {
        
        if smallImprovement == false{
            removeAllFeaturePointsSphere(sceneView: sceneView)
            showAllFeaturePointsWithSpheres(sceneView: sceneView)
            smallImprovement = true
        } else {
            smallImprovement = false
        }
    }
        
    let screenCenter: CGPoint = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
    let screenWidthUnit = sceneView.bounds.width/4
    let screenHeightUnit = sceneView.bounds.height/4
    
    let location1: CGPoint = CGPoint(x: screenWidthUnit*1, y: screenHeightUnit*1)
    let location2: CGPoint = CGPoint(x: screenWidthUnit*2, y: screenHeightUnit*1)
    let location3: CGPoint = CGPoint(x: screenWidthUnit*3, y: screenHeightUnit*1)
    let location4: CGPoint = CGPoint(x: screenWidthUnit*1, y: screenHeightUnit*2)
    let location5: CGPoint = CGPoint(x: screenWidthUnit*2, y: screenHeightUnit*3)
    let location6: CGPoint = CGPoint(x: screenWidthUnit*3, y: screenHeightUnit*2)
    let location7: CGPoint = CGPoint(x: screenWidthUnit*1, y: screenHeightUnit*3)
    let location8: CGPoint = CGPoint(x: screenWidthUnit*3, y: screenHeightUnit*1)
    
    let locationArray = [screenCenter, location1, location2, location3, location4, location5, location6, location7, location8]
    
    if planeFoundAnalyses(points: locationArray, sceneView: sceneView) {
        
        if let s = sceneView.session.currentFrame?.camera.trackingState{
            switch(s){
            case .normal:
                
                DispatchQueue.main.async {
                    removeAllFeaturePointsSphere(sceneView: sceneView)
                }
                
                moveableRootNodeSetup(sceneView: sceneView)
                
                VC.worldStabilizationReady = true
                
                addResetButton(VC: VC)
                VC.HUDdismiss()
                
                if gSessionInterrupted == false {
                    allMenuButtonsFadeIn(sceneView: sceneView)
                }
                
            default:
                //VC.showMessage("DETECTED")
                //print("DETECTED")
                break;
            }
        }
        
    } else {
        
    }
    
}

func moveableRootNodeSetup(sceneView: ARSCNView, resetButton: Bool = false){
    if let rootNodeMoveable:SCNNode = sceneView.scene.rootNode.childNode(withName: kRootNodeName, recursively: true){
        
        var tests = 0
        var currentFrameTestNil:ARFrame? = nil
        
        repeat {
            
            currentFrameTestNil = sceneView.session.currentFrame
            
            if let currentFrame = currentFrameTestNil {
                
                var newPosition = currentFrame.camera.transform.position()
                
                if resetButton == false {
                    newPosition.y += 0.20
                }
                
                let newRotationY = currentFrame.camera.eulerAngles.y
                let newRotation = SCNVector3Make(0, newRotationY, 0)
                
                rootNodeMoveable.position = newPosition
                rootNodeMoveable.eulerAngles = newRotation
                
            }
            
            tests += 1
            
        } while (currentFrameTestNil == nil && tests < 15)
    
    }
}

func showAllFeaturePointsWithSpheres(sceneView: ARSCNView){
    
    if let points:[vector_float3] = sceneView.session.currentFrame?.rawFeaturePoints?.points {
        
        for index in 0..<points.count {
            
            if points.count > 120 && index % 2 == 0 {
                continue
            }
            
            let point = points[index]
            let pointVect3 = SCNVector3Make(point.x, point.y, point.z)
            let sphereGeometry = SCNSphere(radius: 0.007)
            let sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = pointVect3
            sphereNode.name = kFeaturePointName
            sceneView.scene.rootNode.addChildNode(sphereNode)
        }
    }
}

func removeAllFeaturePointsSphere(sceneView: ARSCNView){
    sceneView.scene.rootNode.enumerateChildNodes{ (node, stop) -> Void in
        if node.name == kFeaturePointName{
            node.removeFromParentNode()
        }
    }
}

func centerViewTouchesWelcomeLogo(sceneView: ARSCNView, VC: ViewController){
    
    let location = CGPoint(x: sceneView.bounds.width/2, y: sceneView.bounds.height/2)
    
    let halfW:CGFloat = sceneView.bounds.width/2
    let halfH:CGFloat = sceneView.bounds.height/2
    let quarter:CGFloat = sceneView.bounds.width/4 //90
    let halfAQuarter:CGFloat = quarter/2 //45
    
    let location1 = CGPoint(x: halfW+quarter, y: halfH)
    let location2 = CGPoint(x: halfW+halfAQuarter, y: halfH+halfAQuarter)
    let location3 = CGPoint(x: halfW-halfAQuarter, y: halfH+halfAQuarter)
    let location4 = CGPoint(x: halfW-quarter, y: halfH)
    let location5 = CGPoint(x: halfW, y: halfH-quarter)
    let location6 = CGPoint(x: halfW-halfAQuarter, y: halfH-halfAQuarter)
    let location7 = CGPoint(x: halfW, y: halfH+quarter)
    let location8 = CGPoint(x: halfW+halfAQuarter, y: halfH-halfAQuarter)
    
    let location9 = CGPoint(x: halfW+halfAQuarter, y: halfH)
    let location10 = CGPoint(x: halfW-halfAQuarter, y: halfH)
    let location11 = CGPoint(x: halfW, y: halfH+halfAQuarter)
    let location12 = CGPoint(x: halfW, y: halfH-halfAQuarter)
    
    let locationArray = [location, location1, location2, location3, location4, location5, location6, location7, location8, location9, location10, location11, location12]
    
    if centerViewTouchesAnalysis(points: locationArray, sceneView: sceneView){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            allMenuButtonsFadeGoDown(sceneView: sceneView)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            allMenuButtonsAnimate(sceneView: sceneView)
            fadeAnimation(sceneView: sceneView, inOut: .In)
            
            touchReactivationAfterFadeInAnimation()

        }
        
        VC.worldShown = true
    }
    
}

func centerViewTouchesAnalysis(points: [CGPoint], sceneView: ARSCNView) -> Bool{
    
    for location in points{
        
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults.first!
            
            if result.node.name == kWelcomeNotReallyMenuName{
                return true
            }
        }
        
    }
    return false
    
}

func planeFoundAnalyses(points: [CGPoint], sceneView: ARSCNView) -> Bool{
    
    for location in points{
        
        let planeTestResults = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])
        
        if let result = planeTestResults.first {
            return true
        }
        
    }
    return false
    
}



