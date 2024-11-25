//
//  TweetAnalysis.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 14/10/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import ARKit
import TwitterKit

func tweetNotBlank(nodeParent: SCNNode, VC: ViewController) -> Bool{
    
    let rootNodeName = nodeParent.name
    let index = tweetBoxStringToActualIndex(name: rootNodeName!)
    
    if index < VC.savedTweets.count{
        return true
    } else {
        return false
    }
    
}

func getTweetOpened(nodeParent: SCNNode, VC: ViewController) -> TWTRTweet{
    
    let rootNodeName = nodeParent.name
    let index = tweetBoxStringToActualIndex(name: rootNodeName!)
    let tweetOpened = VC.savedTweets[index]
    
    return tweetOpened
}

func tweetBoxStringToXIndex(name: String) -> Int{
    let nameAnalysis : [String] = name.components(separatedBy: "-")
    let x = Int(nameAnalysis[1])
    return x!
}

func tweetBoxStringToActualIndex(name: String) -> Int{
    
    // "\(kRectangleName)-\(i)-\(u)"
    
    let nameAnalysis : [String] = name.components(separatedBy: "-")
    
    let x = Int(nameAnalysis[1])
    let y = Int(nameAnalysis[2])
    
    let index = x! * kNumberLines + y!
    
    return index
}
