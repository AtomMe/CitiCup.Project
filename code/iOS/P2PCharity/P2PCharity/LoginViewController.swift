//
//  LoginViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/15.
//  Copyright © 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var loginFailedMsg: UILabel!
    
    var keyboardOpen : Bool = false
    
    var height : Int = 0

    @IBOutlet var loginIndicator: UIActivityIndicatorView!
    @IBOutlet var loginBg2: UIImageView!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loginBtn.userInteractionEnabled = false
        self.loginBtn.alpha = 0.4
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        let swipeGestureRecong = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRecong:")
        self.view.addGestureRecognizer(swipeGestureRecong)
        swipeGestureRecong.direction = UISwipeGestureRecognizerDirection.Down
        
        loginIndicator.stopAnimating()
        
        loginFailedMsg.hidden = true
        loginFailedMsg.textAlignment = NSTextAlignment.Center
        
        // 监听键盘事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        
    }
    
    func keyboardWillShow(aNotification : NSNotification) {
        let userInfo:NSDictionary = aNotification.userInfo!;
        let keyBoardInfo: AnyObject? = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey);
        let keyboardRect = keyBoardInfo?.CGRectValue()
        self.height = Int(keyboardRect!.size.height)
        
        print(self.height)
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
    
    
    @IBAction func passwordEditChanged(sender: AnyObject) {
        if self.usernameField.hasText() && self.passwordField.hasText() {
            self.loginBtn.userInteractionEnabled = true
            self.loginBtn.alpha = 1.0
        } else {
            self.loginBtn.userInteractionEnabled = false
            self.loginBtn.alpha = 0.4
        }
    }
    
    @IBAction func usernameEditChanged(sender: AnyObject) {
        if self.usernameField.hasText() && self.passwordField.hasText() {
            self.loginBtn.userInteractionEnabled = true
            self.loginBtn.alpha = 1.0
        } else {
            self.loginBtn.userInteractionEnabled = false
            self.loginBtn.alpha = 0.4
        }
    }

    @IBAction func login(sender: AnyObject) {
        
        // 登录效果
        self.view.alpha = 0.7
        loginIndicator.startAnimating()
        
        
        // 发送请求
        
        let parameters = [
            "username": usernameField.text,
            "password": passwordField.text
        ]
        
        Alamofire.request(Alamofire.Method.GET, "http://123.56.91.235/Charity4Client/login.php", parameters: parameters)
        .responseJSON { _, _, jsonResult, _ in
            
            // 网络连接出错
            if jsonResult == nil {
                self.handleRegisterResult(-201, responseInfo: 3, userInfo : nil)
            } else {
                // 解析JSON
                
                print(jsonResult)
                
                var json = JSON(jsonResult!)
                
                let responseCode = json["code"].intValue
                let responseInfo = json["info"].intValue
                
                println(responseCode)
                println(responseInfo)
                
                self.handleRegisterResult(responseCode, responseInfo: responseInfo, userInfo : json)
                
            }
            
            
        }
        
    }
    
    func handleRegisterResult(responseCode : Int, responseInfo : Int, userInfo : JSON) {
        
        self.view.alpha = 1
        self.loginIndicator.stopAnimating()
        
        if responseCode == 200 && responseInfo == 2 {
            // registerFailMsg.text = "登录成功"
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            saveUserDataToLocalDataBase(userInfo)
            
        } else {
            
            // 用户名不存在
            if responseInfo == 1 {
                loginFailedMsg.text = "用户名不存在"
            } else if responseInfo == 4 {
                loginFailedMsg.text = "密码错误"
            } else {
                loginFailedMsg.text = "登录失败，请检查网络设置"
            }
        }
        loginFailedMsg.hidden = false
        UIView.animateWithDuration(1, animations: { self.loginFailedMsg.frame.origin.y += 100 })
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideFailMsg:", userInfo: nil, repeats: false)
        
    }
    
    func hideFailMsg(sender : AnyObject) {
        
        self.loginFailedMsg.hidden = true
        
        UIView.animateWithDuration(1, animations: { self.loginFailedMsg.frame.origin.y -= 100 })
        
        
    }

    @IBAction func Email_next(sender: AnyObject) {
        self.passwordField.becomeFirstResponder()
    }
    
    @IBAction func doneEdit(sender: AnyObject) {
        sender.resignFirstResponder()
        //UIView.animateWithDuration(0.3, animations: { self.view.frame.origin.y += 100 })
        if self.usernameField.hasText() && self.passwordField.hasText() {
            self.login(sender)
        }
    }
    
    @IBAction func forgetPassword(sender: AnyObject) {
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //UIView.animateWithDuration(0.3, animations: { self.view.frame.origin.y -= 100 })
        keyboardOpen = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        keyboardOpen = false
    }
    
    func handleSwipeGestureRecong(sender : UISwipeGestureRecognizer) {
        
//        if keyboardOpen {
//            UIView.animateWithDuration(0.3, animations: { self.view.frame.origin.y += 100 })
//        }
        
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
    }
    
    func saveUserDataToLocalDataBase(userInfo : JSON) {
        // 将用户信息存到本地数据库
        if (userInfo != nil) {
            
            deleteLocalData()
            
            
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //获取appdel
            var context = appDelegate.managedObjectContext //获取存储的上下文
            
            var entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context!)
            var user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)// 这里如果做了转型的话其实也可以直接类似类的属性进行赋值一样
            
            user.setValue(userInfo["data"]["id"].intValue, forKey: "id")
            
            user.setValue(userInfo["data"]["isActive"].boolValue, forKey: "isActive")
            user.setValue(userInfo["data"]["isAuthentication"].boolValue, forKey: "isAuthentication")
            user.setValue(userInfo["data"]["nick"].stringValue, forKey: "nick")
            user.setValue(userInfo["data"]["password"].stringValue, forKey: "password")
            user.setValue(userInfo["data"]["username"].stringValue, forKey: "username")
            user.setValue(userInfo["data"]["realName"].stringValue, forKey: "realName")
            
            user.setValue(userInfo["data"]["realID"].stringValue, forKey: "realID")
            user.setValue(userInfo["data"]["phoneNum"].stringValue, forKey: "phoneNum")
            user.setValue(userInfo["data"]["authenticationRequest"].boolValue, forKey: "authenticationRequest")

            
            user.setValue(userInfo["data"]["authenticationFail"].boolValue, forKey: "authenticationFail")
            user.setValue(userInfo["data"]["authenticationFailMsg"].stringValue, forKey: "authenticationFailMsg")
            user.setValue(userInfo["data"]["avatar"].stringValue, forKey: "avatar")
            
            
            var error : NSError?
            if (appDelegate.managedObjectContext?.save(&error) != nil) {
                  
            }
        }
    }
    
    func deleteLocalData() {
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //获取appdel
        var context = appDelegate.managedObjectContext //获取存储的上下文
        
        let description = NSEntityDescription.entityForName("User", inManagedObjectContext: context!)
        
        let request = NSFetchRequest()
        
        request.includesPropertyValues = false
        request.entity = description
        
        var error : NSError?
        
        let data = context?.executeFetchRequest(request, error: &error)
        
        if let result = data {
            
            for obj in result {
                context?.deleteObject(obj as! NSManagedObject)
                
                if (context?.save(&error) != nil) {
                    
                }
            }
            
        }
    }
    
    
    // 控件抖动
    func lockAnimationForView(view : UIView) {
        let lbl = view.layer
        let posLbl = lbl.position
        let y = CGPointMake(posLbl.x - 10, posLbl.y)
        let x = CGPointMake(posLbl.x + 10, posLbl.y)
        
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        animation.fromValue = NSValue(CGPoint: x)
        animation.toValue = NSValue(CGPoint: y)
        animation.autoreverses = true
        animation.duration = 0.08
        animation.repeatCount = 3
        lbl.addAnimation(animation, forKey: nil)
        
    }
    
}
