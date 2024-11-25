//
//  AddBod_Content.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 09/10/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import TwitterKit

func addTextOnBox(width: CGFloat, height: CGFloat, geometry: SCNGeometry, geometryNode: SCNNode, sceneView: ARSCNView, textBoxType: textBox){
    
    let materialFaces = SCNMaterial()
    materialFaces.diffuse.contents = UIColor.white
    geometry.materials = [materialFaces, materialFaces, materialFaces, materialFaces, materialFaces, materialFaces]
    
    var fontSize = CGFloat()
    var boxString = String()
    var margin = CGFloat()
    var margin2 = CGFloat() //test - to improve
    var alignement = String()
    var nodeName = String()
    
    if textBoxType == .searchBar{
        fontSize = height * 0.8
        margin = 1
        
        boxString = kTextNodeSearchString
        alignement = kCAAlignmentCenter
        nodeName = kTextNodeSearchName
    } else if textBoxType == .newTweet{
        fontSize = (height/2.3 * 2) * 0.1
        margin = 0.92
        margin2 = 0.94
        
        boxString = kTextNodeNewTweetString
        
        if gNewReplyOpened {
            boxString = "@\(gTweetOpened!.author.screenName) "
        }
        
        alignement = kCAAlignmentLeft
        nodeName = kTextNodeNewTweetName
    } else if textBoxType == .newTweetLenght{
        fontSize = (height/2.3 * 2) * 0.1
        margin = 0.92
        margin2 = 0.94
        
        boxString = kTextNodeNewTweetLenghtString
        alignement = kCAAlignmentRight
        nodeName = kTextNodeNewTweetLenghtName
    }
    
    let size = fontSize / 12
    
    let textOnNode = SCNText(string: boxString, extrusionDepth: 0)
    textOnNode.materials.first?.diffuse.contents = UIColor.black
    
    textOnNode.font = UIFont.systemFont(ofSize: 12)
    textOnNode.containerFrame = CGRect(x: 0, y: 0, width: margin*width/size, height: margin*height/size)
    textOnNode.isWrapped = true // go back to line when not fit the container frame
    textOnNode.alignmentMode = alignement
    textOnNode.flatness = 0.1
    
    let textNode = SCNNode(geometry: textOnNode)

    textNode.name = nodeName
    textNode.scale = SCNVector3Make(Float(size), Float(size), Float(size))
    
    let min = textNode.boundingBox.min
    let max = textNode.boundingBox.max
    
    if textBoxType == .searchBar{
        textNode.position = SCNVector3Make(-(min.x + max.x) / 2 * Float(size),
                                           -(min.y + max.y) / 2 * Float(size),
                                           +0.02)
    } else if textBoxType == .newTweet {
        textNode.position = SCNVector3Make(Float(-width/2 * margin2),
                                           Float(-height/2 * margin2),
                                           +0.02)
    } else if textBoxType == .newTweetLenght {
        textNode.position = SCNVector3Make(Float(-width/2 * margin2),
                                           Float(-height/2 * margin2),
                                           +0.02)
    }
    
    geometryNode.addChildNode(textNode)
    
}

func addTextOnBox_ImageVersion(tweetContent: tweetContent, geometry: SCNGeometry, width: CGFloat, height: CGFloat,
                               text: Bool? = false, textString:String? = "",
                               MenuButton:Menu? = nil, UnderTweet:UnderOpenTweet? = nil,
                               centerTweet:Bool = false, expandedTweet:Bool = false){
    
    let materialFace1 = SCNMaterial()
    let materialFace2 = SCNMaterial()
    let materialFace3 = SCNMaterial()
    let materialFaces = SCNMaterial()
    
    materialFaces.diffuse.contents = UIColor.white
    
    if MenuButton != nil && MenuButton != Menu.WelcomeNotReallyMenu {
        
        if let image = menuButtonImage(MenuButton: MenuButton, imageSize: CGSize(width: width*1000, height: height*1000), backgroundColor: .white){
            
            var rotatedImage = UIImage()
            
            if MenuButton == Menu.Up{
                rotatedImage = image.imageRotatedByDegrees(degrees: 90, flip: false)
            } else if MenuButton == Menu.Down {
                rotatedImage = image.imageRotatedByDegrees(degrees: -90, flip: false)
            } else {
                rotatedImage = image.imageRotatedByDegrees(degrees: -90, flip: true)
            }
            
            materialFace1.diffuse.contents = materialFaces
            materialFace2.diffuse.contents = rotatedImage
            materialFace3.diffuse.contents = materialFaces
        }
        
    } else if MenuButton != nil && MenuButton == Menu.WelcomeNotReallyMenu{
        
        if let image = menuButtonImage(MenuButton: MenuButton, imageSize: CGSize(width: width*1000, height: height*1000), backgroundColor: UIColor.init(rgb: 0x2980B9)){
            
            var rotatedImage = UIImage()
            
            rotatedImage = image.imageRotatedByDegrees(degrees: -90, flip: true)
            
            materialFace1.diffuse.contents = UIColor.init(rgb: 0x2980B9)
            materialFace2.diffuse.contents = rotatedImage
            materialFace3.diffuse.contents = rotatedImage
            materialFaces.diffuse.contents = UIColor.init(rgb: 0x2980B9)
            
        }
        
    } else if UnderTweet != nil{
        
        if let image = likeCommentImage(UnderTweet: UnderTweet, activated: false, imageSize: CGSize(width: width*2000, height: height*2000), backgroundColor: .white),
            let image2 = likeCommentImage(UnderTweet: UnderTweet, activated: true, imageSize: CGSize(width: width*2000, height: height*2000), backgroundColor: .white){
            
            materialFace1.diffuse.contents = image
            materialFace2.diffuse.contents = image2
            materialFace3.diffuse.contents = materialFaces
            
        }
        
    } else if text!{
        
        var fontSize: CGFloat
        var imageWidth = width * 1000
        var imageHeight = height * 1000
        if (textString == "Close" || textString == "Tweet" || textString == "New Tweet" || textString == "Add Reply"){
            fontSize = 40
            imageWidth = width * 1200
            imageHeight = height * 1200
        } else {
            fontSize = 60
        }
        
        if let image = textImage(text: textString!, fontSize: fontSize, imageSize: CGSize(width: imageWidth, height: imageHeight), backgroundColor: .white){
            
            materialFace1.diffuse.contents = image
            materialFace2.diffuse.contents = image
            materialFace3.diffuse.contents = materialFaces
            
        }
        
    } else if expandedTweet {
        
        if tweetContent.content != ""{
            
            loadExpandedPicture(completion: {(image, error) -> Void in
                
                if image != nil {
                    materialFace1.diffuse.contents = image
                    materialFace2.diffuse.contents = materialFaces
                    
                    geometry.materials = [materialFace1, materialFaces, materialFace2, materialFaces, materialFaces, materialFaces]
                } else {
                    geometry.materials = [materialFace1, materialFaces, materialFace2, materialFaces, materialFaces, materialFaces]
                }
                
            })
            
        } else {
            geometry.materials = [materialFaces, materialFaces, materialFaces, materialFaces, materialFaces, materialFaces]
        }
    
    } else {
        
        //print("test : \(width*1000) - 1000")
        //DispatchQueue.global().async {
        if tweetContent.content != ""{
            if let image = tweetImage(tweetContent: tweetContent, fontColor: .black, imageSize: CGSize(width: 1000, height: 750), backgroundColor: .white){
                
                if centerTweet {
                    
                    if let imageLogo = logoImage(imageSize: CGSize(width: width*1000, height: height*1000), backgroundColor: .white){
                        materialFace1.diffuse.contents = image
                        materialFace2.diffuse.contents = imageLogo
                        geometry.materials = [materialFace1, materialFaces, materialFace2, materialFaces, materialFaces, materialFaces]
                    } else {
                        materialFace1.diffuse.contents = image
                        materialFace2.diffuse.contents = materialFaces
                        geometry.materials = [materialFace1, materialFaces, materialFace2, materialFaces, materialFaces, materialFaces]
                    }
                    
                } else {
                    materialFace1.diffuse.contents = image
                    materialFace2.diffuse.contents = materialFaces
                    geometry.materials = [materialFace1, materialFaces, materialFace2, materialFaces, materialFaces, materialFaces]
                }

            }
        } else {
                geometry.materials = [materialFaces, materialFaces, materialFaces, materialFaces, materialFaces, materialFaces]
        }
        
    }
    
    geometry.materials = [materialFace1, materialFace3, materialFace2, materialFaces, materialFaces, materialFaces]
}


func tweetImage(tweetContent:tweetContent, fontSize:CGFloat = 45, fontColor:UIColor = .white, imageSize:CGSize, backgroundColor:UIColor, expanded: Bool = false) -> UIImage? {
    
    let tweetRect = CGRect(origin: CGPoint.zero, size: imageSize)
    UIGraphicsBeginImageContext(imageSize)
    
    defer {
        UIGraphicsEndImageContext()
    }
    
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    // Fill the background with a color
    context.setFillColor(backgroundColor.cgColor)
    context.fill(tweetRect)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .left
    
    let paragraphStyleMinutes = NSMutableParagraphStyle()
    paragraphStyleMinutes.alignment = .right
    
    // Full tweet
    
    let attributesTitle:[NSAttributedStringKey:Any] = [
        NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size:fontSize) as Any,
        NSAttributedStringKey.paragraphStyle: paragraphStyle,
        NSAttributedStringKey.foregroundColor: fontColor,
        ]
    let textSizeTitle = "A".size(withAttributes: attributesTitle)
    
    let attributesContent:[NSAttributedStringKey:Any] = [
        NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size:fontSize) as Any,
        NSAttributedStringKey.paragraphStyle: paragraphStyle,
        NSAttributedStringKey.foregroundColor: fontColor
    ]
    
    let attributesMinutesAgo:[NSAttributedStringKey:Any] = [
        NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size:fontSize) as Any,
        NSAttributedStringKey.paragraphStyle: paragraphStyleMinutes,
        NSAttributedStringKey.foregroundColor: fontColor
    ]
    let textSizeContent = "a".size(withAttributes: attributesMinutesAgo)
    
    let margin:CGFloat = 45
    
    let imageLogoWidthHeight:CGFloat = 142
    let imageLogoRect = CGRect(x: margin, y: margin, width: imageLogoWidthHeight, height: imageLogoWidthHeight)
    //let imageLogo = UIImage(named: tweetContent.logo)
    
    var imageLogo = UIImage()
    loadProfilePicture(author: tweetContent.twitterId, completion: {(image, error) -> Void in
        
        imageLogo = image ?? UIImage(named: tweetContent.logo)!
        
        imageLogo = imageLogo.kf.image(withRoundRadius: imageLogoWidthHeight/2, fit: imageLogo.size)
        imageLogo.draw(in: imageLogoRect)
        
    })
    
    var imageContent = UIImage()
    
    if tweetContent.twitterId != "", let urlSaved = gTweetPhotos[tweetContent.tweetID] {
        
        loadPicture(tweetID: tweetContent.tweetID, completion: {(image, error) -> Void in
            imageContent = image ?? UIImage(named: tweetContent.logo)!
            
            let imageContentWidth = imageSize.width-2*margin
            var imageContentHeight:CGFloat = 0
            
            if expanded {
                
                let proportion = imageContent.size.height / imageContent.size.width
                imageContentHeight = proportion * imageContentWidth
                
            } else {
                imageContentHeight = 230.0
            }
            
            let imageContentRect = CGRect(x: margin, y: imageSize.height-margin-imageContentHeight, width: imageContentWidth, height: imageContentHeight)
            
            if tweetContent.tweetID != "", let urlSaved = gTweetPhotos[tweetContent.tweetID] {
                
                let photoSize = CGSize(width: imageContentRect.width, height: imageContentRect.height)

                if imageContent.size.width < photoSize.width || imageContent.size.height < photoSize.height{
                    imageContent = imageContent.kf.resize(to: photoSize, for: .aspectFill)
                }
                
                if !expanded{
                    imageContent = imageContent.kf.crop(to: photoSize, anchorOn: CGPoint(x: 0.5, y: 0.5))
                }
                
                imageContent = imageContent.kf.image(withRoundRadius: 19, fit: photoSize)
                
                imageContent.draw(in: imageContentRect)
                
            }
            
        })
        
    }
    
    let title: String = tweetContent.title
    let titleRect = CGRect(x: margin*2 + imageLogoWidthHeight, y: margin, width: imageSize.width - 5*margin - imageLogoWidthHeight, height: textSizeTitle.height)
    title.draw(in: titleRect, withAttributes: attributesTitle)
    
    let ago: String = tweetContent.date.tweetTimeAgo()
    let agoRect = CGRect(x: imageSize.width-margin-200, y: margin, width: 200, height: textSizeContent.height)
    ago.draw(in: agoRect, withAttributes: attributesMinutesAgo)
    
    let twitterName: String = "@\(tweetContent.twitterId)"
    let twitterNameRect = CGRect(x: margin*2 + imageLogoWidthHeight, y: margin*2.5, width: imageSize.width - 2*margin - imageLogoWidthHeight, height: textSizeContent.height)
    twitterName.draw(in: twitterNameRect, withAttributes: attributesContent)
    
    let content: String = tweetContent.content
    var contentRect = CGRect(x: margin, y: margin*2 + imageLogoWidthHeight, width: imageSize.width-2*margin, height: 700)
    
    // if there is an image, so text does not go above it
    if !expanded && tweetContent.tweetID != ""{
        if let photoSaved = gTweetPhotos[tweetContent.tweetID]{
            contentRect = CGRect(x: margin,
                                 y: margin*2 + imageLogoWidthHeight,
                                 width: imageSize.width-2*margin,
                                 height: imageSize.height - (margin*2 + imageLogoWidthHeight) - 230)
        }
    }
    
    if expanded {
        contentRect = CGRect(x: margin, y: margin*2 + imageLogoWidthHeight, width: imageSize.width-2*margin, height: 900)
    }
    content.draw(in: contentRect, withAttributes: attributesContent)

    if let image = UIGraphicsGetImageFromCurrentImageContext() {
        return image
    }
    return nil
    
}

func heightNeededForExpandedTweetCalculation(tweetContent: tweetContent, completion: @escaping (CGFloat?, CGFloat?, Error?) -> Void) {
    
    let margin:CGFloat = 45
    var imageContent = UIImage()
    var imageContentHeight:CGFloat = 0
    let imageContentWidth = 1000 - 2*margin
    let imageLogoWidthHeight:CGFloat = 142
    
    let topHeight = margin*2 + imageLogoWidthHeight
    let textHeight = getStringHeight(mytext: tweetContent.content, fontSize: 45, width: imageContentWidth)
    
    if tweetContent.twitterId != "", let urlSaved = gTweetPhotos[tweetContent.tweetID] {
        loadPicture(tweetID: tweetContent.tweetID, completion: {(image, error) -> Void in
            
            if image == nil{
                completion(nil, nil, nil)
                return
            }
            
            imageContent = image! // ?? UIImage(named: tweetContent.logo)!
            
            let proportion:CGFloat = imageContent.size.height / imageContent.size.width
            imageContentHeight = proportion * imageContentWidth
            
            completion(1000, topHeight + textHeight + imageContentHeight + 2*margin, nil)
        })

    } else {
        completion(1000, topHeight + textHeight + imageContentHeight + 2*margin, nil)
    }
    
}

func likeCommentImage(UnderTweet:UnderOpenTweet? = nil, activated: Bool, imageSize:CGSize, backgroundColor:UIColor) -> UIImage? {
    
    let imageRect = CGRect(origin: CGPoint.zero, size: imageSize)
    UIGraphicsBeginImageContext(imageSize)
    
    defer {
        UIGraphicsEndImageContext()
    }
    
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    // Fill the background with a color
    context.setFillColor(backgroundColor.cgColor)
    context.fill(imageRect)
    
    var imageLogo = UIImage()
    
    if UnderTweet == UnderOpenTweet.Like{
        imageLogo = UIImage(named: "like")!
    } else if UnderTweet == UnderOpenTweet.Retweet {
        imageLogo = UIImage(named: "retweet")!
    } else if UnderTweet == UnderOpenTweet.Expand {
        imageLogo = UIImage(named: "expand")!
    } else if UnderTweet == UnderOpenTweet.Share {
        imageLogo = UIImage(named: "share")!
    }
    
    let imageProportion = imageLogo.size.height/imageLogo.size.width
    
    if activated && UnderTweet == UnderOpenTweet.Like{
        imageLogo = imageLogo.tint(with: kLikeColor)
    } else if activated && UnderTweet == UnderOpenTweet.Retweet{
        imageLogo = imageLogo.tint(with: kRetweetColor)
    }else {
        imageLogo = imageLogo.tint(with: .black)
    }
    
    let imageWidth = imageSize.width/2
    let imageHeight = imageWidth * imageProportion
    let logoRect = CGRect(x: imageSize.width/2 - imageWidth/2, y: imageSize.height/2 - imageHeight/2, width: imageWidth, height: imageHeight)
    
    imageLogo.draw(in: logoRect)
    
    if let image = UIGraphicsGetImageFromCurrentImageContext() {
        return image
    }
    return nil
}

func logoImage(imageSize:CGSize, backgroundColor:UIColor) -> UIImage? {
    
    let imageRect = CGRect(origin: CGPoint.zero, size: imageSize)
    UIGraphicsBeginImageContext(imageSize)
    
    defer {
        UIGraphicsEndImageContext()
    }
    
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    // Fill the background with a color
    context.setFillColor(backgroundColor.cgColor)
    context.fill(imageRect)
    
    var imageLogo = UIImage(named: "logoBlue")!
    imageLogo = imageLogo.tint(with: logoColor)
    
    let imageProportion = imageLogo.size.height/imageLogo.size.width
    
    let imageHeight = imageSize.height/2
    let imageWidth = imageHeight * imageProportion
    let logoRect = CGRect(x: imageSize.width/2 - imageWidth/2, y: imageSize.height/2 - imageHeight/2, width: imageWidth, height: imageHeight)
    
    imageLogo.draw(in: logoRect)
    
    if let image = UIGraphicsGetImageFromCurrentImageContext() {
        return image
    }
    return nil
}

func menuButtonImage(MenuButton:Menu? = nil, imageSize:CGSize, backgroundColor:UIColor) -> UIImage? {
    
    let imageRect = CGRect(origin: CGPoint.zero, size: imageSize)
    UIGraphicsBeginImageContext(imageSize)
    
    defer {
        UIGraphicsEndImageContext()
    }
    
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    // Fill the background with a color
    context.setFillColor(backgroundColor.cgColor)
    context.fill(imageRect)
    
    var imageLogo = UIImage()
    
    if MenuButton == Menu.Profile{
        imageLogo = UIImage(named: "profile")!
    } else if MenuButton == Menu.Home {
        imageLogo = UIImage(named: "home")!
    } else if MenuButton == Menu.Search {
        imageLogo = UIImage(named: "search")!
    } else if MenuButton == Menu.Notifications {
        imageLogo = UIImage(named: "notification")!
    } else if MenuButton == Menu.MR {
        imageLogo = UIImage(named: "goggles")!
    } else if MenuButton == Menu.WriteTweet {
        imageLogo = UIImage(named: "edit")!
    } else if MenuButton == Menu.Up || MenuButton == Menu.Down {
        imageLogo = UIImage(named: "downArrow")!
    } else if MenuButton == Menu.Logout {
        imageLogo = UIImage(named: "logout")!
    } else if MenuButton == Menu.Refresh {
        imageLogo = UIImage(named: "refreshMenu")!
    } else if MenuButton == Menu.WelcomeNotReallyMenu{
        imageLogo = UIImage(named: "logoWhite")!
    }
    
    let imageProportion = imageLogo.size.height/imageLogo.size.width
    
    var imageWidth = CGFloat()
    var imageHeight = CGFloat()
    
    if MenuButton != Menu.WelcomeNotReallyMenu && MenuButton != Menu.Profile && MenuButton != Menu.Logout && MenuButton != Menu.Refresh {
        imageLogo = imageLogo.tint(with: .black)
        imageWidth = imageSize.width/2
    } else if MenuButton == Menu.WelcomeNotReallyMenu {
        imageWidth = imageSize.width/2
    } else if MenuButton == Menu.Profile || MenuButton == Menu.Logout || MenuButton == Menu.Refresh { // icones trop longues en hauteur
        imageWidth = imageSize.width/2.5
    } else {
        imageWidth = imageSize.width
    }
    
    imageHeight = imageWidth * imageProportion
    
    let logoRect = CGRect(x: imageSize.width/2 - imageWidth/2, y: imageSize.height/2 - imageHeight/2, width: imageWidth, height: imageHeight)
    
    imageLogo.draw(in: logoRect)
    
    if let image = UIGraphicsGetImageFromCurrentImageContext() {
        return image
    }
    return nil
}

func textImage(text:String, fontSize:CGFloat = 60, fontColor:UIColor = .black, imageSize:CGSize, backgroundColor:UIColor) -> UIImage? {
    
    let imageRect = CGRect(origin: CGPoint.zero, size: imageSize)
    UIGraphicsBeginImageContext(imageSize)
    
    defer {
        UIGraphicsEndImageContext()
    }
    
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    // Fill the background with a color
    context.setFillColor(backgroundColor.cgColor)
    context.fill(imageRect)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    // Define the attributes of the text
    let attributes:[NSAttributedStringKey:Any] = [
        NSAttributedStringKey.font: UIFont(name: "AvenirNext-Medium", size:fontSize) as Any,
        NSAttributedStringKey.paragraphStyle: paragraphStyle,
        NSAttributedStringKey.foregroundColor: fontColor
    ]
    
    // Determine the width/height of the text for the attributes
    let textSize = text.size(withAttributes: attributes)
    
    text.draw(at: CGPoint(x: imageSize.width/2 - textSize.width/2, y: imageSize.height/2 - textSize.height/2), withAttributes: attributes)
    
    
    if let image = UIGraphicsGetImageFromCurrentImageContext() {
        return image
    }
    return nil
}






