//
//  Twitter_Replies.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 02/12/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import TwitterKit

// only work for the last 7 days

func getTweetsReplies(tweet: TWTRTweet, numberOfTweets: String? = "15", completion: @escaping ([TWTRTweet]?, Error?) -> Void){ //48
    
    if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
        let client = TWTRAPIClient(userID: userID)
        
        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        var params = [String:Any]()
        
        let q = "to:\(tweet.author.screenName)"
        let tweetId = tweet.tweetID
        
        params = ["q": q, "since_id": tweetId, "count": numberOfTweets!, "tweet_mode" : "extended"]
        
        print(params)
        
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
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                var tweets = [TWTRTweet]()
                var replies = [TWTRTweet]()
                
                print(tweets)
                
                let statuses = (json as! NSDictionary)["statuses"] as! NSArray
                tweets = TWTRTweet.tweets(withJSONArray: statuses as? [Any]) as! [TWTRTweet]
                
                savePhotosLinksURLs(json: statuses as Any, kind: .repliesRepliedTweetPhotos, tweetReplies: true, tweetIdInReplyOf: tweetId)
                
                print(tweets)
                
                for i in tweets{
                    if i.inReplyToTweetID == tweetId{
                        replies.append(i)
                    }
                }
                
                completion(replies, nil)
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
                
                completion(nil, jsonError)
            }
        }
        
    }
    
}
