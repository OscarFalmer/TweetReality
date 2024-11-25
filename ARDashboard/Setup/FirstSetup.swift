//
//  firstSetup.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 10/10/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit
import TwitterKit

func setup(kind: KindOfTweet, VC: ViewController){
    
    // set up new root node that is going to be move afterwards
    
    let rootNoteMoveable = SCNNode()
    rootNoteMoveable.name = kRootNodeName
    rootNoteMoveable.position = SCNVector3(0, 0, 0)
    rootNoteMoveable.eulerAngles = VC.sceneView.scene.rootNode.eulerAngles
    
    VC.sceneView.scene.rootNode.addChildNode(rootNoteMoveable)
    
    if hud.isVisible{
        hud.dismiss(animated: false)
    }
    
    VC.showHUDWithTransform()
    
    getTweets(kind: kind, completion: {(tweets, error) -> Void in
        
        //getImages in cache
        
        if error == nil{
            
            hud.setProgress(33/100.0, animated: true)
            
            VC.savedTweets = tweets!
            
            gCurrentIndexUpDown = 0
            gTweetsIdsUpDown.append(["-1", tweets![kNumberLines*kNumberColumns].tweetID]) //index 0
            gTweetsIdsUpDown.append([tweets![0].tweetID, "-1"]) // index 1
            
            savePictures(tweets: tweets!, firstSetup: true, kindPhotosSaved: .normalTweetPhotos, completion: {(error) -> Void in
                
                if error == nil {
                    
                    hud.setProgress(100/100.0, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        
                        setupInterface(tweets: tweets!, sceneView: VC.sceneView)
                        
                        VC.HUDtoBottomPlaneDetection()
                        
                        VC.worldReadyToBeShown = true
                        
                        print("-WORLD READY-")
                        
                    }
                    
                } else {
                    print("error-pictures saving-firstsetup")
                    
                    hud.textLabel.text = "Connection Error\nTrying again..."
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        setup(kind: gCurrentView, VC: VC)
                    }
                    
                }
            })
        } else {
            print("error-twitter data saving-firstsetup")
            hud.textLabel.text = "Connection Error\nTrying again..."
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                setup(kind: gCurrentView, VC: VC)
            }
        }
    })
}

func setupInterface(tweets: [TWTRTweet], sceneView: ARSCNView){
    
    // Boxes
    
    var x:CGFloat = -CGFloat(kNumberColumns-1)/2.0 * kDistanceX
    
    var tweetNumber = 0
    
    for i in 0..<kNumberColumns {
        
        var y:CGFloat = CGFloat(kNumberLines-1)/2.0 * kDistanceY
        
        for u in 0..<kNumberLines {
            let angles = boxAngles(x: x, y: y)
            let name = "\(kRectangleName)-\(i)-\(u)"
            
            if tweetNumber < tweets.count{
                addBoxWithAngles(radius: kDistanceFromUser, boxAngles: angles, boxSize: boxSizeMini, name: name, sceneView: sceneView, opacity: 0, tweet: tweets[tweetNumber])
            } else {
                addBoxWithAngles(radius: kDistanceFromUser, boxAngles: angles, boxSize: boxSizeMini, name: name, sceneView: sceneView, opacity: 0, tweet: nil)
            }

            tweetNumber += 1
            
            y -= kDistanceY
        }
        
        x += kDistanceX
    }
    
    // Menu buttons
    
    // Left Menu
    
    let buttonsAngles1:CGFloat = 18
    let buttonsAngles2:CGFloat = 54
    let buttonsAngles3:CGFloat = 90
    let buttonsAngles4:CGFloat = 126
    let buttonsAngles5:CGFloat = 162
    let buttonsAngles6:CGFloat = 198
    let buttonsAngles7:CGFloat = 234
    let buttonsAngles8:CGFloat = 270
    let buttonsAngles9:CGFloat = 306
    let buttonsAngles10:CGFloat = 342
    
    let radiusOnCircle:CGFloat = 0.3
    
    let kDistanceFromUserSpecial:CGFloat = 1.2 // au lieu de 0.9
    
    let buttonsSize = CGSize(width: boxSizeMini.height, height: boxSizeMini.height)
    
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles1, boxSize: buttonsSize, name: kWelcomeNotReallyMenuName, sceneView: sceneView, opacity: 0, MenuButton: Menu.WelcomeNotReallyMenu)
    
    let rotateAction = SCNAction.rotateBy(x: 0, y: 0.9, z: 0, duration: 1)
    let foreverAction = SCNAction.repeatForever(rotateAction)
    sceneView.scene.rootNode.childNode(withName: kWelcomeNotReallyMenuName, recursively: true)?.runAction(foreverAction)
    
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles3, boxSize: buttonsSize, name: kProfilePictureName, sceneView: sceneView, opacity: 0, MenuButton: Menu.Profile)
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles4, boxSize: buttonsSize, name: kHomeName, sceneView: sceneView, opacity: 0, MenuButton: Menu.Home)
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles5, boxSize: buttonsSize, name: kSearchName, sceneView: sceneView, opacity: 0, MenuButton: Menu.Search)
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles6, boxSize: buttonsSize, name: kNotificationsName, sceneView: sceneView, opacity: 0, MenuButton: Menu.Notifications)
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles7, boxSize: buttonsSize, name: kMRName, sceneView: sceneView, opacity: 0, MenuButton: Menu.MR)
    
    // Right Menu
    
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles2, boxSize: buttonsSize, name: kRefreshName, sceneView: sceneView, opacity: 0, MenuButton: Menu.Refresh)
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles1, boxSize: buttonsSize, name: kUpName, sceneView: sceneView, opacity: 0, MenuButton: Menu.Up)
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles10, boxSize: buttonsSize, name: kDownName, sceneView: sceneView, opacity: 0, MenuButton: Menu.Down)
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles9, boxSize: buttonsSize, name: kWriteTweetName, sceneView: sceneView, opacity: 0, MenuButton: Menu.WriteTweet)
    addBoxWithAnglesButtons(radius: kDistanceFromUserSpecial, radiusOnCircle: radiusOnCircle, angle: buttonsAngles8, boxSize: buttonsSize, name: kLogoutName, sceneView: sceneView, opacity: 0, MenuButton: Menu.Logout)
    
    
}
