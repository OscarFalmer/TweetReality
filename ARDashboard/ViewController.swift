//
//  ViewController.swift
//  ARDashboard
//
//  Created by Oscar Falmer on 12/09/2017.
//  Copyright © 2017 Oscar Falmer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SafariServices
import TwitterKit
import MediaPlayer
import SnapKit
import Reachability
import JPSVolumeButtonHandler
import JGProgressHUD
import Crashlytics

var gMRActivated = false // MixedReality / Stereoscopic Mode
var gMRClickActivated = false

var gNodeShowedUp = false
var gSearchBarInFront = false
var gSearchBarInOpened = false
var gNewTweetOpened = false
var gNewReplyOpened = false
var gExpandedTweetOpened = false

var gSessionInterrupted = false

var gTweetOpened:TWTRTweet? = nil

var gShowedNodeName = ""

var gCurrentView:KindOfTweet = .timeline

var gTweetsIdsUpDown:[[String]] = [] //when we touch ^ or v

var gCurrentIndexUpDown:Int = 0

var gTweetPhotos:[String:String] = [:]
var gTweetLinks:[String:String] = [:]
var gTweetRepliedRepliesPhotos:[String:String] = [:]

var gTweetLikes:[String] = []
var gTweetUnLikes:[String] = []
var gTweetRetweets:[String] = []
var gTweetUnRetweets:[String] = []

var gActionInProgress = false

var hud = JGProgressHUD(style: .extraLight)

class ViewController: UIViewController, ARSCNViewDelegate, UITextFieldDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var boxWidth: CGFloat = 0.4
    var boxHeight: CGFloat = 0.3
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    let resetButton = UIButton()
    
    lazy var loginLogoImage = UIImageView()
    lazy var loginLabel1 = UILabel()
    lazy var loginLabel2 = UILabel()
    lazy var loginButton = UIButton()
    lazy var loginBackgroundTop = UIImageView()
    lazy var loginBackgroundDown = UIView()
    lazy var loginContainer = UIView()
    
    lazy var detectionAnimation = UIImageView()
    
    var loginContainerCenterYConstraint: Constraint? = nil
    
    lazy var sceneView3 = ARSCNView()
    
    lazy var informationContainer = UIView()
    lazy var informationLabel2 = UILabel()
    
    var worldReadyToBeShown = false
    var worldStabilizationReady = false
    var worldShown = false
    
    var searchBarInvisbleTextField = UITextField()
    var newTweetInvisbleTextField = UITextField()
    
    let reachability = Reachability()!
    
    var volumeButtonHandler: JPSVolumeButtonHandler?
    
    var savedTweets = [TWTRTweet]()
    
    var sessionInterruptedMessage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarInvisbleTextField.returnKeyType = .go
        newTweetInvisbleTextField.returnKeyType = .done
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        searchBarInvisbleTextField.delegate = self
        newTweetInvisbleTextField.delegate = self
        
        addInformationLabel(VC: self)
        addSearchBarInvisibleTextField(VC: self)
        addNewTweetInvisibleTextField(VC: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        if gMRClickActivated {
            
            let volumeButtonAction:JPSVolumeButtonBlock = { () -> Void in
                let location = CGPoint(x: self.sceneView.bounds.width/2, y: self.sceneView.bounds.height/2)
                let hitResults = self.sceneView.hitTest(location, options: nil)
                
                if hitResults.count > 0 {
                    let result = hitResults.first!
                    handleTouchFor(node: result.node, boxSize: boxSizeMini, sceneView: self.sceneView, VC: self)
                }
            }
            self.volumeButtonHandler = JPSVolumeButtonHandler(up: volumeButtonAction, downBlock: volumeButtonAction)
            
        }
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi || reachability.connection == .cellular {
                
                //in case it showed not internet connection previously
                self.showMessage("", exit: true, duration: 0)
                
                print("Reachable")
                reachability.stopNotifier()
                
                let store = TWTRTwitter.sharedInstance().sessionStore
                
                if let _ = store as TWTRSessionStore?, store.session()?.userID != nil{
                    print("logged in as \(store.session()?.userID as String?)")
                    setup(kind: KindOfTweet.timeline, VC: self)
                    
                } else {
                    print("login view installation")
                    
                    addLoginView(VC: self)
                    self.checkCameraAuthorization()
                    
                }
                
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            
            self.showMessage(kNoInternetConnection)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    func checkCameraAuthorization(){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            print("--already authorized")
            
            LoginViewAppear(VC: self)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    print("--access allowed")
                    
                    LoginViewAppear(VC: self)
                } else {
                    //access denied
                    print("--access denied")
                }
            })
        }
    }
    
    // MARK: Loading Message
    
    func showHUDWithTransform() {
        
        hud = JGProgressHUD(style: .extraLight)
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Loading..."
        hud.progress = 0.0 //setProgress(0, animated: false)
        hud.position = .center
        hud.show(in: sceneView)
        
    }
    
    func HUDtoBottomPlaneDetection(sessionRestarted: Bool = false){
        
        //GIF animation - begin
        
        if sessionRestarted == false{
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 20.0)
                hud.textLabel.text = "Floor detection\nPlease aim at the floor"
                hud.position = .bottomCenter
                hud.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
            }
        } else {
            
            
            hud = JGProgressHUD(style: .extraLight)
            hud.indicatorView = nil
            hud.textLabel.font = UIFont.systemFont(ofSize: 20.0)
            hud.textLabel.text = "Floor detection\nPlease aim at the floor"
            hud.position = .bottomCenter
            hud.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
            hud.show(in: sceneView, animated: false)
        }
        
        addDetectionAnimation(VC: self)
        
    }
    
    func HUDdismiss(){
        
        // GIF animation - end
        removeDetectionAnimation(VC: self)
        
        UIView.animate(withDuration: 0.3) {
            hud.textLabel.text = "Look up"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            hud.dismiss()
        }
        
    }
    
    func showMessage(_ message: String, exit: Bool = false, duration: TimeInterval = 1.0) {
        DispatchQueue.main.async {
            
            if exit {
                UIView.animate(withDuration: duration, animations: {
                    self.informationContainer.alpha = 0.0
                })
            } else if self.informationContainer.alpha == 0.0{
                self.informationLabel2.text = message
                UIView.animate(withDuration: duration, animations: {
                    self.informationContainer.alpha = 1.0
                })
            } else {
                self.informationLabel2.text = message
            }
            
        }
    }
    

    var movedObject:SCNNode?
    var sonOfMovedObject:SCNNode?
    var fingerDifferenceFromPosition:Float?
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .began {

            let tapPoint: CGPoint = recognizer.location(in: sceneView)
            let result = sceneView.hitTest(tapPoint, options: nil)
            if result.count == 0 {
                return
            }
            let hitResult: SCNHitTestResult? = result.first
            
            if gNodeShowedUp{
                if (hitResult?.node.name == kTopTweetName || hitResult?.node.name == kDownTweetName) && hitResult?.node.parent?.name == gShowedNodeName{
                    movedObject = hitResult?.node.parent
                    sonOfMovedObject = hitResult?.node
                } else if (hitResult?.node.name?.contains(kRectangleName))! && hitResult?.node.name == gShowedNodeName{
                    movedObject = hitResult?.node
                }
            }
            
        } else if recognizer.state == .changed {
            if (movedObject != nil && movedObject?.position != nil) {

                let projectedOrigin = sceneView.projectPoint((movedObject?.worldPosition)!)
                
                let fingerLocation2D = recognizer.location(in: sceneView)
                let fingerLocation3D = SCNVector3Make(Float(fingerLocation2D.x), Float(fingerLocation2D.y), projectedOrigin.z)
                let fingerRealLocation3D = sceneView.unprojectPoint(fingerLocation3D)
                
                var childDifference:Float = 0
                
                if sonOfMovedObject != nil{
                    childDifference = (sonOfMovedObject?.position.y)!
                }
                
                // we calculate the difference between world center and finger only at launch
                if fingerDifferenceFromPosition == nil{
                    
                    if sonOfMovedObject == nil{ // si on touche le tweet de base => parfait
                        fingerDifferenceFromPosition = abs(fingerRealLocation3D.y - (movedObject?.worldPosition.y)!)
                        
                        if fingerRealLocation3D.y > (movedObject?.worldPosition.y)!{
                            fingerDifferenceFromPosition! *= -1
                        }
                    } else {
                        
                        fingerDifferenceFromPosition = (movedObject?.worldPosition.y)! + (sonOfMovedObject?.position.y)! - fingerRealLocation3D.y

                    }
                    
                    print("fingerDifferenceFromPosition        \(fingerDifferenceFromPosition!)")
                }

                movedObject?.worldPosition = SCNVector3Make((movedObject?.worldPosition.x)!,
                                                       fingerRealLocation3D.y - childDifference + fingerDifferenceFromPosition!,
                                                       (movedObject?.worldPosition.z)!)
                
            }
        } else if recognizer.state == .ended {
            
            print("END")
            
            movedObject = nil
            sonOfMovedObject = nil
            fingerDifferenceFromPosition = nil
        }
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        
        if recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.changed || recognizer.state == UIGestureRecognizerState.ended{
            
            var touchLocation = CGPoint()
            var hitResults:[SCNHitTestResult] = []
            
            if gMRActivated{
                if recognizer.location(in: view).y < view.bounds.size.height/2{
                    touchLocation = recognizer.location(in: sceneView)
                    hitResults = sceneView.hitTest(touchLocation, options: nil)
                } else {
                    touchLocation = recognizer.location(in: sceneView3)
                    hitResults = sceneView3.hitTest(touchLocation, options: nil)
                }
            } else {
                touchLocation = recognizer.location(in: sceneView)
                hitResults = sceneView.hitTest(touchLocation, options: nil)
            }
            
            if hitResults.count > 0 {
                let result = hitResults.first!
                
                handleTouchFor(node: result.node, boxSize: boxSizeMini, sceneView: sceneView, VC: self)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if gMRActivated{
            DispatchQueue.main.async {
                updateFrame(VC: self)
            }
        }
        
        // App Opening
        if worldShown == false && worldReadyToBeShown == true{
            DispatchQueue.main.async {
                if self.worldStabilizationReady == false{
                    testingStabilization(sceneView: self.sceneView, VC: self)
                } else { // puis
                    gActionInProgress = true
                    
                    centerViewTouchesWelcomeLogo(sceneView: self.sceneView, VC: self)
                }
            }
        }
        
        // App closed and Reopened
        if gSessionInterrupted == true {
            
            DispatchQueue.main.async {
                if self.worldStabilizationReady == false{
                    testingStabilization(sceneView: self.sceneView, VC: self)
                } else { // puis
                    gSessionInterrupted = false
                    hideEVERYTHING(sceneView: self.sceneView, VC: self, hide: false)
                }
            }
            
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        
        let childNodes:[SCNNode] = (sceneView.scene.rootNode.childNode(withName: kRootNodeName, recursively: false)?.childNodes)!
        
        for node in childNodes{
            if (node.name == kSearchBarName && textField == searchBarInvisbleTextField){
                (node.childNode(withName: kTextNodeSearchName, recursively: true)?.geometry as! SCNText).string = textField.text
            } else if (node.name == kNewTweetBox && textField == newTweetInvisbleTextField) {
                
                if gNewReplyOpened{
                    (node.childNode(withName: kTextNodeNewTweetName, recursively: true)?.geometry as! SCNText).string = "@\(gTweetOpened!.author.screenName) " + textField.text!
                } else {
                    (node.childNode(withName: kTextNodeNewTweetName, recursively: true)?.geometry as! SCNText).string = textField.text
                }
                
                let charactersLeft = 140 - (textField.text?.characters.count)!
                (node.childNode(withName: kTextNodeNewTweetLenghtName, recursively: true)?.geometry as! SCNText).string = "\n\n\n\n\n\n\n\n\(String(charactersLeft))"
                
                if charactersLeft <= 20 {
                    (node.childNode(withName: kTextNodeNewTweetLenghtName, recursively: true)?.geometry as! SCNText).materials.first?.diffuse.contents = UIColor.init(rgb: 0xF03434)
                } else {
                    (node.childNode(withName: kTextNodeNewTweetLenghtName, recursively: true)?.geometry as! SCNText).materials.first?.diffuse.contents = UIColor.black
                }
            }
        }
        
    }
    
    @objc func textFieldDidFinish(_ textField: UITextField){
        
        if textField == searchBarInvisbleTextField{
            searchBarInvisbleTextField.resignFirstResponder()
            searchBarAnimation(to: .back, sceneView: self.sceneView)
            newSetup(kind: .search, query: searchBarInvisbleTextField.text, sceneView: sceneView, VC: self)
        
        } else if textField == newTweetInvisbleTextField{
            newTweetInvisbleTextField.resignFirstResponder()
            newTweetInvisbleTextField.text = ""
        }
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        restartExperience()
    }
    
    func restartExperience() {
        guard isRestartAvailable else { return }
        isRestartAvailable = false
        
        resetButton.alpha = 0.5
        resetAction()
        
        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isRestartAvailable = true
            self.resetButton.alpha = 1.0
        }
    }
    
    func resetAction() {
        
        moveableRootNodeSetup(sceneView: sceneView, resetButton: true)
    
    }
    
    
    func listenVolumeButton(activated: Bool) {
        
        if activated{
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.bounds.width/2,y: view.bounds.height/4), radius: CGFloat(2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.white.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1.0
            shapeLayer.name = kWhiteDotName
            
            let shapeLayer2 = CAShapeLayer()
            shapeLayer2.path = circlePath.cgPath
            shapeLayer2.fillColor = UIColor.white.cgColor
            shapeLayer2.strokeColor = UIColor.white.cgColor
            shapeLayer2.lineWidth = 1.0
            shapeLayer2.name = kWhiteDotName
            
            sceneView.layer.addSublayer(shapeLayer)
            sceneView3.layer.addSublayer(shapeLayer2)
            
            self.volumeButtonHandler?.start(true)
            
        } else {
            
            self.volumeButtonHandler?.stop()
            
            if (sceneView.layer.sublayers != nil){
                for layer in sceneView.layer.sublayers! {
                    if layer.name == kWhiteDotName {
                        layer.removeFromSuperlayer()
                    }
                }
            }
            
            if (sceneView3.layer.sublayers != nil){
                for layer in sceneView3.layer.sublayers! {
                    if layer.name == kWhiteDotName {
                        layer.removeFromSuperlayer()
                    }
                }
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        //print("trackingState: \(camera.trackingState)")
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Use `flatMap(_:)` to remove optional error messages.
        let errorMessage = messages.flatMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: kARSessionFailedMessage, message: errorMessage)
        }
    }
    
    func displayErrorMessage(title: String, message: String) {
        // Blur the background.
        //blurView.isHidden = false
        
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetAction()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func displayNormalMessage(title: String, message: String) {

        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "OK", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
        // just in case world stabilization is already in progress and the app is reopened
        if worldStabilizationReady == true {
            
            worldStabilizationReady = false
            gSessionInterrupted = true
            
            hideEVERYTHING(sceneView: sceneView, VC: self, hide: true)
            
            HUDtoBottomPlaneDetection(sessionRestarted: true)
            
        }
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        self.showMessage(kResettingSessionMessage, exit: true)
        restartExperience()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {

        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 140
        
    }
    
    @objc func twitterLogin(_ sender: UIButton){
        
        self.loginButton.setTitle(kLoadingLogingMessage, for: UIControlState.normal)
        
        TWTRTwitter.sharedInstance().logIn(completion: { session, error in
            
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))")
                
                self.loginContainerCenterYConstraint?.update(offset: -self.view.bounds.height/2)
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.loginContainer.viewWithTag(1234)?.removeFromSuperview()
                    self.view.viewWithTag(123456)?.removeFromSuperview()
                    
                    self.sessionInterruptedMessage = true
                    
                    setup(kind: KindOfTweet.timeline, VC: self)
                }
                
            } else {
                self.loginButton.setTitle("Error", for: UIControlState.normal)
                
                print("error: \(String(describing: error?.localizedDescription))")
            }
        })
        
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool
    {
        return true
    }
    
}
