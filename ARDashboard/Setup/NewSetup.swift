//
//  Setup.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 03/10/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit
import TwitterKit
import JGProgressHUD

var fadeComingBackNotHappenedYet = false

func newSetup(kind: KindOfTweet, query: String? = "", max_id: String? = "", upDown: String? = "", sceneView: ARSCNView, VC: ViewController){
    
    fadeComingBackNotHappenedYet = true
    gActionInProgress = true
    
    //safety - begin
    
    let waitingTimeToReactivateActions:TimeInterval = 25
    DispatchQueue.main.asyncAfter(deadline: .now() + waitingTimeToReactivateActions){
        gActionInProgress = false
    }
    
    //safety - end
    
    let timer = ParkBenchTimer()
    fadeAnimation(sceneView: sceneView, inOut: .Out)
    
    // showing a message if it takes too long
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
        if (fadeComingBackNotHappenedYet == true) {
            hud = JGProgressHUD(style: .extraLight)
            hud.indicatorView = nil
            print("taking too long to load")
            hud.position = .bottomCenter
            hud.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
            hud.textLabel.text = "Loading..."
            hud.show(in: sceneView, animated: true)
        }
    }
    
    getTweets(kind: kind, query: query, max_id: max_id, completion: {(tweets, error) -> Void in
        
        //getImages in cache
        
        if error == nil{
            
            VC.savedTweets = tweets!
            
            // case: did not go down
            if max_id != "" && upDown == "down" && gTweetsIdsUpDown.indices.contains(gCurrentIndexUpDown+2) == false{ //+2 car

                if (tweets!.count >= kNumberLines*kNumberColumns){
                    gTweetsIdsUpDown[gCurrentIndexUpDown+1][1] = tweets![kNumberLines*kNumberColumns].tweetID //normal
                } else {
                    gTweetsIdsUpDown[gCurrentIndexUpDown+1][1] = tweets![tweets!.count-1].tweetID // au cas où quand ça crash
                }
                
                gTweetsIdsUpDown.append([tweets![0].tweetID, "-1"])
                gCurrentIndexUpDown += 1

            //case: already went down
            } else if max_id != "" && upDown == "down" && gTweetsIdsUpDown.indices.contains(gCurrentIndexUpDown+2) == true{
                gCurrentIndexUpDown += 1
            } else if max_id != "" && upDown == "up"{ //case: going back up
                gCurrentIndexUpDown -= 1
            } else { //other
                gTweetsIdsUpDown.removeAll()
                gCurrentIndexUpDown = 0
                
                if tweets?.count == kNumberLines*kNumberColumns{
                    gTweetsIdsUpDown.append(["-1", tweets![kNumberLines*kNumberColumns].tweetID])
                } else {
                    gTweetsIdsUpDown.append(["-1", "-1"])
                }
                
                 // index 0
                gTweetsIdsUpDown.append([tweets![0].tweetID, "-1"]) // index 1
            }
            
            savePictures(tweets: tweets!, kindPhotosSaved: .normalTweetPhotos, completion: {(error) -> Void in
                
                if error == nil {
                    
                    gCurrentView = kind
                    
                    let timeToFade = kFadeAnimationDelay*TimeInterval(kNumberColumns) + (kFadeAnimationDuration - kFadeAnimationDelay) + 0.1 //1.7, 0.1 en bonus
                    
                    let howLongAgo = TimeInterval(timer.stop())
                    let timeLeftAnimation = timeToFade - howLongAgo
                    
                    // au cas ou par exemple il y a eu l'affichage loading...
                    if hud.isVisible{
                        hud.dismiss(animated: true)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeLeftAnimation) { // avant c'était 4.0
                        
                        setupNewInterface(sceneView: sceneView, tweets: tweets!, completion: {(error) -> Void in
                            
                            if hud.isVisible{
                                hud.dismiss(animated: true)
                            }
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                fadeAnimation(sceneView: sceneView, inOut: .In)
                                
                                touchReactivationAfterFadeInAnimation()
                                
                                if hud.isVisible{
                                    hud.dismiss(animated: true)
                                }
                                
                            }
                        })
                    }
                    
                } else { // error saving pictures
                    
                    gActionInProgress = false
                    
                    hud = JGProgressHUD(style: .extraLight)
                    hud.indicatorView = nil
                    print("error-saving pictures-newsetup")
                    hud.position = .bottomCenter
                    hud.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
                    hud.textLabel.text = "Connection Error\nTry again"
                    hud.show(in: sceneView, animated: false)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                        hud.dismiss(animated: true)
                    }
                    
                    //putting back the screen
                    
                    let timeToFade = kFadeAnimationDelay*TimeInterval(kNumberColumns) + (kFadeAnimationDuration - kFadeAnimationDelay) + 0.1
                    let howLongAgo = TimeInterval(timer.stop())
                    let timeLeftAnimation = timeToFade - howLongAgo
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeLeftAnimation) {
                        fadeAnimation(sceneView: sceneView, inOut: .In)
                        
                        touchReactivationAfterFadeInAnimation()
                    }
                    
                }
                
            })
            
            
        } else { // error loading tweets
            
            gActionInProgress = false
            
            hud = JGProgressHUD(style: .extraLight)
            hud.indicatorView = nil
            print("error-twitter data saving-newsetup")
            hud.position = .bottomCenter
            hud.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
            hud.textLabel.text = "Connection Error\nTry again"
            hud.show(in: sceneView, animated: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                hud.dismiss(animated: true)
            }
            
            //putting back the screen
            
            let timeToFade = kFadeAnimationDelay*TimeInterval(kNumberColumns) + (kFadeAnimationDuration - kFadeAnimationDelay) + 0.1
            let howLongAgo = TimeInterval(timer.stop())
            let timeLeftAnimation = timeToFade - howLongAgo
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeLeftAnimation) {
                fadeAnimation(sceneView: sceneView, inOut: .In)
                touchReactivationAfterFadeInAnimation()
            }
            
        }
    })
    
}


func setupNewInterface(sceneView: ARSCNView, tweets: [TWTRTweet], completion: @escaping (Error?) -> Void){
    
    var tweetNumber = 0
    var tweetsDone = 0
    
    for u in 0..<kNumberColumns{
        
        for o in 0..<kNumberLines{
            
            let searchString = "\(kRectangleName)-\(u)-\(o)"
            
            let node = sceneView.scene.rootNode.childNode(withName: searchString, recursively: true)
            
            var tweetContentToSend:tweetContent?
            
            // if tweet exists
            if tweetNumber < tweets.count {
                
                var tweetText: String
                if tweets[tweetNumber].text != nil {
                    tweetText = textLinksCleaning(tweets[tweetNumber].text)
                } else {
                    tweetText = ""
                }
                
                tweetContentToSend = tweetContent(title: tweets[tweetNumber].author.name ,
                                                  twitterId: tweets[tweetNumber].author.screenName ,
                                                  content: tweetText ,
                                                  logo: "OFlogo.png",
                                                  image: "testContent2_rounded2.jpg",
                                                  date: tweets[tweetNumber].createdAt,
                                                  tweetID: tweets[tweetNumber].tweetID,
                                                  like: tweets[tweetNumber].isLiked,
                                                  retweet: tweets[tweetNumber].isRetweeted )
                
            } else {
                tweetContentToSend = nil
                
            }
            
            imageUpdate(tweetContentToSend: tweetContentToSend, node: node!, completion: {(error) -> Void in
                tweetsDone += 1
                
                if (tweetsDone == kTotalColumnsLines){
                    completion(nil)
                }
            })

            tweetNumber += 1;
        }
    }
    
}

func imageUpdate(tweetContentToSend: tweetContent?, node: SCNNode, completion: @escaping (Error?) -> Void){
    
    if tweetContentToSend != nil{
        
        if let image = tweetImage(tweetContent: tweetContentToSend!, fontColor: .black, imageSize: CGSize(width: 1000, height: 750), backgroundColor: .white){
        
            node.geometry?.materials[0].diffuse.contents = image
            
            completion(nil)
            
        }
            
        
    } else {
        
        node.geometry?.materials[0].diffuse.contents = UIColor.white
        
        completion(nil)
    }
    
}





