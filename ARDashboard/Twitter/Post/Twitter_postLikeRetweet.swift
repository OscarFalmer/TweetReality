//
//  Twitter_postLikeRetweet.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 02/12/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import TwitterKit

func postRetweetLike(tweetID: String, mode: KindRetweetLike){
    
    if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
        let client = TWTRAPIClient(userID: userID)
        
        var statusesShowEndpoint = ""
        
        if mode == .like {
            statusesShowEndpoint = "https://api.twitter.com/1.1/favorites/create.json"
        } else if mode == .unlike {
            statusesShowEndpoint = "https://api.twitter.com/1.1/favorites/destroy.json"
        } else if mode == .retweet {
            statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/retweet/\(tweetID).json"
        } else if mode == .unretweet {
            statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/unretweet/\(tweetID).json"
        }
        
        let params = ["id": tweetID]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "POST", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("json: \(json)")
                
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
    }
    
}
