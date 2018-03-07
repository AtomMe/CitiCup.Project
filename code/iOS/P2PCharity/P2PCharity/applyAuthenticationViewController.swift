//
//  applyAuthenticationViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/16.
//  Copyright © 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SwiftyJSON

class applyAuthenticationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var deleteIDPhone1: UIButton!
    @IBOutlet var deleteIDPhone2: UIButton!
    
    @IBOutlet var applyIndicator: UIActivityIndicatorView!
    @IBOutlet var idPhoto2: UIImageView!
    @IBOutlet var idPhoto1: UIImageView!

    @IBOutlet var addIDPhone1: UIButton!
    @IBOutlet var addIDPhone2: UIButton!
    @IBOutlet var realNameField: UITextField!
    @IBOutlet var realUserIDField: UITextField!
    @IBOutlet var phoneNumField: UITextField!
    
    @IBOutlet var applyBarItem: UIBarButtonItem!
    var flag = true
    
    var username : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let swipeGestureRecong = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRecong:")
        self.view.addGestureRecognizer(swipeGestureRecong)
        swipeGestureRecong.direction = UISwipeGestureRecognizerDirection.Down
        
        self.applyBarItem.enabled = false
        
        applyIndicator.stopAnimating()
        
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
    @IBAction func realName_DidEndOnExit(sender: AnyObject) {
        self.realUserIDField.becomeFirstResponder()
    }
    @IBAction func realIDDidEndOnExit(sender: AnyObject) {
        self.phoneNumField.becomeFirstResponder()
    }
    @IBAction func phoneNumDidEndOnExit(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    @IBAction func apply(sender: AnyObject) {
        
        self.view.alpha = 0.7
        self.applyIndicator.startAnimating()
        
        var str1 : String?
        var str2 : String?
        
        
        let url1 = saveImage(idPhoto1.image!, imageName: getCurrentUsername() + "_" + getCurrentTimeString() + "_idPhoto1.jpg")
        let url2 = saveImage(idPhoto2.image!, imageName: getCurrentUsername() + "_" + getCurrentTimeString() + "_idPhoto2.jpeg")
        
        
        Alamofire.upload(.POST, "http://123.56.91.235/Charity4Client/SaveIDPhoto.php", headers: nil, file: url1)
        .responseJSON { _, _, jsonResult, _ in
            if (jsonResult != nil) {
                str1 = self.getPhotoAddress(jsonResult as! NSDictionary)
                print(str1)
                
                Alamofire.upload(.POST, "http://123.56.91.235/Charity4Client/SaveIDPhoto.php", headers: nil, file: url2)
                    .responseJSON { _, _, jsonResult2, _ in
                        if (jsonResult2 != nil) {
                            str2 = self.getPhotoAddress(jsonResult2 as! NSDictionary)
                            print(str2)
                            
                            self.commitApply(str1!, idPhoto2Str: str2!)
                            
                        }
                }
                
            }
        }
        
    }
    
    func commitApply(idPhoto1Str : String, idPhoto2Str : String) {
        let paras = [
            "username" : self.username!,
            "realName" : self.realNameField.text,
            "realID" : self.realUserIDField.text,
            "phoneNum" : self.phoneNumField.text,
            "idPhoto1" : idPhoto1Str,
            "idPhoto2" : idPhoto2Str,
        ]
        
        Alamofire.request(Alamofire.Method.GET, "http://123.56.91.235/Charity4Client/HandleAuthentication.php", parameters: paras)
            .responseJSON { _, _, jsonResult, _ in
                
                print(jsonResult)
                
                if (jsonResult != nil) {
                    self.handleJsonResult(jsonResult as! NSDictionary)
                }
                
        }
        
    }
    
    func handleJsonResult(jsonResult : NSDictionary) {
        // 解析JSON
        var json = JSON(jsonResult)
        
        let responseCode = json["code"].intValue
        let responseInfo = json["info"].intValue
        
        if responseCode == 200 && responseInfo == 1 {
            // 申请成功 更新用户信息
            
            let paras = [
                "username" : self.username!
            ]
            
            Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/SuccessApplyAuthentication.php", parameters: paras)
            .responseJSON { _, _, jsonResult2, _ in
             
                var json2 = JSON(jsonResult2!)
                
                let responseCode2 = json["code"].intValue
                let responseInfo2 = json["info"].intValue
                let time = json["data"].stringValue
                
                if responseCode2 == 200 && responseInfo2 == 1 {
                    // 更新本地的用户信息
                    self.updateLocalUserAuthenlicationInfo()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                
            }
        }
    }
    
    func updateLocalUserAuthenlicationInfo() {
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            
            print("数据库不为空")
            
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            // let nick = obj.valueForKey("nick") as! String
            
            obj.setValue(true, forKey: "authenticationRequest")
            
            var error : NSError?
            if context!.save(&error) {
                // 保存成功
                print("\n本地信息更新成功")
            }
            
            
        } else {
            print("数据库为空")

        }
        

    }
    
    func getPhotoAddress (jsonResult : NSDictionary) -> String {
        var address : String?
        // 解析JSON
        var json = JSON(jsonResult)
        address = "http://123.56.91.235/Charity4Client/" + json["data"].stringValue
        
        return address!
    }
    
    func getCurrentTimeString() -> String {
        var date : NSDate = NSDate()
        var formatter : NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        var dateString = formatter.stringFromDate(date)
        
        return dateString
    }

    @IBAction func addPhoto1(sender: AnyObject) {
        
        flag = true
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func addPhoto2(sender: AnyObject) {
        flag = false
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func deletePhoto1(sender: AnyObject) {
        self.idPhoto1.image = nil
        self.deleteIDPhone1.hidden = true
        if isApplyEnable() {
            self.applyBarItem.enabled = true
        } else {
            self.applyBarItem.enabled = false
        }
    }
    @IBAction func deletePhoto2(sender: AnyObject) {
        self.idPhoto2.image = nil
        self.deleteIDPhone2.hidden = true
        if isApplyEnable() {
            self.applyBarItem.enabled = true
        } else {
            self.applyBarItem.enabled = false
        }
    }
    
    
    func handleSwipeGestureRecong(sender : UISwipeGestureRecognizer) {
        
        realUserIDField.resignFirstResponder()
        realNameField.resignFirstResponder()
        phoneNumField.resignFirstResponder()
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        if flag {
            self.idPhoto1.image = image
            self.deleteIDPhone1.hidden = false
        } else {
            self.idPhoto2.image = image
            self.deleteIDPhone2.hidden = false
        }
        
        if isApplyEnable() {
            self.applyBarItem.enabled = true
        } else {
            self.applyBarItem.enabled = false
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImage(currentImage : UIImage, imageName : NSString) -> NSURL {
        var imageData : NSData = UIImageJPEGRepresentation(currentImage, 0.5)
        var fullPath : String = NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent(imageName as String)
        imageData.writeToFile(fullPath as String, atomically: false)
        var fileURL = NSURL(fileURLWithPath : fullPath)
        //开始上传操作
        
        return fileURL!
        
    }
    
    func getCurrentUsername() -> String {
        
        var userName : String?
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            
            print("数据库不为空")
            
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            
            userName = obj.valueForKey("username") as? String
            
        }
        
        return userName!
    }
    
    @IBAction func editChanged(sender: AnyObject) {
        if isApplyEnable() {
            self.applyBarItem.enabled = true
        } else {
            self.applyBarItem.enabled = false
        }
    }
    
    func isApplyEnable() -> Bool {
        if realNameField.hasText() && realUserIDField.hasText() && phoneNumField.hasText() && (idPhoto1.image != nil) && (idPhoto2.image != nil) {
            return true
        }
        
        return false
    }
    
}
