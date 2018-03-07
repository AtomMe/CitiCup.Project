//
//  DonationInfoViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/2.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit

class DonationInfoViewController: UIViewController {

    @IBOutlet var donationBtn: UIButton!
    @IBOutlet var donationMoneyField: UITextField!
    @IBOutlet var donationMoneySegmentedControl: UISegmentedControl!
    @IBOutlet var donationPersonPhoneNum: UITextField!
    @IBOutlet var donationMsgTip: UITextView!
    @IBOutlet var projectTitle: UILabel!
    @IBOutlet var donationPersonName: UITextField!
    
    var projectTitleStr : String!
    var projectId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let swipeGestureRecong = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRecong:")
        self.view.addGestureRecognizer(swipeGestureRecong)
        swipeGestureRecong.direction = UISwipeGestureRecognizerDirection.Down
        
        self.donationBtn.enabled = false
        
        self.projectTitle.text = projectTitleStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipeGestureRecong(sender : UISwipeGestureRecognizer) {
        
        self.donationPersonName.resignFirstResponder()
        self.donationPersonPhoneNum.resignFirstResponder()
        self.donationMoneyField.resignFirstResponder()
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let payController = segue.destinationViewController as! SelectPayMethodViewController
        payController.projectId = self.projectId
        payController.projectTitleStr = self.projectTitleStr
        payController.donationPersonName = self.donationPersonName.text
        payController.donationPersonPhone = self.donationPersonPhoneNum.text
        if self.donationMoneyField.hasText() {
            payController.donationMoney = (self.donationMoneyField.text as NSString).floatValue
        } else {
            switch self.donationMoneySegmentedControl.selectedSegmentIndex {
            case 0:
                payController.donationMoney = 1
            case 1:
                payController.donationMoney = 5
            case 2:
                payController.donationMoney = 10
            default:
                payController.donationMoney = 10
            }
        }
        
    }
    
    @IBAction func nameNext(sender: AnyObject) {
        self.donationPersonPhoneNum.becomeFirstResponder()
    }
    @IBAction func phoneNext(sender: AnyObject) {
        self.donationMoneyField.becomeFirstResponder()
    }
    @IBAction func EndEdit(sender: AnyObject) {
        self.donationPersonName.resignFirstResponder()
        self.donationPersonPhoneNum.resignFirstResponder()
        self.donationMoneyField.resignFirstResponder()
    }

    @IBAction func applyDonation(sender: AnyObject) {
        
    }
    @IBAction func donationName_EditChanged(sender: AnyObject) {
        if self.donationPersonName.hasText() && self.donationPersonPhoneNum.hasText() {
            self.donationBtn.enabled = true
        } else {
            self.donationBtn.enabled = false
        }
    }

    @IBAction func donationPhone_EditChanged(sender: AnyObject) {
        if self.donationPersonName.hasText() && self.donationPersonPhoneNum.hasText() {
            self.donationBtn.enabled = true
        } else {
            self.donationBtn.enabled = false
        }
    }
}
