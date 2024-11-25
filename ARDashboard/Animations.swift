//
//  Animations.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 02/10/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit


func searchBarAnimation(to: SearchBarPosition, sceneView: ARSCNView){
    
    if to == .back {
        gSearchBarInFront = false
        let angles = boxAngles(x: 0, y: 2.75*kDistanceY)
        menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: angles, nodeName: kSearchBarName, search: to, animationDuration: 0.4)
        
    } else if to == .front{
        if gSearchBarInFront == false{
            let angles = boxAngles(x: 0, y: 0)
            menuButtonAnimation(sceneView: sceneView, radius: kDistanceCloseToUserSearch, boxAngles: angles, nodeName: kSearchBarName, search: to, animationDuration: 0.4)
            gSearchBarInFront = true
        }
    }
    
}

// menu buttons going to their places

func allMenuButtonsFadeIn(sceneView: ARSCNView){
    
    let fadeIn1 = SCNAction.fadeOpacity(to: kLeftButtonsAlphaUp, duration: 0.3)
    
    sceneView.scene.rootNode.childNode(withName: kWelcomeNotReallyMenuName, recursively: true)?.runAction(fadeIn1)
    
    sceneView.scene.rootNode.childNode(withName: kRefreshName, recursively: true)?.runAction(fadeIn1)
    sceneView.scene.rootNode.childNode(withName: kUpName, recursively: true)?.runAction(fadeIn1)
    sceneView.scene.rootNode.childNode(withName: kDownName, recursively: true)?.runAction(fadeIn1)
    sceneView.scene.rootNode.childNode(withName: kWriteTweetName, recursively: true)?.runAction(fadeIn1)
    sceneView.scene.rootNode.childNode(withName: kLogoutName, recursively: true)?.runAction(fadeIn1)
    sceneView.scene.rootNode.childNode(withName: kProfilePictureName, recursively: true)?.runAction(fadeIn1)
    sceneView.scene.rootNode.childNode(withName: kHomeName, recursively: true)?.runAction(fadeIn1)
    sceneView.scene.rootNode.childNode(withName: kSearchName, recursively: true)?.runAction(fadeIn1)
    sceneView.scene.rootNode.childNode(withName: kNotificationsName, recursively: true)?.runAction(fadeIn1)
    sceneView.scene.rootNode.childNode(withName: kMRName, recursively: true)?.runAction(fadeIn1)
    
}

func allMenuButtonsFadeGoDown(sceneView: ARSCNView){
    
    let fadeIn0 = SCNAction.fadeOpacity(to: kLeftButtonsAlphaDown, duration: 0.4)
    
    sceneView.scene.rootNode.childNode(withName: kRefreshName, recursively: true)?.runAction(fadeIn0)
    sceneView.scene.rootNode.childNode(withName: kUpName, recursively: true)?.runAction(fadeIn0)
    sceneView.scene.rootNode.childNode(withName: kDownName, recursively: true)?.runAction(fadeIn0)
    sceneView.scene.rootNode.childNode(withName: kWriteTweetName, recursively: true)?.runAction(fadeIn0)
    sceneView.scene.rootNode.childNode(withName: kLogoutName, recursively: true)?.runAction(fadeIn0)
    sceneView.scene.rootNode.childNode(withName: kProfilePictureName, recursively: true)?.runAction(fadeIn0)
    
    sceneView.scene.rootNode.childNode(withName: kSearchName, recursively: true)?.runAction(fadeIn0)
    sceneView.scene.rootNode.childNode(withName: kNotificationsName, recursively: true)?.runAction(fadeIn0)
    sceneView.scene.rootNode.childNode(withName: kMRName, recursively: true)?.runAction(fadeIn0)

}

func allMenuButtonsAnimate(sceneView: ARSCNView){
    
    let buttonsXLeft:CGFloat = -(CGFloat(kNumberColumns-1)/2.0 + 1) * kDistanceX
    let buttonsXRight:CGFloat = -buttonsXLeft
    
    let buttonAnglesRefresh = boxAngles(x: buttonsXRight, y: 2*kDistanceY)
    let buttonAnglesUp = boxAngles(x: buttonsXRight, y: kDistanceY)
    let buttonAnglesDown = boxAngles(x: buttonsXRight, y: 0)
    let buttonAnglesWriteTweet = boxAngles(x: buttonsXRight, y: -kDistanceY)
    let buttonAnglesLogout = boxAngles(x: buttonsXRight, y: -2*kDistanceY)
    
    let buttonsAnglesProfile = boxAngles(x: buttonsXLeft, y: 2*kDistanceY)
    let buttonsAnglesHome = boxAngles(x: buttonsXLeft, y: kDistanceY)
    let buttonsAnglesSearch = boxAngles(x: buttonsXLeft, y: 0)
    let buttonsAnglesNotifications = boxAngles(x: buttonsXLeft, y: -kDistanceY)
    let buttonsAnglesMR = boxAngles(x: buttonsXLeft, y: -2*kDistanceY)
    
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonAnglesRefresh, nodeName: kRefreshName)
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonAnglesUp, nodeName: kUpName)
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonAnglesDown, nodeName: kDownName)
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonAnglesWriteTweet, nodeName: kWriteTweetName)
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonAnglesLogout, nodeName: kLogoutName)
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonsAnglesProfile, nodeName: kProfilePictureName)
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonsAnglesHome, nodeName: kHomeName)
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonsAnglesSearch, nodeName: kSearchName)
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonsAnglesNotifications , nodeName: kNotificationsName)
    menuButtonAnimation(sceneView: sceneView, radius: kDistanceFromUser, boxAngles: buttonsAnglesMR, nodeName: kMRName)
    
    let fadeOut = SCNAction.fadeOut(duration: 0.5)
    sceneView.scene.rootNode.childNode(withName: kWelcomeNotReallyMenuName, recursively: true)?.runAction(fadeOut)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
        sceneView.scene.rootNode.childNode(withName: kWelcomeNotReallyMenuName, recursively: true)?.removeFromParentNode()
    }
    
}

func menuButtonAnimation(sceneView: ARSCNView, radius: CGFloat, boxAngles: boxAngles, nodeName: String, search: SearchBarPosition? = nil, animationDuration:TimeInterval = 0.8){
    
    let (boxNewZ, boxNewX, boxNewY) = SphericalToCarthesianCoordinates(radius: radius, xAngle: boxAngles.x, yAngle: boxAngles.y)
    let position = SCNVector3(boxNewX, boxNewY, -boxNewZ)
    
    let eulerAngleX = newEulerAngle(boxAngles.x)
    var eulerAngleY = newEulerAngle(boxAngles.y)
    
    if (search != nil){
        if search == .back{
            eulerAngleY = -eulerAngleY
        } else if search == .front{
            eulerAngleY = -eulerAngleY
        }
    
    } else {
        eulerAngleY = -eulerAngleY - CGFloat.pi/2
    }
    
    let euler = SCNVector3(eulerAngleY, eulerAngleX, 0)
    
    let move = SCNAction.move(to: position, duration: 0.8)
    let rotation = SCNAction.rotateTo(x: CGFloat(euler.x), y: CGFloat(euler.y), z: CGFloat(euler.z), duration: animationDuration)
    let actions = SCNAction.group([move, rotation])
    
    sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)?.runAction(actions)
}

// tweets nodes

func fadeAnimation(sceneView: ARSCNView, inOut: fade){
    
    var newOpacity = CGFloat()
    if inOut == .In{
        newOpacity = kBoxesAlphaNormal
        fadeComingBackNotHappenedYet = false
    } else {
        newOpacity = 0.0
    }
    
    let fadeIn = SCNAction.fadeOpacity(to: newOpacity, duration: kFadeAnimationDuration)
    var timeDelay:TimeInterval = 0
    
    let childNodes:[SCNNode] = (sceneView.scene.rootNode.childNode(withName: kRootNodeName, recursively: false)?.childNodes)!
    
    var searchString = String()
    
    for u in 0..<kNumberColumns {
        
        let wait02 = SCNAction.wait(duration: timeDelay)
        timeDelay += kFadeAnimationDelay 
        let actionsSequence = SCNAction.sequence([wait02, fadeIn])
        
        if inOut == .In{
            searchString = "\(kRectangleName)-\(u)-"
        } else {
            let reverseNum = (kNumberColumns-1)-u
            searchString = "\(kRectangleName)-\(reverseNum)-"
        }
        
        if u != 0{
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in childNodes{
                if i.name != nil && (i.name?.contains(searchString))!{
                    //print(i.name)
                    //i.runAction(fadeIn)
                    
                    i.runAction(actionsSequence)
                    
                }
            }
            //}
        } else {
            for i in childNodes{
                
                if i.name != nil && (i.name?.contains(searchString))!{
                    i.runAction(fadeIn)
                }
            }
        }
        
    }
    
}

func touchReactivationAfterFadeInAnimation(){
    
    let waitingTimeToReactivateActions = kFadeAnimationDelay * Double(kNumberColumns) + (kFadeAnimationDelay - kFadeAnimationDuration)
    DispatchQueue.main.asyncAfter(deadline: .now() + waitingTimeToReactivateActions){
        gActionInProgress = false
    }
    
}

func hideEVERYTHING(sceneView: ARSCNView, VC: ViewController, hide: Bool){

    sceneView.scene.rootNode.enumerateChildNodes{ (node, stop) -> Void in
        
        if hide {
            node.isHidden = true
            
            if VC.view.viewWithTag(9999999) != nil { //resetButton
                VC.view.viewWithTag(9999999)?.removeFromSuperview()
            }
        } else {
            UIView.animate(withDuration: 0.3){
                node.isHidden = false // tester si l'animation marche
            }
            
        }
        
    }
    
}







