//
//  MessageViewController.swift
//  userIdBasedSwift
//
//  Created by Anantha Krishnan K G on 25/07/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, PopupContentViewController {
    
    var closeHandler: (() -> Void)?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet var pushNotificationMessage: UILabel!
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.layer.borderColor = UIColor(red: 242/255, green: 105/255, blue: 100/255, alpha: 1.0).CGColor
            button.layer.borderWidth = 1.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSizeMake(250,200)
        pushNotificationMessage.text = appDelegate.message
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instance() -> MessageViewController {
        let storyboard = UIStoryboard(name: "DemoPopupViewController1", bundle: nil)
        return storyboard.instantiateInitialViewController() as! MessageViewController
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSizeMake(300,300)
    }
    
    @IBAction func didTapCloseButton(sender: AnyObject) {
        closeHandler?()
    }

}
