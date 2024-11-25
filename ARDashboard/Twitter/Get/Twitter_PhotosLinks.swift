//
//  Twitter_PhotosLinks.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 02/12/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import TwitterKit

// save PhotosURL & Links URLs in an array
func savePhotosLinksURLs(json: Any, kind: KindOfSavePhotosURL, tweetReplies: Bool? = false, tweetIdInReplyOf: String? = ""){
    
    if let j = json as? [[String:Any]]{
        
        var index = 0
        
        for i in j{
            if let entities = i["entities"]{
                
                if let entities2 = entities as? [String:Any], let urls = entities2["urls"]{
                    if let urls2 = urls as? [[String:Any]]{
                        for item in urls2 {
                            
                            // Save links
                            if let linkUrl = item["url"]{
                                if let displayUrl = item["display_url"]{
                                    gTweetLinks[linkUrl as! String] = displayUrl as! String
                                }
                            }
                            
                        }
                    }
                }
                
                if let entities2 = entities as? [String:Any], let media = entities2["media"]{
                    if let media2 = media as? [[String:Any]]{
                        for item in media2 {
                            if let type = item["type"] as? String{
                                if type == "photo"{
                                    if let photoUrl = item["media_url_https"], let tweetID = i["id_str"]{
                                        
                                        // Save links
                                        if let linkUrl = item["url"]{
                                            if let displayUrl = item["display_url"]{
                                                gTweetLinks[linkUrl as! String] = displayUrl as! String
                                            }
                                        }
                                        
                                        //print(photoUrl as! String)
                                        
                                        if kind == KindOfSavePhotosURL.normalTweetPhotos{
                                            
                                            if index < kTotalColumnsLines{
                                                gTweetPhotos[tweetID as! String] = photoUrl as? String
                                            }
                                            
                                        } else if kind == KindOfSavePhotosURL.repliesRepliedTweetPhotos{
                                            
                                            if tweetReplies == true{
                                                if let inReplyToTweetID = i["in_reply_to_status_id_str"] as? String{
                                                    if inReplyToTweetID == tweetIdInReplyOf{
                                                        gTweetRepliedRepliesPhotos[tweetID as! String] = photoUrl as? String
                                                    }
                                                }
                                            } else {
                                                gTweetRepliedRepliesPhotos[tweetID as! String] = photoUrl as? String
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
            index += 1
        }
    }
    
}
