//
//  MyRecordViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/3.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit

class MyRecordViewController: UIViewController, UIScrollViewDelegate {
    
    var selectedBtn : UIButton!
    
    var scrollView : UIScrollView!
    
    let KScreenHeight = UIScreen.mainScreen().bounds.size.height
    let KScreenWidth = UIScreen.mainScreen().bounds.size.width

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nameArray = ["捐款", "求助", "提款"]
        
        let backgroundView = UIImageView(frame: CGRectMake(0, 0, KScreenWidth, 40))
        backgroundView.image = UIImage(named: "table-mid.png")
        self.view.addSubview(backgroundView)
        
        for index in 0...(nameArray.count - 1) {
            
            var btn = UIButton(frame: CGRectMake(CGFloat(0 + index*(Int(KScreenWidth)/(nameArray.count))), 0, CGFloat(Int(KScreenWidth)/(nameArray.count)), CGFloat(40)))
            
            btn.setTitle(nameArray[index], forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
            
            btn.setBackgroundImage(UIImage(named: "red_line_and_shadow.png"), forState: UIControlState.Selected)
            
            btn.tag = 200 + index
            
            if index == 0 {
                btn.selected = true
                self.selectedBtn = btn
            }
            
            btn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(btn)
            
        }
        
        scrollView = UIScrollView(frame: CGRectMake(0, 40, KScreenWidth, KScreenHeight - 40))
        scrollView.contentSize = CGSizeMake(CGFloat(Int(KScreenWidth) * nameArray.count), KScreenHeight - 40)
        
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        self.view.addSubview(scrollView)
        
        let donationRecordController = DonationRecordViewController(nibName: "DonationRecordViewController", bundle: nil)
        
        donationRecordController.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 40)
        // nearsController.projectTableView.bounds = CGRectMake(0, 0, 320, 300)
        
        let applyProjectRecordController = ApplyProjectRecordViewController(nibName: "ApplyProjectRecordViewController", bundle: nil)
        applyProjectRecordController.view.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight - 40)
        
        let applyMoneyRecordController = ApplyMoneyRecordViewController(nibName: "ApplyMoneyRecordViewController", bundle: nil)
        applyMoneyRecordController.view.frame = CGRectMake(KScreenWidth * 2, 0, KScreenWidth, KScreenHeight - 40)
        
        self.addChildViewController(donationRecordController)
        self.addChildViewController(applyProjectRecordController)
        self.addChildViewController(applyMoneyRecordController)
        
        scrollView.addSubview(donationRecordController.view)
        scrollView.addSubview(applyProjectRecordController.view)
        scrollView.addSubview(applyMoneyRecordController.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ApplyForMoneyAction:", name: "Notification_Apply_Money", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let tag = scrollView.contentOffset.x / KScreenWidth
        let btn = self.view.viewWithTag( Int(200 + tag) ) as! UIButton
        
        self.btnAction(btn)
        
    }
    
    func btnAction (sender: AnyObject) {
        if (self.selectedBtn != nil) {
            self.selectedBtn.selected = false
        }
        
        (sender as! UIButton).selected = true
        self.selectedBtn = sender as! UIButton
        
        scrollView.contentOffset = CGPointMake(CGFloat((sender.tag - 200) * Int(KScreenWidth)), CGFloat(0))
        
        
    }
    
    func ApplyForMoneyAction(aNotification : NSNotification) {
        let info = aNotification.userInfo as! [String : AnyObject]
        
        let project = info["project"] as! Project
        
        let applyForMoneyController: ApplyForMoneyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("applyForMoney") as! ApplyForMoneyViewController
        
        applyForMoneyController.project = project
        
        self.navigationController?.pushViewController(applyForMoneyController, animated: true)
        
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
