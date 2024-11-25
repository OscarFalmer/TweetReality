//
//  TouchHandle.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 20/09/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import TwitterKit

var previousPosition = SCNVector3()
var previousRotation = SCNVector3()
var previousOpacity = CGFloat()

var gHeightActuallyNeededForExpandedTweet:CGFloat = 0

func handleTouchFor(node: SCNNode, boxSize: CGSize, sceneView: ARSCNView, VC: ViewController){
    
    if node.name == nil {
        return
    }
    
    if gActionInProgress == true{
        return
    }
    
    //print("touched \(node.name)")
    
    // If we open anything else than the tweet opens, we close the open tweet box
    if gNewTweetOpened
        && node.name != kClosePostTweetName
        && node.name != kPostTweetName
        && node.name != kNewTweetBox
        && node.name != kWriteTweetName{
        if let closeNewTweetNode = sceneView.scene.rootNode.childNode(withName: kClosePostTweetName, recursively: true){
            postCloseNewTweetAction(node: closeNewTweetNode, sceneView: sceneView, VC: VC)
        }
        VC.newTweetInvisbleTextField.resignFirstResponder()
    }
    
    // If we touch anything else than the search bar and it's open, we can put it back
    if gSearchBarInFront
        && node.name != kSearchBarName
        && node.name != kSearchName{
        searchBarAnimation(to: .back, sceneView: sceneView)
        VC.searchBarInvisbleTextField.resignFirstResponder()
    }
    
    // If we open anything else than the tweet reply, we close the it
    if gNewReplyOpened
        && node.name != kPostTweetName
        && node.name != kNewTweetBox
        && node.name != kNewTweetTitleName
        && node.name != kClosePostTweetName{
        
        if let closeNewTweetNode = sceneView.scene.rootNode.childNode(withName: kClosePostTweetName, recursively: true){
            postCloseNewTweetAction(node: closeNewTweetNode, sceneView: sceneView, VC: VC, tweetAnimation: false) //tweet animation already done
        }
    }
    
    // fermeture automatique de tweets expanded
    if gExpandedTweetOpened
        && node.name != kExpandedTweetName
        && node.name != kExpandName{
        
        expandReverseAction(VC: VC)
    }
    
    // ranger tweet quand on change d'écran
    if gNodeShowedUp
        && (node.name == kUpName
            || node.name == kDownName
            || node.name == kNotificationsName
            || node.name == kHomeName
            || node.name == kProfilePictureName
            || node.name == kSearchName
            || node.name == kRefreshName
            || node.name == kWriteTweetName){
        
        // tweet going back 
        let openedTweetNode = sceneView.scene.rootNode.childNode(withName: gShowedNodeName, recursively: true)
        tweetAction(node: openedTweetNode!, boxSize: boxSize, sceneView: sceneView, VC: VC, changingScreen: true)
        
    }
    
    // MARK: - Show Tweet
    
    if (node.name?.contains(kRectangleName))!
        && (gNodeShowedUp == false || (gNodeShowedUp == true && node.name == gShowedNodeName))
        && tweetNotBlank(nodeParent: node, VC: VC) == true {
        
        tweetAction(node: node, boxSize: boxSize, sceneView: sceneView, VC: VC)
        
    } else if (node.name?.contains(kRectangleName))!
        && (gNodeShowedUp == true)
        && tweetNotBlank(nodeParent: node, VC: VC) == true {
        
        // tweet going back
        let openedTweetNode = sceneView.scene.rootNode.childNode(withName: gShowedNodeName, recursively: true)
        tweetAction(node: openedTweetNode!, boxSize: boxSize, sceneView: sceneView, VC: VC)
            
        tweetAction(node: node, boxSize: boxSize, sceneView: sceneView, VC: VC)
        
        // MARK: - Like & Retweet
    } else if node.name == kLikeName || node.name == kRetweetName{
        likeRetweetActions(node: node, VC: VC)
        
        // MARK: - Refresh
    } else if node.name == kRefreshName {
       refreshAction(node: node, sceneView: sceneView, VC: VC)
        
        // MARK: - Up
    } else if node.name == kUpName {
        upAction(node: node, sceneView: sceneView, VC: VC)
        
        // MARK: - Down
    } else if node.name == kDownName {
        downAction(node: node, sceneView: sceneView, VC: VC)
        
        // MARK: - Home & Profile & Notifications & Search
    } else if node.name == kHomeName || node.name == kProfilePictureName || node.name == kNotificationsName || node.name == kSearchName {
        
        // no double click
        if (gCurrentView == .profile && node.name == kProfilePictureName) ||
            (gCurrentView == .mentions && node.name == kNotificationsName) ||
            (gCurrentView == .search && node.name == kSearchName) ||
            (gCurrentView == .timeline && node.name == kHomeName){
            return
        }
        
        //DispatchQueue.main.async {
        showNewTimelineAction(node: node, sceneView: sceneView, VC: VC)
        //}
        
        // MARK: - Mixed Reality
    } else if node.name == kMRName{
        mixedRealityAction(node: node, VC: VC)
        
        // MARK: - Seacrh & NewTweetBox
    } else if (node.name == kSearchBarName){

        if !gMRClickActivated{
            
            //VC.searchBarInvisbleTextField.selectedTextRange = NSMakeRange(0, (VC.searchBarInvisbleTextField.text?.characters.count)!)
            
            if !gSearchBarInFront{
                searchBarAnimation(to: .front, sceneView: sceneView)
            }
            
            VC.searchBarInvisbleTextField.becomeFirstResponder()
        }
        
    } else if (node.name == kNewTweetBox){
        
        if !gMRClickActivated{
            
            VC.newTweetInvisbleTextField.becomeFirstResponder()
        }
            
        // MARK: - Write Tweet
    } else if (node.name == kWriteTweetName && gNodeShowedUp == false) {
        writeTweetAction(node: node, sceneView: sceneView)
        
        // MARK: - Post Tweet & Close New Tweet
    } else if node.name == kPostTweetName || node.name == kClosePostTweetName {
        postCloseNewTweetAction(node: node, sceneView: sceneView, VC: VC)
        
        // MARK: - Share
    } else if node.name == kShareName {
        shareAction(node: node, VC: VC)
        
        // MARK: - Expand Tweet
    } else if node.name == kExpandName {
        if !gExpandedTweetOpened{
            expandAction(node: node, VC: VC)
        } else {
            expandReverseAction(VC: VC)
        }
        
    } else if node.name == kExpandedTweetName {
        expandReverseAction(VC: VC)
        
        // MARK: - Logout
    } else if node.name == kLogoutName {
        
        logoutAction(node: node, sceneView: sceneView, VC: VC)
    
        // MARK: - Reply to a tweet
    } else if node.name == kAddReplyName {
        
        //mouvement arrière du tweet ouvert avec alpha qui descend
        //apparition nouveau tweet custom
        
        replyAction(node: node, sceneView: sceneView)
    } else if node.name == kMoreName {
        
        moreAction(sceneView: sceneView)
    } else if node.name == kMuteName {
        
        muteBlockReportAction(node: node, more: .mute, sceneView: sceneView, VC: VC)
    } else if node.name == kBlockName {
        
        muteBlockReportAction(node: node, more: .block, sceneView: sceneView, VC: VC)
    } else if node.name == kReportName{
        
        muteBlockReportAction(node: node, more: .report, sceneView: sceneView, VC: VC)
    }
    
}









