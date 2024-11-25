//
//  Twitter.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 26/09/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import TwitterKit

func loadTweet(id: String? = "20"){
    
    let client = TWTRAPIClient()
    client.loadTweet(withID: id!) { (tweet, error) -> Void in
        // handle the response or error
        
        print("")
        print("")
        print("")
        
        print(tweet as TWTRTweet!)
        print("author : \(tweet?.author.name as String?)")
        print("createdAt : \(tweet?.createdAt as Date?)")
        print("likes : \(tweet?.likeCount as Int64?)")
        print("retweets : \(tweet?.retweetCount as Int64?)")
        print("profileImageMiniURL : \(tweet?.author.profileImageLargeURL as String?)")
        
        print("")
        print("")
        print("")
    }
    
}

func getTweets(kind: KindOfTweet, numberOfTweets: String? = kNumberTweetsPulled, query: String? = "", max_id: String? = "", since_id: String? = "", completion: @escaping ([TWTRTweet]?, Error?) -> Void){ //48
    
    if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
        let client = TWTRAPIClient(userID: userID)
        
        var statusesShowEndpoint = ""
        var params = [String:Any]()
        
        if kind == KindOfTweet.timeline{
            statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
            params = ["count": numberOfTweets!, "include_entities": "true", "tweet_mode" : "extended"]
        } else if kind == KindOfTweet.profile{
            statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
            params = ["count": numberOfTweets!, "id": userID, "include_entities": "true", "tweet_mode" : "extended"]
        } else if kind == KindOfTweet.mentions{
            statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/mentions_timeline.json"
            params = ["count": numberOfTweets!, "include_entities": "true", "tweet_mode" : "extended"]
        } else if kind == KindOfTweet.search{
            statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
            let test = query!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            params = ["count": numberOfTweets!, "q": test!, "include_entities": "true", "tweet_mode" : "extended"]
        }
        
        if max_id != ""{
            params["max_id"] = max_id
        }
        
        if since_id != ""{
            params["since_id"] = since_id
        }
        
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
                
                completion(nil, connectionError)
                return
            } else if data == nil {
                
                let errorData:Error = ParsingError.funnyError
                completion(nil, errorData)
                return
            }
            
            do {
                //erreur avec data à gérer
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                var nb = Int()
                var tweets = [TWTRTweet]()
                
                gTweetPhotos.removeAll()
                gTweetLinks.removeAll()
                
                if kind == KindOfTweet.search{
                    
                    let statuses = (json as! NSDictionary)["statuses"] as! NSArray
                    
                    nb = statuses.count
                    tweets = TWTRTweet.tweets(withJSONArray: statuses as? [Any]) as! [TWTRTweet]
                    
                    savePhotosLinksURLs(json: statuses as Any, kind: .normalTweetPhotos)
                } else {
                    nb = (json as! [[String:Any]]).count
                    tweets = TWTRTweet.tweets(withJSONArray: json as? [Any]) as! [TWTRTweet]
                    
                    savePhotosLinksURLs(json: json, kind: .normalTweetPhotos)
                }
                
                print(gTweetPhotos)
                
                print("number of tweets: \(nb)")
                
                completion(tweets, nil)
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
                
                completion(nil, jsonError)
            }
        }
        
    }
    
}

func getTweets_user(userId: String? = "20", numberOfTweets: String? = kNumberTweetsPulled){
    
    if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
        let client = TWTRAPIClient(userID: userID)
        
        var params = [String:Any]()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        params = ["id": userId!, "count": numberOfTweets!]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                //print("json: \(json)")
                
                let nb = (json as! [[String:Any]]).count
                print("nombre de tweets: \(nb)")
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
    }
    
}




