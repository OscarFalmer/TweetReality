//
//  Tweet_ComingForward.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit
import TwitterKit
import JGProgressHUD

func tweetComingForward(node: SCNNode, boxSize: CGSize, sceneView: ARSCNView, VC: ViewController){
    
    let margin = boxSize.height/5
    
    let currentTweet = getTweetOpened(nodeParent: node, VC: VC)
    
    let newTweet = tweetContent(title: "", twitterId: currentTweet.tweetID, content: "", logo: "", image: "", date: Date(), tweetID: currentTweet.tweetID, like: currentTweet.isLiked, retweet: currentTweet.isRetweeted)
    
    let eulerAngle = SCNVector3(0, 0, 0)
    
    let LikeRetweetBoxSizeHeight = boxSize.height/2
    let LikeRetweetBoxSizeWidth = (boxSize.width - margin)/2
    let LikeRetweetBoxSize = CGSize(width: LikeRetweetBoxSizeWidth, height: LikeRetweetBoxSizeHeight)
    
    let ExpandY = boxSize.height/2 - LikeRetweetBoxSize.height/2
    let ExpandX = -LikeRetweetBoxSize.width/2 - margin - boxSize.width/2
    let ExpandPosition = SCNVector3(ExpandX, ExpandY, 0)
    
    let ShareX = LikeRetweetBoxSize.width/2 + margin + boxSize.width/2
    let SharePosition = SCNVector3(ShareX, ExpandY, 0)
    
    let LikeY = -boxSize.height/2 - margin - LikeRetweetBoxSize.height/2
    let LikeX = -margin/2 - LikeRetweetBoxSize.width/2
    let LikeBoxPosition = SCNVector3(LikeX, LikeY, 0)
    
    let RetweetBoxPosition = SCNVector3(LikeX + LikeRetweetBoxSize.width + margin, LikeY, 0)
    
    let CommentBoxSize = CGSize(width: boxSize.width, height: LikeRetweetBoxSizeHeight)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
        addBox(tweetContent: newTweet,
               boxSize: LikeRetweetBoxSize,
               position: ExpandPosition,
               eulerAngle: eulerAngle,
               opacity: 0.0,
               name: kExpandName,
               rootNode: node,
               testNoContent: false,
               UnderTweet: UnderOpenTweet.Expand)
        
        addBox(tweetContent: newTweet,
               boxSize: LikeRetweetBoxSize,
               position: SharePosition,
               eulerAngle: eulerAngle,
               opacity: 0.0,
               name: kShareName,
               rootNode: node,
               testNoContent: false,
               UnderTweet: UnderOpenTweet.Share)
        
        addBox(tweetContent: newTweet,
               boxSize: LikeRetweetBoxSize,
               position: LikeBoxPosition,
               eulerAngle: eulerAngle,
               opacity: 0.0,
               name: kLikeName,
               rootNode: node,
               testNoContent: false,
               UnderTweet: UnderOpenTweet.Like)
        
        addBox(tweetContent: newTweet,
               boxSize: LikeRetweetBoxSize,
               position: RetweetBoxPosition,
               eulerAngle: eulerAngle,
               opacity: 0.0,
               name: kRetweetName,
               rootNode: node,
               testNoContent: false,
               UnderTweet: UnderOpenTweet.Retweet)
        
        let fadeIn = SCNAction.fadeIn(duration: 0.3)
        
        node.childNode(withName: kExpandName, recursively: true)?.runAction(fadeIn)
        node.childNode(withName: kShareName, recursively: true)?.runAction(fadeIn)
        node.childNode(withName: kLikeName, recursively: true)?.runAction(fadeIn)
        node.childNode(withName: kRetweetName, recursively: true)?.runAction(fadeIn)
        
        //                gActionInProgress = false
        //                print("-----DONE 1------")
        
        // load original tweets and comments
        
        let tweetOpened = getTweetOpened(nodeParent: node, VC: VC)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            getTweetHeightExpanded(tweet: tweetOpened, completion: {(height, error) -> Void in
                
                if height != nil {
                    gHeightActuallyNeededForExpandedTweet = height!
                    saveExpandedTweetPhoto()
                } else {
                    saveExpandedTweetPhoto()
                }
                
            })
            
        }
        
        var tweetsBefore:[TWTRTweet] = []
        var tweetsAfter:[TWTRTweet] = []
        var tweetsTotal:[TWTRTweet] = []
        
        gTweetRepliedRepliesPhotos.removeAll()
        
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        
        loadTweetInReplyOfArray(myTweet: tweetOpened, completion: {(tweets, error) -> Void in
            
            print("before number = \(String(describing: tweets?.count))")
            
            tweetsBefore = tweets!
            
            myGroup.leave()
        })
        
        myGroup.enter()
        getTweetsReplies(tweet: tweetOpened, completion: {(tweets, error) -> Void in
            
            print("replies number = \(String(describing: tweets?.count))")
            
            tweetsAfter = tweets!
            
            myGroup.leave()
        })
        
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            
            if gShowedNodeName != node.name{
                return
            }
            
            tweetsTotal.append(contentsOf: tweetsBefore)
            tweetsTotal.append(contentsOf: tweetsAfter)
            
            savePictures(tweets: tweetsTotal, kindPhotosSaved: .repliesRepliedTweetPhotos, completion: {(error) -> Void in
                
                if gShowedNodeName != node.name{
                    return
                }
                
                print("--VIKING test--")
                
                if error == nil && tweetsTotal.count != 0 {
                    
                    var TopTweetY = boxSize.height + margin
                    let TopTweetX:CGFloat = 0.0
                    var TopTweetPosition = SCNVector3(TopTweetX, TopTweetY, 0)
                    var tweetContentToSend: tweetContent
                    
                    for i in tweetsBefore {
                        
                        var tweetText: String
                        tweetText = textLinksCleaning(i.text)
                        
                        tweetContentToSend = tweetContent(title: i.author.name,
                                                          twitterId: i.author.screenName,
                                                          content: tweetText,
                                                          logo: "OFlogo.png",
                                                          image: "testContent2_rounded2.jpg",
                                                          date: i.createdAt,
                                                          tweetID: i.tweetID,
                                                          like: i.isLiked,
                                                          retweet: i.isRetweeted)
                        
                        addBox(tweetContent: tweetContentToSend,
                               boxSize: boxSize,
                               position: TopTweetPosition,
                               eulerAngle: eulerAngle,
                               opacity: 0.1,
                               name: kTopTweetName,
                               rootNode: node)
                        
                        TopTweetY += boxSize.height + margin
                        TopTweetPosition = SCNVector3(TopTweetX, TopTweetY, 0)
                        
                    }
                    
                    var DownTweetY = LikeY - (LikeRetweetBoxSizeHeight/2 + boxSize.height/2 + margin)
                    let DownTweetX:CGFloat = 0.0
                    var DownTweetPosition = SCNVector3(DownTweetX, DownTweetY, 0)
                    
                    for u in tweetsAfter {
                        
                        print("tweetAfter")
                        
                        var tweetText: String
                        tweetText = textLinksCleaning(u.text)
                        
                        tweetContentToSend = tweetContent(title: u.author.name , twitterId: u.author.screenName , content: tweetText , logo: "OFlogo.png", image: "testContent2_rounded2.jpg", date: u.createdAt, tweetID: u.tweetID, like: u.isLiked, retweet: u.isRetweeted )
                        
                        addBox(tweetContent: tweetContentToSend,
                               boxSize: boxSize,
                               position: DownTweetPosition,
                               eulerAngle: eulerAngle,
                               opacity: 0.1,
                               name: kDownTweetName,
                               rootNode: node)
                        
                        DownTweetY -= (boxSize.height + margin)
                        DownTweetPosition = SCNVector3(DownTweetX, DownTweetY, 0)
                        
                    }
                    
                    let ReplyTweetX:CGFloat = 0.0
                    let ReplyTweetY = DownTweetY + (boxSize.height + margin) - (boxSize.height/2 + margin + CommentBoxSize.height/2)
                    
                    let heightDistanceBetweenBoxes = CommentBoxSize.height + margin

                    addReplyMoreBlockReport(firstY: ReplyTweetY, heightDistanceBetweenBoxes: heightDistanceBetweenBoxes, node: node, CommentBoxSize: CommentBoxSize, opacity: 0.1, eulerAngle: eulerAngle, newTweet: newTweet)
                    
                    node.enumerateChildNodes{ (node, stop) -> Void in
                        if node.name == kAddReplyName || node.name == kTopTweetName || node.name == kDownTweetName
                        || node.name == kMoreName{
                            node.runAction(fadeIn)
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        gActionInProgress = false
                        print("-----DONE 1------")
                    }
                    
                } else if error == nil && tweetsTotal.count == 0{
                    
                    let ReplyTweetX:CGFloat = 0.0
                    let ReplyTweetY = LikeY - LikeRetweetBoxSizeHeight/2 - margin - CommentBoxSize.height/2
                    
                    let heightDistanceBetweenBoxes = CommentBoxSize.height + margin
                    
                    addReplyMoreBlockReport(firstY: ReplyTweetY, heightDistanceBetweenBoxes: heightDistanceBetweenBoxes, node: node, CommentBoxSize: CommentBoxSize, opacity: 1.0, eulerAngle: eulerAngle, newTweet: newTweet)
                    
                    node.enumerateChildNodes{ (node, stop) -> Void in
                        if node.name == kAddReplyName || node.name == kMoreName{
                            node.runAction(fadeIn)
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        gActionInProgress = false
                        print("-----DONE 1------")
                    }
                    
                    print("0 tweet")
                    
                } else { //error
                    
                    gActionInProgress = false
                    print("-----DONE 1------")
                    
                    hud = JGProgressHUD(style: .extraLight)
                    hud.indicatorView = nil
                    print("error-saving pictures-tweet_comingforward")
                    hud.position = .bottomCenter
                    hud.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
                    hud.textLabel.text = "Connection Error\nTry again"
                    hud.show(in: sceneView, animated: false)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                        hud.dismiss(animated: true)
                    }
                }
                
            })
            
        }
        
    }
    
}

func addReplyMoreBlockReport(firstY: CGFloat, heightDistanceBetweenBoxes: CGFloat, node: SCNNode, CommentBoxSize: CGSize, opacity: CGFloat,
                             eulerAngle: SCNVector3, newTweet: tweetContent){
    
    let ReplyTweetX:CGFloat = 0.0
    let ReplyTweetY = firstY
    let ReplyPosition = SCNVector3(ReplyTweetX, ReplyTweetY, 0)
    
    let MorePosition = SCNVector3(ReplyTweetX, ReplyTweetY - heightDistanceBetweenBoxes, 0)
    
    let BlockPosition = SCNVector3(ReplyTweetX, ReplyTweetY - 2*heightDistanceBetweenBoxes, 0)
    
    let ReportPosition = SCNVector3(ReplyTweetX, ReplyTweetY - 3*heightDistanceBetweenBoxes, 0)
    
    addBox(tweetContent: newTweet,
           boxSize: CommentBoxSize,
           position: ReplyPosition,
           eulerAngle: eulerAngle,
           opacity: opacity,
           name: kAddReplyName,
           rootNode: node,
           testNoContent: false,
           text: true,
           textString: "Reply")
    
    addBox(tweetContent: newTweet,
           boxSize: CommentBoxSize,
           position: MorePosition,
           eulerAngle: eulerAngle,
           opacity: opacity,
           name: kMoreName,
           rootNode: node,
           testNoContent: false,
           text: true,
           textString: "More")
    
    addBox(tweetContent: newTweet,
           boxSize: CommentBoxSize,
           position: MorePosition,
           eulerAngle: eulerAngle,
           opacity: 0,
           name: kMuteName,
           rootNode: node,
           testNoContent: false,
           text: true,
           textString: "Mute")
    
    addBox(tweetContent: newTweet,
           boxSize: CommentBoxSize,
           position: BlockPosition,
           eulerAngle: eulerAngle,
           opacity: 0,
           name: kBlockName,
           rootNode: node,
           testNoContent: false,
           text: true,
           textString: "Block")
    
    addBox(tweetContent: newTweet,
           boxSize: CommentBoxSize,
           position: ReportPosition,
           eulerAngle: eulerAngle,
           opacity: 0,
           name: kReportName,
           rootNode: node,
           testNoContent: false,
           text: true,
           textString: "Report")
    
    
}
