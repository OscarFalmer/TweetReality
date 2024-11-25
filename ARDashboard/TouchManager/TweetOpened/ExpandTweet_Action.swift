//
//  ExpandTweet_Action.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 17/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit
import TwitterKit
import Kingfisher

func expandAction(node: SCNNode, VC: ViewController){
    
    replyTweetAnimation(node: node, sceneView: VC.sceneView, position: .back)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        showExpandedTweet(node: node, VC: VC)
    }
    
}

func expandReverseAction(VC: ViewController){
    
    gExpandedTweetOpened = false
    
    if let expandNode = VC.sceneView.scene.rootNode.childNode(withName: kExpandName, recursively: true){
        replyTweetAnimation(node: expandNode, sceneView: VC.sceneView, position: .front)
    }
    
    let fadeOut = SCNAction.fadeOut(duration: 0.2)
    VC.sceneView.scene.rootNode.childNode(withName: kExpandedTweetName, recursively: true)?.runAction(fadeOut)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
        VC.sceneView.scene.rootNode.childNode(withName: kExpandedTweetName, recursively: true)?.removeFromParentNode()
    }
    
}

func saveExpandedTweetPhoto(){
    
    let tweet = gTweetOpened
    var tweetToSend: tweetContent
    var tweetText: String
    
    if tweet?.text != nil {
        tweetText = textLinksCleaning((tweet?.text)!)
    } else {
        tweetText = ""
    }
    
    tweetToSend = tweetContent(title: tweet?.author.name ?? "", twitterId: tweet?.author.screenName ?? "", content: tweetText, logo: "TheVergeCircle.png", image: "testContent_rounded2.jpg", date: tweet?.createdAt ?? Date(), tweetID: tweet?.tweetID ?? "", like: false, retweet: false)
    
    // Visual informations
    
    var heightDependingOfTheText:CGFloat = boxSizeMini.height //(0.15)
    if gHeightActuallyNeededForExpandedTweet > heightDependingOfTheText {
        heightDependingOfTheText = gHeightActuallyNeededForExpandedTweet
    }
    
    let boxSize = CGSize(width: 2*boxSizeMini.width, height: 2*heightDependingOfTheText)
    /* because
     addTextOnBox_ImageVersion(tweetContent: tweetContent, geometry: geometry, width: boxSize.width*2, height: boxSize.height*2, expandedTweet: true)
     */
    
    if tweetToSend.content != ""{
        
        let proportion:CGFloat = boxSize.height/boxSize.width
        
        if let image = tweetImage(tweetContent: tweetToSend, fontColor: .black, imageSize: CGSize(width: 1000, height: 1000*proportion), backgroundColor: .white, expanded: true){
            
            ImageCache.default.store(image, forKey: "expanded-photo")
            
        }
    } else {
        //seum
        //enlève la photo pour pas qu'il y ait un mauvais tweet
        ImageCache.default.removeImage(forKey: "expanded-photo")
    }
    
}

func showExpandedTweet(node: SCNNode, VC: ViewController){
    
    var fadeIn = SCNAction.fadeIn(duration: 0.1)
    node.runAction(fadeIn)
    
    gExpandedTweetOpened = true

    // faire un addBox spécial
    
    var heightDependingOfTheText:CGFloat = boxSizeMini.height //(0.15)
    
    //calculer avant quand le tweet est ouvert
    print("MICKAEL JACKSON : \(gHeightActuallyNeededForExpandedTweet)")
    
    if gHeightActuallyNeededForExpandedTweet > heightDependingOfTheText {
        heightDependingOfTheText = gHeightActuallyNeededForExpandedTweet
    }
    
    let boxSize = CGSize(width: boxSizeMini.width, height: heightDependingOfTheText)
    
    var distanceFromUser: CGFloat = kDistanceCloseToUserSearch
    
    let xAngle = nameToXangle(nodeName: (node.parent?.name)!)
    let angles = boxAngles(x: xAngle, y: 0)
    
    distanceFromUser = kDistanceCloseToUser
    
    addBoxWithAngles(radius: distanceFromUser, boxAngles: angles, boxSize: boxSize, name: kExpandedTweetName, sceneView: VC.sceneView, opacity: 0, tweet: gTweetOpened, expandedTweet: true) //newTweet = true
    
    fadeIn = SCNAction.fadeIn(duration: 0.3)
    VC.sceneView.scene.rootNode.childNode(withName: kExpandedTweetName, recursively: true)?.runAction(fadeIn)
    
}

func getTweetHeightExpanded(tweet: TWTRTweet, completion: @escaping (CGFloat?, Error?) -> Void) {
    //completion to clean
    let tweet = gTweetOpened
    
    var tweetText: String
    if tweet?.text != nil {
        tweetText = textLinksCleaning((tweet?.text)!)
    } else {
        tweetText = ""
    }
    
    let tweetToSend = tweetContent(title: tweet?.author.name ?? "", twitterId: tweet?.author.screenName ?? "", content: tweetText, logo: "TheVergeCircle.png", image: "testContent_rounded2.jpg", date: tweet?.createdAt ?? Date(), tweetID: tweet?.tweetID ?? "", like: false, retweet: false)
    heightNeededForExpandedTweetCalculation(tweetContent: tweetToSend, completion: {(width, height, error) -> Void in
        if width != nil && height != nil {
            
            completion(boxSizeMini.width * (height!/width!), nil)
            return
        } else {
            
            completion(nil, nil)
            return
            
        }
    })
    
    completion(nil, nil)
}

func getStringHeight(mytext: String, fontSize: CGFloat, width: CGFloat)->CGFloat {
    
    let font = UIFont.systemFont(ofSize: fontSize)
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = .byWordWrapping;
    let attributes = [NSAttributedStringKey.font:font,
                      NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]
    
    let text = mytext as NSString
    let rect = text.boundingRect(with: size,
                                options:.usesLineFragmentOrigin,
                                attributes: attributes,
                                context:nil)
    
    return rect.size.height
}

