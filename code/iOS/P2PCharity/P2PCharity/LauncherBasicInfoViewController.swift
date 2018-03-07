//
//  LauncherBasicInfoViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/26.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit

class LauncherBasicInfoViewController: UIViewController {
    @IBOutlet var nextBarItem: UIBarButtonItem!

    @IBOutlet var forHelperName: UITextField!
    @IBOutlet var forHelperRealID: UITextField!
    @IBOutlet var forHelperPhoneNum: UITextField!
    @IBOutlet var forHelperAddress: UITextField!
    @IBOutlet var enmergencyPersonName: UITextField!
    @IBOutlet var enmergencyPersonPhoneNum: UITextField!
    
    var projectMoney : Int!
    var projectType : Int!
    var projectReason : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.nextBarItem.enabled = false
        
        let swipeGestureRecong = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRecong:")
        self.view.addGestureRecognizer(swipeGestureRecong)
        swipeGestureRecong.direction = UISwipeGestureRecognizerDirection.Down
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destController = segue.destinationViewController as! LaunchThirdViewController
        destController.projectMoney = self.projectMoney
        destController.projectType = self.projectType
        destController.projectReason = self.projectReason
        
        destController.appealName = self.forHelperName.text
        destController.appealID = self.forHelperRealID.text
        destController.appealPhone = self.forHelperPhoneNum.text
        destController.appealAddress = self.forHelperAddress.text
        destController.appealEnmergencyName = self.enmergencyPersonName.text
        destController.appealEnmergencyPhone = self.enmergencyPersonPhoneNum.text
        
    }

    @IBAction func forHelperName_DidEndOnExit(sender: AnyObject) {
        self.forHelperRealID.becomeFirstResponder()
    }
    
    @IBAction func forHelperRealID_DidEndOnExit(sender: AnyObject) {
        self.forHelperPhoneNum.becomeFirstResponder()
    }
    @IBAction func forHelperPhoneNum_DidEndOnExit(sender: AnyObject) {
        self.forHelperAddress.becomeFirstResponder()
    }
    @IBAction func forHelperAddress_DidEndOnExit(sender: AnyObject) {
        self.enmergencyPersonName.becomeFirstResponder()
    }
    @IBAction func enmergencyPersonName_DidEndOnExit(sender: AnyObject) {
        self.enmergencyPersonPhoneNum.becomeFirstResponder()
    }
    @IBAction func enmergencyPersonPhoneNum_DidEndOnExit(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    @IBAction func textChanged(sender: AnyObject) {
        if forHelperName.hasText() && self.forHelperRealID.hasText() && self.forHelperPhoneNum.hasText() && self.forHelperAddress.hasText() && enmergencyPersonName.hasText() && enmergencyPersonPhoneNum.hasText() {
            self.nextBarItem.enabled = true
        } else {
            self.nextBarItem.enabled = false
        }
    }
    @IBAction func beginEdit(sender: AnyObject) {
    }
    
    func handleSwipeGestureRecong(sender : UISwipeGestureRecognizer) {
        
        self.forHelperName.resignFirstResponder()
        self.forHelperRealID.resignFirstResponder()
        self.forHelperPhoneNum.resignFirstResponder()
        self.forHelperAddress.resignFirstResponder()
        self.enmergencyPersonPhoneNum.resignFirstResponder()
        self.enmergencyPersonName.resignFirstResponder()
        
    }
}
