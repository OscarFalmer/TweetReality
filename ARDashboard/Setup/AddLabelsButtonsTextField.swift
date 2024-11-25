//
//  AddLabelsButtons.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 10/10/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import SnapKit
import SwiftyGif

func addSearchBarInvisibleTextField(VC: ViewController){
    
    VC.searchBarInvisbleTextField.text = ""
    VC.searchBarInvisbleTextField.autocorrectionType = .no
    VC.searchBarInvisbleTextField.frame = CGRect(x: 0, y: -40, width: 300, height: 30)
    VC.searchBarInvisbleTextField.addTarget(VC, action: #selector(VC.textFieldDidChange(_:)), for: .editingChanged)
    VC.searchBarInvisbleTextField.addTarget(VC, action: #selector(VC.textFieldDidFinish(_:)), for: .editingDidEndOnExit )
    VC.view.addSubview(VC.searchBarInvisbleTextField)
}

func addNewTweetInvisibleTextField(VC: ViewController){
    
    VC.newTweetInvisbleTextField.text = ""
    VC.newTweetInvisbleTextField.autocorrectionType = .no
    VC.newTweetInvisbleTextField.frame = CGRect(x: 0, y: -40, width: 300, height: 30)
    VC.newTweetInvisbleTextField.addTarget(VC, action: #selector(VC.textFieldDidChange(_:)), for: .editingChanged)
    VC.newTweetInvisbleTextField.addTarget(VC, action: #selector(VC.textFieldDidFinish(_:)), for: .editingDidEndOnExit )
    VC.view.addSubview(VC.newTweetInvisbleTextField)
}

func addResetButton(VC: ViewController){
    
    var x:CGFloat = 60
    var y:CGFloat = 20
    
    switch UIScreen.main.nativeBounds.height{
    case 2436: // iPhone X
        x = 70
        y = 10
    default:
        x = 60
        y = 20
    }
    
    VC.resetButton.frame = CGRect(x: VC.view.frame.size.width - x, y: -y, width: 80, height: 80)
    VC.resetButton.backgroundColor = UIColor.clear
    VC.resetButton.setImage(UIImage(named: "refresh"), for: .normal)
    VC.resetButton.addTarget(VC, action: #selector(VC.buttonAction), for: .touchUpInside)
    VC.resetButton.alpha = 0
    VC.resetButton.tag = 9999999
    VC.view.addSubview(VC.resetButton)
    
    UIView.animate(withDuration: 0.3){
        VC.resetButton.alpha = 1.0
    }
}

func addInformationLabel(VC: ViewController){
    
    VC.informationContainer.contentMode = .scaleToFill
    VC.informationContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    VC.informationContainer.alpha = 0.0
    VC.informationContainer.roundCorners(radius: 10)
    VC.view.addSubview(VC.informationContainer)
    VC.informationContainer.snp.makeConstraints{ (make) -> Void in
        make.center.equalToSuperview()
    }
    
    VC.informationLabel2.font = UIFont.systemFont(ofSize: 22.0)
    VC.informationLabel2.textColor = .white
    VC.informationLabel2.textAlignment = .center
    VC.informationLabel2.text = ""
    VC.informationLabel2.numberOfLines = 0
    VC.informationContainer.addSubview(VC.informationLabel2)
    VC.informationLabel2.snp.makeConstraints{ (make) -> Void in
        make.bottom.equalTo(VC.informationContainer).offset(-8)
        make.top.equalTo(VC.informationContainer).offset(8)
        make.left.equalTo(VC.informationContainer).offset(8)
        make.right.equalTo(VC.informationContainer).offset(-8)
    }
    
}

func LoginViewAppear(VC: ViewController){
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        
        VC.loginContainerCenterYConstraint?.update(offset: VC.view.bounds.height/2)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            VC.view.layoutIfNeeded()
        }, completion: nil)
    }
}

func addLoginView(VC: ViewController){
    
    VC.loginContainer.contentMode = .scaleToFill
    VC.loginContainer.backgroundColor = UIColor(rgb: 0xF0EEEE)
    VC.loginContainer.viewWithTag(123456)
    VC.loginContainer.roundCorners(radius: 18)
    VC.view.addSubview(VC.loginContainer)
    
    VC.loginContainer.snp.remakeConstraints{ (make) -> Void in
        make.centerX.equalToSuperview()
        VC.loginContainerCenterYConstraint = make.centerY.equalTo(-VC.view.bounds.height/2).constraint
    }
    
    let logo = #imageLiteral(resourceName: "logoWhite")
    VC.loginLogoImage.image = logo
    VC.loginLogoImage.contentMode = .scaleAspectFit
    VC.loginLogoImage.layer.zPosition = 2
    VC.loginContainer.addSubview(VC.loginLogoImage)
    VC.loginLogoImage.snp.makeConstraints{ (make) -> Void in
        make.top.equalTo(VC.loginContainer).offset(32)
        make.left.equalTo(VC.loginContainer).offset(20)
        make.right.equalTo(VC.loginContainer).offset(-20)
        make.height.equalTo(56)
    }
    
    VC.loginLabel1.text = kAppName
    VC.loginLabel1.font = UIFont.init(name: kFontRobotoRegular, size: 22)
    VC.loginLabel1.textColor = .white
    VC.loginLabel1.textAlignment = .center
    VC.loginLabel1.layer.zPosition = 2
    VC.loginContainer.addSubview(VC.loginLabel1)
    VC.loginLabel1.snp.makeConstraints{ (make) -> Void in
        make.top.equalTo(VC.loginLogoImage.snp.bottom).offset(20)
        make.left.equalTo(VC.loginContainer).offset(20)
        make.right.equalTo(VC.loginContainer).offset(-20)
    }
    
    VC.loginLabel2.text = kLoginTitle
    VC.loginLabel2.font = UIFont.init(name: kFontRobotoLight, size: 20)
    VC.loginLabel2.textColor = .white
    VC.loginLabel2.numberOfLines = 0
    VC.loginLabel2.textAlignment = .center
    VC.loginLabel2.layer.zPosition = 2
    VC.loginContainer.addSubview(VC.loginLabel2)
    VC.loginLabel2.snp.makeConstraints{ (make) -> Void in
        make.top.equalTo(VC.loginLabel1.snp.bottom).offset(20)
        make.left.equalTo(VC.loginContainer).offset(20)
        make.right.equalTo(VC.loginContainer).offset(-20)
    }
    
    VC.loginButton.titleLabel?.font = UIFont.init(name: kFontRobotoRegular, size: 18)
    VC.loginButton.setTitle(kLoginButtonMessage, for: UIControlState.normal)
    VC.loginButton.setTitleColor(UIColor.init(rgb: 0x42A1CF), for: UIControlState.normal)
    VC.loginButton.backgroundColor = .white
    VC.loginButton.layer.cornerRadius = 22.5
    VC.loginButton.layer.zPosition = 2
    
    VC.sessionInterruptedMessage = false
    VC.loginButton.addTarget(VC, action: #selector(VC.twitterLogin(_:)), for: .touchUpInside)
    
    VC.loginContainer.addSubview(VC.loginButton)
    VC.loginButton.snp.makeConstraints{ (make) -> Void in
        make.top.equalTo(VC.loginLabel2.snp.bottom).offset(28)
        make.centerX.equalToSuperview()
        make.height.equalTo(45)
        make.width.equalTo(200)
        make.left.equalTo(VC.loginContainer).offset(43)
        make.right.equalTo(VC.loginContainer).offset(-43)
        
        make.bottom.equalTo(VC.loginContainer).offset(-32)
    }
    
    VC.loginBackgroundTop.layer.zPosition = 1
    VC.loginBackgroundTop.backgroundColor = .blue
    VC.loginBackgroundTop.image = #imageLiteral(resourceName: "LoginBackgroundTopTest3x")
    VC.loginBackgroundTop.contentMode = .scaleAspectFill //.center //.scaleAspectFill
    VC.loginBackgroundTop.clipsToBounds = true
    VC.loginBackgroundTop.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 0), for: .vertical)
    
    VC.loginContainer.addSubview(VC.loginBackgroundTop)
    VC.loginBackgroundTop.snp.remakeConstraints{ (make) -> Void in
        make.top.equalTo(VC.loginContainer)
        make.right.left.equalTo(VC.loginContainer)
        make.bottom.equalTo(VC.loginContainer)
    }

}

func addDetectionAnimation(VC: ViewController){
    
    var gifWidth = CGFloat()
    if (VC.view.bounds.height < 2500){
        gifWidth = VC.view.bounds.width * 0.9
    } else {
        gifWidth = VC.view.bounds.width / 4.0
    }
    
    let proportion:CGFloat = 749/1138
    
    let gifHeight = gifWidth * proportion
    
    var gifX = CGFloat()
    gifX = VC.view.bounds.width/2 - gifWidth/2 - 7
    
    var gifY = CGFloat()
    gifY = VC.view.bounds.height/2 - gifHeight/2
    
    let gifViewFrame:CGRect = CGRect(x: gifX, y: gifY, width: gifWidth, height: gifHeight)
    
    let gif = UIImage(gifName: "detectionAnimation_0-160-NEW-Photoshops8")
    let gifManager = SwiftyGifManager.init(memoryLimit: 30)
    
    VC.detectionAnimation = UIImageView(gifImage: gif, manager: gifManager)
    VC.detectionAnimation.frame = gifViewFrame
    VC.detectionAnimation.viewWithTag(123456789)
    VC.detectionAnimation.alpha = 0
    VC.view.addSubview(VC.detectionAnimation)
    
    UIView.animate(withDuration: 0.3){
        VC.detectionAnimation.alpha = 1.0
    }
    
}

func removeDetectionAnimation(VC: ViewController){
    
    UIView.animate(withDuration: 0.3){
        VC.detectionAnimation.alpha = 0
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        VC.detectionAnimation.stopAnimating()
        VC.view.viewWithTag(123456789)?.removeFromSuperview()
    }
    
}




