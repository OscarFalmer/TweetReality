//
//  Constants.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 24/09/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import UIKit

// MARK: - General View

var kNumberColumns = 5
var kNumberLines = 5

var kTotalColumnsLines = 25 // (kNumberColumns * kNumberLines)

var kNumberTweetsPulled = "35"

var kDistanceX:CGFloat = 20
var kDistanceY:CGFloat = 15

//MARK: - Logo Color

var logoColor = UIColor(rgb: 0x2D93D5)

//MARK: - Animations

var kFadeAnimationDuration:TimeInterval = 0.4
var kFadeAnimationDelay:TimeInterval = 0.3

// MARK: - RootNodeMoveable

var kRootNodeName = "rootNodeMoveable"

// MARK: - FeaturePoints

var kFeaturePointName = "featurePoint"

// MARK: - Connection

var kNoInternetConnection = "No internet connection\nPlease connect to internet"

// MARK: - Login View

var kAppName = "TweetReality"
var kLoginTitle = "Enjoy Twitter with\nan AR Experience"
var kLoginButtonMessage = "Login with Twitter"
var kLoadingLogingMessage = "Loading..."

// MARK: - Message

var kLoadingMessage = "Loading the Twitter experience..."
var kInitializingMessage = "Let's find a surface\nMove your device slowly\ntowards the floor\n(I will add an animation here\nto make it easier)"

var kInterruptionMessage = "Session Interrupted\nThe session will be reset after\nthe interruption has ended."
var kResettingSessionMessage = "Resetting Session"
var kARSessionFailedMessage = "The AR session failed."

var kMRHowToTitle = "Welcome in the Mixed Reality Mode"
var kMRHowToText = "Please put the phone in landscape mode in a Mixed Reality headset.\nPlug your headphones and use + or - to simulate a touch at the center of your view where the white dot is."

// MARK: - Buttons

var kWelcomeNotReallyMenuName = "welcomeNotReallyMenuName"
var kProfilePictureName = "profilePicture"
var kHomeName = "home"
var kSearchName = "search"
var kNotificationsName = "notifications"
var kMRName = "mixedReality"
var kRefreshName = "refresh"

var kUpName = "up"
var kDownName = "down"

var kLogoutName = "logout"

// MARK: - MR

var kWhiteDotName = "whiteDot"

// MARK: - Search

var kSearchBarName = "searchBar"
var kTextNodeSearchName = "searchTextNode"

var kTextNodeSearchString = "Search"

// MARK: - New Tweet

var kNewTweetTitleName = "newTweetTitle"
var kAddContentNewTweetName = "addContentNewTweet"

var kWriteTweetName = "writeTweet"
var kNewTweetBox = "newTweetBox"
var kTextNodeNewTweetName = "newTweetTextNode"
var kTextNodeNewTweetLenghtName = "newTweetTextNodeLenght"
var kPostTweetName = "postTweet"
var kClosePostTweetName = "closePostTweet"

var kTextNodeNewTweetString = "What's happening?"
var kTextNodeNewTweetLenghtString = "\n\n\n\n\n\n\n\n140"

// MARK - Open Tweet Boxes

var kTopTweetName = "topTweet"
var kDownTweetName = "downTweet"

var kRectangleName = "rectangle"
var kLikeName = "like"
var kRetweetName = "retweet"
var kCommentName = "comment"
var kAddReplyName = "addReply"
var kMoreName = "more"
var kMuteName = "mute"
var kBlockName = "block"
var kReportName = "report"
//var kLoadingName = "loadingComments"

var kExpandName = "expandButton"
var kShareName = "shareButton"

var kLikeColor = UIColor.init(rgb: 0xE6567A)
var kRetweetColor = UIColor.init(rgb: 0x47C9AF)

// MARK: - Fonts

var kFontRobotoRegular = "Roboto-Regular"
var kFontRobotoLight = "Roboto-Light"

// MARK: - Expanded Tweet

var kExpandedTweetName = "expandedTweet"

// MARK: - Other

var kOutputVolumeKeyPath = "outputVolume"

var boxSizeMini: CGSize = CGSize(width: 0.2, height: 0.15)

var kDistanceFromUser: CGFloat = 0.9
var kDistanceCloseToUser: CGFloat = 0.5

var kDistanceCloseToUserSearch: CGFloat = 0.4

var kLeftButtonsAlphaUp: CGFloat = 1.0
var kLeftButtonsAlphaDown: CGFloat = 0.5

var kBoxesAlphaNormal: CGFloat = 0.7
var kBoxesAlphaDisabled: CGFloat = 0.2

var kMinuteInSeconds: TimeInterval = 60
var kHourInSeconds: TimeInterval = 3600
var kDayInSeconds: TimeInterval = 86400
var kMonthInSeconds: TimeInterval = 2592000
var kYearInSeconds: TimeInterval = 31104000







