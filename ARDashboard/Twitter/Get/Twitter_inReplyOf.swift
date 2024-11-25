//
//  Twitter_inReplyOf.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 02/12/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import TwitterKit

// loop function on loadTweetInReplyOf to get a list

func loadTweetInReplyOfArray(myTweet: TWTRTweet, completion: @escaping ([TWTRTweet]?, Error?) -> Void){
    
    var result:TWTRTweet? = nil
    var resultArray:[TWTRTweet]? = []
    var previousTweet = myTweet
    
    if previousTweet.inReplyToTweetID == nil {
        completion(resultArray, nil)
        return
    }
    
    // load the parent tweet
    
    loadTweetInReplyOf(myTweet: previousTweet, completion: {(tweetBack, error) -> Void in
        result = tweetBack
        
        // if it exists, we had it to the list
        
        if result != nil{
            resultArray?.append(result!)
            previousTweet = result!
            
            // if it has a parent, we want the parent's list and we add it indfinitely recursively
            
            if previousTweet.inReplyToTweetID != nil{
                loadTweetInReplyOfArray(myTweet: previousTweet, completion: {(tweets, error) -> Void in
                    
                    for i in tweets!{
                        resultArray?.append(i)
                    }
                    
                    completion(resultArray, nil)
                })
            } else {
                completion(resultArray, nil)
            }
            
        } else {
            completion(resultArray, nil)
        }
        
    })
    
}

// load a parent tweet

func loadTweetInReplyOf(myTweet: TWTRTweet, completion: @escaping (TWTRTweet?, Error?) -> Void){
    
    let inReplyToTweetID = myTweet.inReplyToTweetID
    if inReplyToTweetID == nil {
        let errorData:Error = ParsingError.funnyError
        completion(nil, errorData)
        return
    }
    
    if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
        let client = TWTRAPIClient(userID: userID)
        
        var params = [String:Any]()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
        params = ["id": inReplyToTweetID!, "tweet_mode" : "extended"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
                
                completion(nil, connectionError)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                let parentTweet = TWTRTweet.init(jsonDictionary: json as! [AnyHashable : Any])
                
                savePhotosLinksURLs(json: json, kind: .repliesRepliedTweetPhotos)
                
                completion(parentTweet, nil)
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
                
                completion(nil, jsonError)
            }
        }
        
    }
    
}
