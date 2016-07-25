//
//  ViewController.swift
//  userIdBasedSwift
//
//  Created by Anantha Krishnan K G on 20/07/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var userIdText: UITextField!
    @IBOutlet var passwordtext: UITextField!
    @IBOutlet var loginButton: UIButton!
      @IBOutlet var vieww: UIView!
     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdText.delegate = self;
        passwordtext.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    @IBAction func LoginAction(sender: AnyObject) {
        
        if (!(userIdText.text?.isEmpty)! && !(passwordtext.text?.isEmpty)!) {
            
            appDelegate.userid = userIdText.text!;
            self.performSegueWithIdentifier("register", sender: nil)
            
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField == userIdText){
            passwordtext.becomeFirstResponder()
        }
        else {
            passwordtext.resignFirstResponder()
        }
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -150
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

