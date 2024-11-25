//
//  Twitter_Mute.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 02/12/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import TwitterKit

//similar to postLikeRetweet
func postMuteBlockReport(screenName: String, more: More){
    
    if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
        let client = TWTRAPIClient(userID: userID)
        
        var statusesShowEndpoint = ""
        
        if more == .mute {
            statusesShowEndpoint = "https://api.twitter.com/1.1/mutes/users/create.json"
        } else if more == .block {
            statusesShowEndpoint = "https://api.twitter.com/1.1/blocks/create.json"
        } else if more == .report {
            statusesShowEndpoint = "https://api.twitter.com/1.1/users/report_spam.json"
        }
        
        let params = ["screen_name":screenName]
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


