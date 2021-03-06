//
//  AppDelegate.swift
//  userIdBasedSwift
//
//  Created by Anantha Krishnan K G on 20/07/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userid = String();
    var clientSecret = String();
    var appId = String();
    var appRoute = String();
    var appRegion:String = ".ng.bluemix.net";
    var pushAppGUID = String();
    var message = String();

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("RegisterdPush", object: nil, userInfo: ["token":deviceToken])
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        let message:NSString = "Error registering for push notifications: "+error.description
        
        self.showAlert("Registering for notifications", message: message)
        
        
        
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        
        let payLoad = ((((userInfo as NSDictionary).valueForKey("aps") as! NSDictionary).valueForKey("alert") as! NSDictionary).valueForKey("body") as! NSString)
        message = payLoad as String;
        NSNotificationCenter.defaultCenter().postNotificationName("pushMessage", object: nil, userInfo: ["message":payLoad])
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        let payLoad = ((((userInfo as NSDictionary).valueForKey("aps") as! NSDictionary).valueForKey("alert") as! NSDictionary).valueForKey("body") as! NSString)
        
        print(payLoad);
        message = payLoad as String;
        
        NSNotificationCenter.defaultCenter().postNotificationName("pushMessage", object: nil, userInfo: ["message":payLoad])

             //  self.showAlert("Recieved Push notifications", message: payLoad)
        
    }
    
    func showAlert (title:NSString , message:NSString){
        
        // create the alert
        let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.window!.rootViewController!.presentViewController(alert, animated: true, completion: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

