//
//  EditNickViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/9.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class EditNickViewController: UIViewController {
    
    @IBOutlet var failTips: UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var saveBarItem: UIBarButtonItem!
    var nick : String!
    var userId : Int!

    @IBOutlet var newNickField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.newNickField.text = self.nick
        
        let swipeGestureRecong = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRecong:")
        self.view.addGestureRecognizer(swipeGestureRecong)
        swipeGestureRecong.direction = UISwipeGestureRecognizerDirection.Down
        
        self.indicator.stopAnimating()
        
        self.newNickField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func save(sender: AnyObject) {
        if self.newNickField.text != self.nick {
            
            if count(self.newNickField.text) > 10 {
                let alert = UIAlertView()
                alert.title = "警告"
                alert.message = "昵称不得超过10个字符"
                alert.addButtonWithTitle("确定")
                alert.show()
            } else {
                
                self.indicator.startAnimating()
                self.view.alpha = 0.7
                
                let paras = [
                    "nick" : self.newNickField.text,
                    "userId" : self.userId
                ]
                
                Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/UpdateNick.php", parameters: paras as? [String : AnyObject])
                .responseJSON { _, _, jsonResult, _ in
                 
                    print(jsonResult)
                    if (jsonResult != nil) {
                        var json = JSON(jsonResult!)
                        
                        let responseCode = json["code"].intValue
                        let responseInfo = json["info"].intValue
                        
                        if responseCode == 200 && responseInfo == 1 {
                            // 修改成功
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                    } else {
                        self.view.alpha = 1
                        self.indicator.stopAnimating()
                        
                        self.failTips.hidden = false
                        
                        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideFailMsg:", userInfo: nil, repeats: false)
                        
                    }
                    
                }
                
            }
            
        } else {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func hideFailMsg(sender : AnyObject) {
        self.failTips.hidden = true
    }
    
    func handleSwipeGestureRecong(sender : UISwipeGestureRecognizer) {
        
        self.newNickField.resignFirstResponder()
        
    }

    @IBAction func edit_changed(sender: AnyObject) {
        if self.newNickField.hasText() {
            self.saveBarItem.enabled = true
        } else {
            self.saveBarItem.enabled = false
        }
    }
}
