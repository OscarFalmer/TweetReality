//
//  TweetLinks.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 25/11/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import TwitterKit

// Removing images links but keep real links

// we delete the ones that have "display_url":"pic.twitter.com/rJC5Pxsu" and "url":"http://t.co/rJC5Pxsu"

func textLinksCleaning(_ text: String) -> String {
    
    var textArray : [String] = text.components(separatedBy: " ")
    
    for word in textArray{
        if let displayUrl = gTweetLinks[word]{
            if displayUrl.contains("pic.twitter"){
                if let wordIndex = textArray.index(of: word){
                    textArray.remove(at: wordIndex)
                }
            } else {
                if let wordIndex = textArray.index(of: word){
                    textArray[wordIndex] = displayUrl
                }
            }
        }
        
    }
    
    return textArray.joined(separator: " ")
    
}
