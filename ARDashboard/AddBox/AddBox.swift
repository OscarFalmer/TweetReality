//
//  AddBox.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 16/09/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import TwitterKit

//var boxCoordinnates = [[]]()

func addBoxWithAnglesButtons(radius: CGFloat, radiusOnCircle: CGFloat, angle: CGFloat, boxSize: CGSize, name:String = kRectangleName, sceneView: ARSCNView, opacity:CGFloat = 0, MenuButton: Menu? = nil, tweet: TWTRTweet? = nil){
    
    var position = SCNVector3(0,0,-radius)
    
    if MenuButton != Menu.WelcomeNotReallyMenu{
        let (circleX, circleY, circleZ) = CircleCoordinates(radiusFromUser: radius, angle: angle, radiusOnCircle: radiusOnCircle)
        position = SCNVector3(circleX, circleY, -circleZ)
    }
    
    var tweetToSend: tweetContent
    let isLiked = tweet?.isLiked ?? false
    let isRetweeted = tweet?.isRetweeted ?? false
    
    var tweetText: String
    
    if tweet?.text != nil {
        tweetText = textLinksCleaning((tweet?.text)!)
    } else {
        tweetText = ""
    }
    
    tweetToSend = tweetContent(title: tweet?.author.name ?? "", twitterId: tweet?.author.screenName ?? "", content: tweetText, logo: "OFlogo.png", image: "testContent2_rounded2.jpg", date: tweet?.createdAt ?? Date(), tweetID: tweet?.tweetID ?? "", like: isLiked, retweet: isRetweeted)
    
    let euler = SCNVector3(-CGFloat.pi/2, 0, 0)
    
    addBox(tweetContent: tweetToSend, boxSize: boxSize, position: position, eulerAngle: euler, sceneView: sceneView, opacity: opacity, name: name, MenuButton: MenuButton)
}

func addBoxWithAngles(radius: CGFloat, boxAngles: boxAngles, boxSize: CGSize, name:String = kRectangleName, sceneView: ARSCNView,
                      opacity:CGFloat = kBoxesAlphaNormal, MenuButton: Menu? = nil, tweet: TWTRTweet? = nil, search: Bool? = false, newTweet: Bool? = false, expandedTweet: Bool? = false){
    
    let isLiked = tweet?.isLiked ?? false
    let isRetweeted = tweet?.isRetweeted ?? false
    
    var euler = SCNVector3()
    var position = SCNVector3()
    
    if boxAngles.x == 0 && boxAngles.y == 0{
        euler = SCNVector3(0, 0, 0)
        position = SCNVector3(0, 0, -radius)
    } else {
        var xNegative = false
        var yNegative = false
        var xAngleBis = boxAngles.x
        var yAngleBis = boxAngles.y
        
        if xAngleBis < 0 {
            xNegative = true
            xAngleBis = -xAngleBis
        }
        
        if yAngleBis < 0 {
            yNegative = true
            yAngleBis = -yAngleBis
        }
        
        var (boxNewZ, boxNewX, boxNewY) = SphericalToCarthesianCoordinates(radius: radius, xAngle: xAngleBis, yAngle: yAngleBis)
        
        // il y a du code à virer
        
        var eulerAngleX = newEulerAngle(xAngleBis)
        var eulerAngleY = newEulerAngle(yAngleBis)
        
        if xNegative{
            eulerAngleX = -eulerAngleX
            boxNewX = -boxNewX
        }
        
        if yNegative{
            boxNewY = -boxNewY
        } else {
            eulerAngleY = -eulerAngleY
        }
        
        //    if (xAngle != 0 && yAngle != 0){ // à comprendre
        //        //eulerAngleY = -eulerAngleY
        //    }
        
        if MenuButton != nil {
            eulerAngleY = eulerAngleY - CGFloat.pi/2
        }
        
        euler = SCNVector3(eulerAngleY, eulerAngleX, 0)
        position = SCNVector3(boxNewX, boxNewY, -boxNewZ)
    }
    
    var tweetToSend: tweetContent
    var tweetText: String
    
    if tweet?.text != nil {
        tweetText = textLinksCleaning((tweet?.text)!)
    } else {
        tweetText = ""
    }
    
    tweetToSend = tweetContent(title: tweet?.author.name ?? "", twitterId: tweet?.author.screenName ?? "", content: tweetText, logo: "TheVergeCircle.png", image: "testContent_rounded2.jpg", date: tweet?.createdAt ?? Date(), tweetID: tweet?.tweetID ?? "", like: isLiked, retweet: isRetweeted)
    
    addBox(tweetContent: tweetToSend, boxSize: boxSize, position: position, eulerAngle: euler, sceneView: sceneView, opacity: opacity, name: name, MenuButton: MenuButton, Search: search, NewTweet: newTweet, ExpandedTweet: expandedTweet)
    
}

func addBox(tweetContent: tweetContent, boxSize: CGSize, position: SCNVector3, eulerAngle: SCNVector3, sceneView: ARSCNView? = nil,
            opacity:CGFloat = kBoxesAlphaNormal, name:String = kRectangleName, rootNode:SCNNode? = nil, testNoContent:Bool = false,
            UnderTweet:UnderOpenTweet? = nil, text:Bool? = false, textString:String? = "", MenuButton:Menu? = nil, Search: Bool? = false, NewTweet: Bool? = false, ExpandedTweet: Bool? = false){
    
    // Creation of the Geometric object
    
    var geometry = SCNGeometry()
    let rectangleIncurve = SCNBox(width: boxSize.width, height: boxSize.height, length: 0.02, chamferRadius: 0.01)
    
    if MenuButton != nil{
        let cylinder = SCNCylinder(radius: boxSize.height/2, height: 0.02)
        geometry = cylinder
    } else {
        geometry = rectangleIncurve
    }
    
    geometry.materials.first?.diffuse.contents = UIColor.blue
    
    // Creation of the node that contains the object created
    
    let geometryNode = SCNNode(geometry: geometry)
    geometryNode.opacity = opacity
    geometryNode.position = position
    geometryNode.eulerAngles = eulerAngle
    geometryNode.name = name
    geometryNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
    geometryNode.physicsBody?.isAffectedByGravity = false
    
    // Adding text as a child of the rectangle node

    if !testNoContent{
        
        if Search! {
            
            addTextOnBox(width: boxSize.width, height: boxSize.height, geometry: geometry, geometryNode: geometryNode, sceneView: sceneView!, textBoxType: .searchBar)
        } else if NewTweet!{
            addTextOnBox(width: boxSize.width, height: boxSize.height, geometry: geometry, geometryNode: geometryNode, sceneView: sceneView!, textBoxType: .newTweetLenght)
            addTextOnBox(width: boxSize.width, height: boxSize.height, geometry: geometry, geometryNode: geometryNode, sceneView: sceneView!, textBoxType: .newTweet)
        } else if MenuButton != nil{
            addTextOnBox_ImageVersion(tweetContent: tweetContent, geometry: geometry, width: boxSize.width*2, height: boxSize.height*2, MenuButton: MenuButton)
        } else if UnderTweet != nil{
            addTextOnBox_ImageVersion(tweetContent: tweetContent, geometry: geometry, width: boxSize.width*2, height: boxSize.height*2, UnderTweet: UnderTweet!)
        } else if text!{
            addTextOnBox_ImageVersion(tweetContent: tweetContent, geometry: geometry, width: boxSize.width*2, height: boxSize.height*2, text: true, textString: textString)
        } else if ExpandedTweet! {
            addTextOnBox_ImageVersion(tweetContent: tweetContent, geometry: geometry, width: boxSize.width*2, height: boxSize.height*2, expandedTweet: true)
        } else {
            if position.x == 0 && position.y == 0{
                addTextOnBox_ImageVersion(tweetContent: tweetContent, geometry: geometry, width: boxSize.width*2, height: boxSize.height*2, centerTweet: true)
            } else {
                addTextOnBox_ImageVersion(tweetContent: tweetContent, geometry: geometry, width: boxSize.width*2, height: boxSize.height*2)
            }
            
        }
        
    }
    
    if (UnderTweet == UnderOpenTweet.Like
        && ((tweetContent.like == true && gTweetUnLikes.contains(tweetContent.tweetID) == false)
            || gTweetLikes.contains(tweetContent.tweetID))) {

        geometryNode.rotation = SCNVector4(0, 1, 0, CGFloat.pi)
    }
    
    if (UnderTweet == UnderOpenTweet.Retweet
        && ((tweetContent.retweet == true && gTweetUnRetweets.contains(tweetContent.tweetID) == false)
            || gTweetRetweets.contains(tweetContent.tweetID))){

        geometryNode.rotation = SCNVector4(0, 1, 0, CGFloat.pi)
    }
    
    if rootNode == nil{
        
        if let rootNodeMoveable = sceneView?.scene.rootNode.childNode(withName: kRootNodeName, recursively: true){
            
            rootNodeMoveable.addChildNode(geometryNode)
        }
    } else {
        rootNode?.addChildNode(geometryNode)
    }
    
}







