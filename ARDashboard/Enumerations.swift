//
//  Enumerations.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 25/09/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation

public enum ParsingError: Error {
    case funnyError
}

public enum Menu:Int {
    case Profile = 0
    case Home
    case Search
    case Notifications
    case MR
    
    case Refresh
    case Up
    case Down
    case WriteTweet
    case Logout
    
    case WelcomeNotReallyMenu
}

public enum UnderOpenTweet:Int {
    case Like = 0
    case Retweet
    
    case Expand
    case Share
}

public enum KindOfTweet:Int {
    case timeline = 0
    case profile
    case mentions
    case search
}

public enum textBox:Int {
    case searchBar = 0
    case newTweet
    case newTweetLenght
    case expandedTweet
}

public enum fade: Int {
    case In = 0
    case Out
}

public enum KindOfSavePhotosURL:Int{
    case normalTweetPhotos = 0
    case repliesRepliedTweetPhotos
}

public enum KindRetweetLike:Int{
    case retweet = 0
    case like
    case unretweet
    case unlike
}

public enum SearchBarPosition:Int{
    case front = 0
    case back
}

public enum More:Int{
    case mute = 0
    case block
    case report
}



