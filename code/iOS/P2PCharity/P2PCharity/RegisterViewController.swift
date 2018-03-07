//
//  RegisterViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/16.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftyJSON
import CoreData


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    var keyboardOpen : Bool = false
    
    var flag = false
    
    var screenRect = UIScreen.mainScreen().bounds
    
    @IBOutlet var registerFailMsg: UILabel!
    @IBOutlet var registerIndicatorView: UIActivityIndicatorView!
    @IBOutlet var iconUsername: UIImageView!
    @IBOutlet var iconPassword: UIImageView!
    @IBOutlet var iconPasswordAgain: UIImageView!
    

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordAgainField: UITextField!
    @IBOutlet var registerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.registerBtn.userInteractionEnabled = false
        self.registerBtn.alpha = 0.4
        
        usernameField.delegate = self
        passwordField.delegate = self
        passwordAgainField.delegate = self
        
        let swipeGestureRecong = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRecong:")
        self.view.addGestureRecognizer(swipeGestureRecong)
        swipeGestureRecong.direction = UISwipeGestureRecognizerDirection.Down
        
        registerIndicatorView.stopAnimating()
        
        registerFailMsg.hidden = true
        registerFailMsg.textAlignment = NSTextAlignment.Center
        
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
        
        if self.usernameField.hasText() && self.passwordField.hasText() && self.passwordAgainField.hasText() {
            
            self.registerBtn.userInteractionEnabled = true
            self.registerBtn.alpha = 1.0
        } else {
            
            self.registerBtn.userInteractionEnabled = false
            self.registerBtn.alpha = 0.4
        }
        
    }

    @IBAction func usernameEditChanged(sender: AnyObject) {
        
        if self.usernameField.hasText() && self.passwordField.hasText() && self.passwordAgainField.hasText() {
            
            self.registerBtn.userInteractionEnabled = true
            self.registerBtn.alpha = 1.0
        } else {
            
            self.registerBtn.userInteractionEnabled = false
            self.registerBtn.alpha = 0.4
        }
        
    }
    
    @IBAction func passwordAgainEditChanged(sender: AnyObject) {
    
        if self.usernameField.hasText() && self.passwordField.hasText() && self.passwordAgainField.hasText() {
            
            self.registerBtn.userInteractionEnabled = true
            self.registerBtn.alpha = 1.0
        } else {
            
            self.registerBtn.userInteractionEnabled = false
            self.registerBtn.alpha = 0.4
        }
    
    }
    @IBAction func Email_next(sender: AnyObject) {
        self.passwordField.becomeFirstResponder()
    }
    
    @IBAction func Password_next(sender: AnyObject) {
        self.passwordAgainField.becomeFirstResponder()
    }
    @IBAction func doneEdit(sender: AnyObject) {
        
        sender.resignFirstResponder()
        if self.usernameField.hasText() && self.passwordField.hasText() && self.passwordAgainField.hasText() {
            self.register(sender)
        }
    }
    
    @IBAction func register(sender: AnyObject) {
        
        // 验证输入的邮箱是否合法
        
        let emailFlag = testRegx("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", matchString: usernameField.text)
        
        // println(emailFlag)
        
        if !emailFlag {
            lockAnimationForView(usernameField)
            lockAnimationForView(iconUsername)
            
            return
        }
        
        
        // 两次密码不一致
        if !(passwordField.text == passwordAgainField.text) {
            lockAnimationForView(passwordAgainField)
            lockAnimationForView(passwordField)
            
            lockAnimationForView(iconPassword)
            lockAnimationForView(iconPasswordAgain)
            
            return
        }
        
        self.view.alpha = 0.7
        
        registerIndicatorView.startAnimating()
        
        // 发送get请求
        
        let parameters = [
            "username": usernameField.text,
            "password": passwordField.text
        ]
        
        Alamofire.request(Alamofire.Method.GET, "http://123.56.91.235/Charity4Client/register.php", parameters: parameters)
            .responseJSON { _, _, jsonResult, _ in
                println(jsonResult)
                
                // 网络连接出错
                if jsonResult == nil {
                    self.handleRegisterResult(-201, responseInfo: 3, userInfo: nil)
                } else {
                    // 解析JSON
                    var json = JSON(jsonResult!)
                    
                    let responseCode = json["code"].intValue
                    let responseInfo = json["info"].intValue
                    
                    
                    println(responseCode)
                    println(responseInfo)
                    
                    self.handleRegisterResult(responseCode, responseInfo: responseInfo, userInfo: json)
                    
                }
                
        }
        
    }
    
    func handleRegisterResult(responseCode : Int, responseInfo : Int, userInfo : JSON) {
        
        self.view.alpha = 1
        self.registerIndicatorView.stopAnimating()
        
        // registerFailMsg.hidden = false
        
        if responseCode == 200 && responseInfo == 2 {
            // registerFailMsg.text = "注册成功"
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            saveUserDataToLocalDataBase(userInfo)
            
        } else {
            
            // 用户名已存在
            if responseInfo == 1 {
                registerFailMsg.text = "用户名已存在"
            } else {
                registerFailMsg.text = "注册失败，请检查网络设置"
            }
        }
        registerFailMsg.hidden = false
        UIView.animateWithDuration(1, animations: { self.registerFailMsg.frame.origin.y += 100 })
    
        let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideFailMsg:", userInfo: nil, repeats: false)
        // timer.fire()
        
        // registerFailMsg.hidden = false
        // lockAnimationForView(registerFailMsg)

    }
    
    func saveUserDataToLocalDataBase(userInfo : JSON) {
        // 将用户信息存到本地数据库
        if (userInfo != nil) {
            
            // 首先要清空数据库
            deleteLocalData()
            
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //获取appdel
            var context = appDelegate.managedObjectContext //获取存储的上下文
            
            var entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context!)
            var user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)// 这里如果做了转型的话其实也可以直接类似类的属性进行赋值一样
            
            user.setValue(userInfo["data"]["id"].intValue, forKey: "id")
            
            user.setValue(true, forKey: "isActive")
            user.setValue(false, forKey: "isAuthentication")
            user.setValue(userInfo["data"]["nick"].stringValue, forKey: "nick")
            user.setValue(userInfo["data"]["password"].stringValue, forKey: "password")
            user.setValue(userInfo["data"]["username"].stringValue, forKey: "username")
            user.setValue(false, forKey: "authenticationRequest")
            user.setValue(true, forKey: "authenticationFail")
            user.setValue(userInfo["data"]["nick"].stringValue, forKey: "authenticationFailMsg")
            user.setValue("http://123.56.91.235/Charity4Client/Avatar/icon-default-avatar.png", forKey: "avatar")
            
            
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
    
    func hideFailMsg(sender : AnyObject) {
        
        self.registerFailMsg.hidden = true
        
        UIView.animateWithDuration(1, animations: { self.registerFailMsg.frame.origin.y -= 100 })
        
        
    }

    
    func testRegx(pattern:String,matchString:String)->Bool{
        var error:NSError?
        let expression=NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)
        let matches = expression!.matchesInString(matchString, options: nil, range: NSMakeRange(0, count(matchString)))
        return matches.count > 0
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        keyboardOpen = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        keyboardOpen = false
    }
    
    func handleSwipeGestureRecong(sender : UISwipeGestureRecognizer) {
        
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        passwordAgainField.resignFirstResponder()
        
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
