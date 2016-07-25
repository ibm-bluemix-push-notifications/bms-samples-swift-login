//
//  regsiterViewController.swift
//  userIdBasedSwift
//
//  Created by Anantha Krishnan K G on 20/07/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit

class regsiterViewController: UIViewController, UITextFieldDelegate,UIGestureRecognizerDelegate {

    @IBOutlet var approute: UITextField!
    @IBOutlet var appguid: UITextField!
    @IBOutlet var clientsecret: UITextField!
    @IBOutlet var pushAppGUID: UITextField!
    @IBOutlet var appRegion: UITextField!
    @IBOutlet var viewwww: UIView!
    var isKeyBoardUp = false;

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        let tap = UITapGestureRecognizer(target: self, action: "didTapButton2")
        tap.delegate = self
        viewwww.addGestureRecognizer(tap)
    }
    
    func handleTap1(sender: UITapGestureRecognizer)
    {
        NSLog("Touch..");
        //handling code
    }
    func pushMessage(notification: NSNotification){
        
        PopupController
            .create(self)
            .show(MessageViewController.instance())
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(regsiterViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(regsiterViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
          NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(regsiterViewController.pushMessage(_:)), name:"pushMessage", object: nil);
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @IBAction func registerForPush(sender: AnyObject) {
    
        
        if !(clientsecret.text?.isEmpty)! && !(appguid.text?.isEmpty)! && !(approute.text?.isEmpty)! && !(appRegion.text?.isEmpty)! {
            
            
            appDelegate.clientSecret = clientsecret.text!;
            appDelegate.appId = appguid.text!;
            appDelegate.appRoute = approute.text!;
            appDelegate.pushAppGUID = pushAppGUID.text!;
            
            self.performSegueWithIdentifier("subscribe", sender: nil)
            
        }  else{
            showAlert("Error!!", message: "Add all fiedls")
        }
    }
    
    func didTapButton2() {
        
        if isKeyBoardUp {
            
            self.clientsecret.resignFirstResponder()
            self.appguid.resignFirstResponder()
            self.approute.resignFirstResponder()
        }
        PopupController
            .create(self)
            .customize(
                [
                    .Animation(.SlideUp),
                    .Scrollable(false),
                    .BackgroundStyle(.BlackFilter(alpha: 0.7))
                ]
            )
            .didShowHandler { popup in
                print("showed popup!")
            }
            .didCloseHandler { _ in
                print("closed popup!")
                self.appRegion.text = self.appDelegate.appRegion
            }
            .show(popUpViewController.instance())
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField == clientsecret){
            approute.becomeFirstResponder()
        } else if (textField == approute){
            appRegion.becomeFirstResponder()
        } else if (textField == appRegion){
            appguid.becomeFirstResponder()
        }else if (textField == appguid){
            pushAppGUID.becomeFirstResponder()
        }
        else {
            pushAppGUID.resignFirstResponder()
        }
        return false
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if clientsecret.isFirstResponder() {
             self.view.frame.origin.y = -100
        } else if approute.isFirstResponder(){
             self.view.frame.origin.y = -150
        } else if appguid.isFirstResponder(){
             self.view.frame.origin.y = -190
        }else if pushAppGUID.isFirstResponder(){
            self.view.frame.origin.y = -200
        }
         isKeyBoardUp = true
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
         isKeyBoardUp = false
    }
    
    @IBAction func autoload(sender: AnyObject) {
        
        
        if let url = NSBundle.mainBundle().URLForResource("myConfig", withExtension: "json") {
            if let data = NSData(contentsOfURL: url) {
                do {
                    let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                    
                    approute.text = object.objectForKey("appRoute") as? String;
                    appguid.text = object.objectForKey("appId")as? String;
                    clientsecret.text = object.objectForKey("clientSecret")as? String;
                    pushAppGUID.text = object.objectForKey("pushAppId")as? String;
                    
                } catch {
                    print("Error!! Unable to parse myConfig.json")
                }
            }
            print("Error!! Unable to load  myConfig.json")
        }
        
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
