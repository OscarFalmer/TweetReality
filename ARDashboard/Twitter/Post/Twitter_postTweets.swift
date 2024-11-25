//
//  Twitter_postTweets.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 02/12/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import TwitterKit

func postTweet(text: String, inReplyToStatusID: String? = nil){
    
    if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
        let client = TWTRAPIClient(userID: userID)
        
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/update.json"
        var params = ["status": text]
        
        if inReplyToStatusID != nil{
            params["in_reply_to_status_id"] = inReplyToStatusID
        }
        
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
