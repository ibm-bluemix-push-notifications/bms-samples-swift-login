//
//  popUpViewController.swift
//  userIdBasedSwift
//
//  Created by Anantha Krishnan K G on 21/07/16.
//  Copyright © 2016 Ananth. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController , PopupContentViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var region = [
        
        (".ng.bluemix.net" , UIColor.redColor()),
        (".au-syd.bluemix.net",UIColor.yellowColor()),
        (".eu-gb.bluemix.net",UIColor.blueColor()),
        (".stage1.ng.bluemix.net",UIColor.brownColor()),
        (".stage1.eu-gb.bluemix.net",UIColor.blackColor()),
        (".stage1-dev.ng.bluemix.net",UIColor.greenColor()),
        (".stage1-test.ng.bluemix.net",UIColor.lightGrayColor())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    class func instance() -> popUpViewController {
        let storyboard = UIStoryboard(name: "DemoPopupViewController2", bundle: nil)
        return storyboard.instantiateInitialViewController() as! popUpViewController

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSizeMake(300, 500)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return region.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! popUpCell
        let (text,color) = region[indexPath.row]
        cell.titleLabel.text = text
        cell.colorView.backgroundColor = color
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! popUpCell
        appDelegate.appRegion = cell.titleLabel.text!
       
    }
    
}

class popUpCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
}
