//
//  LaunchProjectViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/26.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit

class LaunchProjectViewController: UIViewController, IGLDropDownMenuDelegate, UITextViewDelegate {
    @IBOutlet var nextBarItem: UIBarButtonItem!
    
    @IBOutlet var applicationReason: UITextView!
    @IBOutlet var applicationMoney: UITextField!
    
    var dropDownMenu : IGLDropDownMenu = IGLDropDownMenu()
    
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.nextBarItem.enabled = false
        
        let dataArray = [
            [
                "image" : "sun.png",
                "title" : "支教助学"
            ],
            [
                "image" : "clouds.png",
                "title" : "儿童成长"
            ],
            [
                "image" : "snow.png",
                "title" : "医疗救助"
            ],
            [
                "image" : "rain.png",
                "title" : "动物保护"
            ],
            [
                "image" : "windy.png",
                "title" : "环境保护"
            ]
        ]
        
        var dropdownItems = NSMutableArray()
        
        for index in 0..<dataArray.count {
            let dic : Dictionary = dataArray[index]
            
            let item = IGLDropDownItem()
           //  item.iconImage = UIImage(named: dic["image"]!)
            item.text = dic["title"]
            
            dropdownItems.addObject(item)
            
        }
        
        self.dropDownMenu.menuText = "选择项目类别"
        self.dropDownMenu.dropDownItems = dropdownItems as [AnyObject]
        self.dropDownMenu.paddingLeft = 15
        
        let rect = self.applicationMoney.frame;
        self.dropDownMenu.frame = CGRectMake(rect.origin.x, rect.origin.y + 85, 180, 50)
        self.dropDownMenu.delegate = self
        
        self.setUpParamsForDemo()
        self.dropDownMenu.reloadView()
        self.view.addSubview(self.dropDownMenu)
        
        let swipeGestureRecong = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRecong:")
        self.view.addGestureRecognizer(swipeGestureRecong)
        swipeGestureRecong.direction = UISwipeGestureRecognizerDirection.Down
        
        self.applicationReason.delegate = self
        
    }
    
    func handleSwipeGestureRecong(sender : UISwipeGestureRecognizer) {
        
        self.applicationMoney.resignFirstResponder()
        self.applicationReason.resignFirstResponder()
        
        if flag {
            UIView.animateWithDuration(0.3, animations: { self.view.frame.origin.y += 100 })
            flag = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedItemAtIndex(index: Int) {
        // print(index)
        if self.applicationMoney.hasText() && self.applicationReason.hasText() && (self.dropDownMenu.selectedIndex >= 0 && self.dropDownMenu.selectedIndex <= 5) {
            self.nextBarItem.enabled = true
        } else {
            self.nextBarItem.enabled = false
        }
    }
    
    @IBAction func editEnd(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        print("Begin")
        flag = true
        UIView.animateWithDuration(0.3, animations: { self.view.frame.origin.y -= 100 })
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        flag = false
        UIView.animateWithDuration(0.3, animations: { self.view.frame.origin.y += 100 })
        return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destController = segue.destinationViewController as! LauncherBasicInfoViewController
        destController.projectMoney = self.applicationMoney.text.toInt()
        destController.projectType = self.dropDownMenu.selectedIndex
        destController.projectReason = self.applicationReason.text
        
    }
    
    
    func setUpParamsForDemo() {
        self.dropDownMenu.type = IGLDropDownMenuType.Stack
        self.dropDownMenu.flipWhenToggleView = true
    }

    @IBAction func applicationMoneyChanged(sender: AnyObject) {
        if self.applicationMoney.hasText() && self.applicationReason.hasText() && (self.dropDownMenu.selectedIndex >= 0 && self.dropDownMenu.selectedIndex <= 5) {
            self.nextBarItem.enabled = true
        } else {
            self.nextBarItem.enabled = false
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if self.applicationMoney.hasText() && self.applicationReason.hasText() && (self.dropDownMenu.selectedIndex >= 0 && self.dropDownMenu.selectedIndex <= 5) {
            self.nextBarItem.enabled = true
        } else {
            self.nextBarItem.enabled = false
        }
    }
}
