//
//  subscriptionViewController.swift
//  userIdBasedSwift
//
//  Created by Anantha Krishnan K G on 20/07/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit
import BMSPush
import BMSCore

class subscriptionViewController: UIViewController ,UITextViewDelegate, UIGestureRecognizerDelegate{
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var push = BMSPushClient()
    var isKeyBoardUp = false;
    
    @IBOutlet var tagsView: UITextView!
    @IBOutlet var regTagsView: UITextView!
    @IBOutlet var unRegTagsView: UITextView!
    @IBOutlet var blockView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let myBMSClient = BMSClient.sharedInstance
        
        myBMSClient.initializeWithBluemixAppRoute(appDelegate.appRoute, bluemixAppGUID: appDelegate.appId, bluemixRegion: appDelegate.appRegion)
        myBMSClient.defaultRequestTimeout = 10.0 // seconds
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(subscriptionViewController.handleTap))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(subscriptionViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(subscriptionViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(subscriptionViewController.registerForPush(_:)), name:"RegisterdPush", object: nil);
          NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(subscriptionViewController.pushMessage(_:)), name:"pushMessage", object: nil);
        
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func pushMessage(notification: NSNotification){
        
        PopupController
            .create(self)
            .show(MessageViewController.instance())
        
        
    }
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        
        if tagsView.isFirstResponder() {
            self.view.frame.origin.y = 0
        } else if(regTagsView.isFirstResponder()){
            self.view.frame.origin.y = -150
        } else if (unRegTagsView.isFirstResponder()){
            self.view.frame.origin.y = -(keyboardHeight)
        }
        
        isKeyBoardUp = true
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        isKeyBoardUp = false;
    }
    
    func handleTap() {
        
        if isKeyBoardUp {
            
            self.tagsView.resignFirstResponder()
            self.regTagsView.resignFirstResponder()
            self.unRegTagsView.resignFirstResponder()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerForPush(notification: NSNotification){
        
        let deviceToken = notification.userInfo?["token"] as! NSData
        
        var devId = String()
        let authManager  = BMSClient.sharedInstance.authorizationManager
        devId = authManager.deviceIdentity.id!
        
        var token:String = deviceToken.description
        token = token.stringByReplacingOccurrencesOfString("<", withString: "")
        token = token.stringByReplacingOccurrencesOfString(">", withString: "")
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.symbolCharacterSet())
        
        print(token);
        print(devId);
        print(appDelegate.userid)
        
        push =  BMSPushClient.sharedInstance
        push.initializeWithPushAppGUID(appDelegate.pushAppGUID, clientSecret: appDelegate.clientSecret)
        
        push.registerWithDeviceToken(deviceToken, WithUserId:appDelegate.userid) { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during device registration : \(response)")
                
                print( "status code during device registration : \(statusCode)")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.blockView.hidden = true;
                    self.showAlert("Success !!", message: "SuccessFully Registered")
                    
                }
                
                
            }
            else{
                print( "Error during device registration \(error) ")
                self.showAlert("Error", message: "Error during device registration")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.blockView.hidden = true;
                    self.performSegueWithIdentifier("backregister", sender: nil)
                }
            }
        }
    }
    
    
    @IBAction func unRegisterPush () {
        
        // MARK:  RETRIEVING AVAILABLE SUBSCRIPTIONS
        
        self.blockView.hidden = false;
        
        push =  BMSPushClient.sharedInstance
        
        
        // MARK:  UNSREGISTER DEVICE
        self.push.unregisterDevice({ (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during unregistering device : \(response)")
                
                print( "status code during unregistering device : \(statusCode)")
                
                
                
                UIApplication.sharedApplication().unregisterForRemoteNotifications()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.blockView.hidden = true;
                    self.showAlert("Success !!", message: "SuccessFully UnRegistered")
                    self.performSegueWithIdentifier("logout", sender: nil)
                }
                
            }
            else{
                print( "Error during unregistering device \(error) ")
                dispatch_async(dispatch_get_main_queue()) {
                    self.blockView.hidden = true;
                    self.showAlert("Error", message: "Error during unregistering device")
                    
                }
                
            }
        })
        
    }
    
    
    @IBAction func retrieveTags() {
        // MARK:    RETRIEVING AVAILABLE TAGS
        
        
        dispatch_async(dispatch_get_main_queue()) {
            self.blockView.hidden = false;
        }
        push.retrieveAvailableTagsWithCompletionHandler({ (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during retrive tags : \(response)")
                
                print( "status code during retrieve tags : \(statusCode)")
                
                let arr:NSMutableArray = response!;
                dispatch_async(dispatch_get_main_queue(), {
                    self.tagsView.text = arr.componentsJoinedByString(",");
                    self.blockView.hidden = true;
                    self.showAlert("Success !!", message: "SuccessFully Retriedved tags")
                    
                })
                
            }
            else {
                print( "Error during retrieve tags \(error) ")
                dispatch_async(dispatch_get_main_queue()) {
                    self.blockView.hidden = true;
                    self.showAlert("Error", message: "Error during retrieve tags")
                    
                }
            }
            
            
        })
    }
    
    @IBAction func registerForTags() {
        
        // MARK:    SUBSCRIBING TO AVAILABLE TAGS
        
        
        
        self.blockView.hidden = false;
        let tagArray = regTagsView.text.componentsSeparatedByString(",")
        
        push.subscribeToTags(tagArray, completionHandler: { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during Subscribing to tags : \(response?.description)")
                
                print( "status code during Subscribing tags : \(statusCode)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.blockView.hidden = true;
                    self.regTagsView.text = ""
                    self.showAlert("Success !!", message: "SuccessFully Regsitered for tag/tags")
                    
                })
                
            }
            else {
                
                print( "Error during subscribing tags \(error) ")
                dispatch_async(dispatch_get_main_queue()) {
                    self.blockView.hidden = true;
                    self.showAlert("Error", message: "Error during subscribing tags")
                    
                }
            }
            
        })
    }
    
    @IBAction func unSubscribe (){
        
        // MARK:  UNSUBSCRIBING TO TAGS
        
        
        self.blockView.hidden = false;
        
        let tagArray = unRegTagsView.text.componentsSeparatedByString(",")
        
        self.push.unsubscribeFromTags(tagArray, completionHandler: { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during unsubscribed tags : \(response?.description)")
                
                print( "status code during unsubscribed tags : \(statusCode)")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.blockView.hidden = true;
                    self.unRegTagsView.text = "";
                    self.showAlert("Success !!", message: "SuccessFully Unsubscribed from tag/tags")
                    
                }
            }
            else {
                print( "Error during  unsubscribed tags \(error) ")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.blockView.hidden = true;
                    self.showAlert("Error", message: "Error during  unsubscribed tags")
                }
                
            }
        })
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            textView .resignFirstResponder();
            return false;
        }
        return true
    }
    
    func showAlert (title:NSString , message:NSString){
        
        // create the alert
        let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
