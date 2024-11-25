//
//  PhotosManager.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 01/10/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import Kingfisher
import TwitterKit

func savePictures(tweets: [TWTRTweet], firstSetup: Bool? = false, kindPhotosSaved: KindOfSavePhotosURL, completion: @escaping (Error?) -> Void){
    
    var photos:[String:String] = [:]
    
    if kindPhotosSaved == .normalTweetPhotos{
        photos = gTweetPhotos
    } else if kindPhotosSaved == .repliesRepliedTweetPhotos{
        photos = gTweetRepliedRepliesPhotos
    }
    
    var photosSaved = 0
    var maxNumberTweetsToLoad = 0
    
    if tweets.count == 0{
        completion(nil)
        return
    } else {
        // to not save useless tweets as there are usually more tweets than the onew actually showed
        if tweets.count < kTotalColumnsLines{
            maxNumberTweetsToLoad = tweets.count
        } else {
            maxNumberTweetsToLoad = kTotalColumnsLines
        }
    }
    
    // HUD
    let HUDpercentTotalLeft:CGFloat = (100 - 33)/100.0
    let HUDunit:CGFloat = HUDpercentTotalLeft / CGFloat(maxNumberTweetsToLoad + photos.count)
    var HUDtotalUnitsAdded:CGFloat = 33/100.0
    
    var index = 0
    
    for i in 0..<maxNumberTweetsToLoad{
        
        let url = URL(string: tweets[i].author.profileImageLargeURL)
        
        ImageDownloader.default.downloadImage(with: url!, options: [], progressBlock: nil) {
            (image, error, url, data) in
            
            if error != nil{
                completion(error)
                
                print("error-saving pictures-inside-1")
                
            } else {
                ImageCache.default.store(image!, original: data, forKey: "image-\(tweets[i].author.screenName)")
                //print("store")
                
                photosSaved += 1
                
                if firstSetup!{
                    HUDtotalUnitsAdded += HUDunit
                    hud.setProgress(Float(HUDtotalUnitsAdded), animated: true)
                    //print("chargement : \(HUDtotalUnitsAdded)")
                }
                
                if (photosSaved == maxNumberTweetsToLoad + photos.count){
                    completion(nil)
                }
            }
            
        }
        
        if let urlSaved = photos[tweets[i].tweetID] {
            if urlSaved != ""{
                
                let url = URL(string: urlSaved)
                
                ImageDownloader.default.downloadImage(with: url!, options: [], progressBlock: nil) {
                    (image, error, url, data) in
                    
                    if error != nil{
                        completion(error)
                        
                        print("error-saving pictures-inside-2")
                    } else {
                        ImageCache.default.store(image!, original: data, forKey: "photo-\(tweets[i].tweetID)")
                        
                        photosSaved += 1
                        
                        if firstSetup!{
                            HUDtotalUnitsAdded += HUDunit
                            hud.setProgress(Float(HUDtotalUnitsAdded), animated: true)
                        }
                        
                        print("Tweet Photo Saved")
                        
                        if (photosSaved == maxNumberTweetsToLoad + photos.count){
                            completion(nil)
                        }
                    }
                    
                }
            }
        }
        
        index += 1
        
    }
    
}

func loadProfilePicture(author: String, completion: @escaping (UIImage?, Error?) -> Void) {
    
    ImageCache.default.retrieveImage(forKey: "image-\(author)", options: nil) {
        image, cacheType in
        if let image = image {
            completion(image, nil)
            
        } else {
            print("Not exist in cache.")
            
            completion(nil, nil)
        }
    }
    
}

func loadExpandedPicture(completion: @escaping (UIImage?, Error?) -> Void) {
    
    ImageCache.default.retrieveImage(forKey: "expanded-photo", options: nil) {
        image, cacheType in
        if let image = image {

            completion(image, nil)
            
        } else {
            print("Not exist in cache.")
            
            completion(nil, nil)
        }
    }
    
}

func loadPicture(tweetID: String, completion: @escaping (UIImage?, Error?) -> Void) {
    
    ImageCache.default.retrieveImage(forKey: "photo-\(tweetID)", options: nil) {
        image, cacheType in
        if let image = image {
            completion(image, nil)
            
        } else {
            print("Not exist in cache.")
            
            completion(nil, nil)
        }
    }
}




