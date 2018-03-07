//
//  ProfileViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/12.
//  Copyright © 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var profileTableView: UITableView!

    @IBOutlet var reconizedImageView: UIImageView!
    @IBOutlet var authenticationBtn: UIButton!
    @IBOutlet var loginOrLogoutBarItem: UIBarButtonItem!
    @IBOutlet var profileNick: UILabel!
    @IBOutlet var profileAvatar: UIImageView!
    
    var username : String?
    
    var userId : Int!
    
    var imagePicker : UIImagePickerController? = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        // 设置为圆形头像显示
        self.profileAvatar.layer.cornerRadius = CGRectGetHeight(self.profileAvatar.bounds) / 2
        self.profileAvatar.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: "avatarTaped:")
        self.profileAvatar.addGestureRecognizer(tap)
        
    }
    
    func avatarTaped(sender : AnyObject) {
        
        print("Taped")
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "我的相册")
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackOpaque
        actionSheet.showInView(self.view)
        actionSheet.delegate = self
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        // 点击了按钮
        //print("000")
        
        if buttonIndex == 1 {
            self.openCamera()
        } else if buttonIndex == 2 {
            self.openPics()
        }
    }
    
    // 打开相机
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            if (imagePicker == nil) {
                imagePicker = UIImagePickerController()
                
            }
            
            self.imagePicker!.delegate = self
            self.imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
            self.imagePicker!.showsCameraControls = true
            self.imagePicker!.allowsEditing = true
            
            self.navigationController?.presentViewController(imagePicker!, animated: true, completion: nil)
        }
    }
    
    // 打开相册
    func openPics() {
        
        // 打开相册
        // print("111")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            // 相册可以
            //print("222")
            
            if (imagePicker == nil) {
                imagePicker = UIImagePickerController()
                
            }
            
            self.imagePicker!.delegate = self
            self.imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imagePicker!.allowsEditing = true
            
            self.navigationController?.presentViewController(imagePicker!, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var mediaType = info[UIImagePickerControllerMediaType] as! String
        
        imagePicker!.dismissViewControllerAnimated(true, completion: nil)
        imagePicker = nil
        
        if mediaType == "public.image" {
            
            var theImage : UIImage?
            if picker.allowsEditing {
                print("允许编辑")
                theImage = info[UIImagePickerControllerEditedImage] as? UIImage
                
            } else {
                theImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            
            // 保存图片
            let fileUrl = self.saveImage(theImage!, imageName: self.getCurrentTimeString() + ".png")
            
            // 上传图片
            
            self.uploadNewAvatar(fileUrl)
            
        }
        
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
    }
    
    // 上传图片
    func uploadNewAvatar(fileUrl : NSURL) {
        Alamofire.upload(.POST, "http://123.56.91.235/Charity4Client/SaveIDPhoto.php", headers: nil, file: fileUrl)
            .responseJSON { _, _, jsonResult, _ in
                if (jsonResult != nil) {
                    let str1 = self.getPhotoAddress(jsonResult as! NSDictionary)
                    print(str1)
                    
                    let paras = [
                        "userId" : self.userId,
                        "avatar" : str1
                    ]
                    
                    Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/UpdateAvatar.php", parameters: paras as? [String : AnyObject])
                    .responseJSON { _, _, jsonResult2, _ in
                        
                        if (jsonResult2 != nil) {
                            var json = JSON(jsonResult!)
                            
                            let responseCode = json["code"].intValue
                            let responseInfo = json["info"].intValue
                            
                            if responseCode == 200 && responseInfo == 1 {
                                // 更新成功了
                                ImageLoader.sharedLoader.imageForUrl(str1, completionHandler: { (image, url) -> () in
                                    self.profileAvatar.image = image
                                })
                                
                                // 更新本地数据库信息
                                self.UpdateLocalDatabase(str1)
                            }
                        }
                        
                    }
                    
                    
                }
        }
    }
    
    
    func UpdateLocalDatabase(newAvatar : String) {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            obj.setValue(newAvatar, forKey: "avatar")
        }
    }
    
    // 改变图像的尺寸，方便上传服务器
    func scaleFromImage(image : UIImage, toSize : CGSize) -> UIImage{
        UIGraphicsBeginImageContext(toSize);
        image.drawInRect(CGRectMake(0, 0, toSize.width, toSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    func saveImage(currentImage : UIImage, imageName : NSString) -> NSURL {
        var imageData : NSData = UIImageJPEGRepresentation(currentImage, 0.5)
        var fullPath : String = NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent(imageName as String)
        imageData.writeToFile(fullPath as String, atomically: false)
        var fileURL = NSURL(fileURLWithPath : fullPath)
        //开始上传操作
        
        return fileURL!
        
    }
    
    func getCurrentTimeString() -> String {
        var date : NSDate = NSDate()
        var formatter : NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        var dateString = formatter.stringFromDate(date)
        
        return dateString
    }
    
    func getPhotoAddress (jsonResult : NSDictionary) -> String {
        var address : String?
        // 解析JSON
        var json = JSON(jsonResult)
        address = "http://123.56.91.235/Charity4Client/" + json["data"].stringValue
        
        return address!
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 即将进入时，查询数据库，更新用户信息
    override func viewWillAppear(animated: Bool) {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            
            print("数据库不为空")
            
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            // let nick = obj.valueForKey("nick") as! String
            
            self.userId = obj.valueForKey("id") as! Int
            
            self.profileNick.text = obj.valueForKey("nick") as? String
            self.username = obj.valueForKey("username") as? String
            ImageLoader.sharedLoader.imageForUrl((obj.valueForKey("avatar") as? String)!, completionHandler: { (image, url) -> () in
                self.profileAvatar.image = image
            })
            
            let isAuthentication = obj.valueForKey("isAuthentication") as! Bool
            if isAuthentication {
                self.authenticationBtn.hidden = true
                self.reconizedImageView.hidden = false
                print("已认证")
            } else {
                
                
                let authenticationRequest = (obj.valueForKey("authenticationRequest")) as! Bool
                
                if authenticationRequest {
                    self.authenticationBtn.titleLabel?.text = "认证中"
                    self.authenticationBtn.enabled = false
                    print("认证中")
                }
                
            }
            
            loginOrLogoutBarItem.title = "退出"
            
            self.authenticationBtn.hidden = false
            
        } else {
            print("数据库为空")
            loginOrLogoutBarItem.title = "登录"
            self.profileNick.text = "Designer / Frontend"
            self.authenticationBtn.hidden = true
            self.authenticationBtn.hidden = true
            return
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "profile"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ProfileTableViewCell
        
        switch (indexPath.row){
        case 0:
            cell.cellIcon.image = UIImage(named: "icon-love-selected.png")
            cell.cellName.text = "我的关注"
        case 1:
            cell.cellIcon.image = UIImage(named: "icon-my-record.png")
            cell.cellName.text = "我的记录"
            
        case 2:
            cell.cellIcon.image = UIImage(named: "icon-my-card.png")
            cell.cellName.text = "我的名片"
            
        default:
            print("nil")
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if loginOrLogoutBarItem.title == "退出" && !(segue.destinationViewController is applyAuthenticationViewController) && !(segue.destinationViewController is EditNickViewController) {
            deleteLocalData()
            
            print("删除数据库内容")
            
            
        } else if segue.destinationViewController is applyAuthenticationViewController {
            let applyController = segue.destinationViewController as! applyAuthenticationViewController
            
            applyController.username = self.username
            
            print(applyController.username)
        } else if (segue.destinationViewController is EditNickViewController) {
            
            let editNickController = segue.destinationViewController as! EditNickViewController
            editNickController.userId = self.userId
            editNickController.nick = self.profileNick.text
            
        } else {
            super.prepareForSegue(segue, sender: sender)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            let row = indexPath.row
            var destController : UIViewController!
            
            switch row {
            case 0:
                destController = self.storyboard?.instantiateViewControllerWithIdentifier("MyFocusController") as! MyFocusViewController
                self.navigationController?.pushViewController(destController, animated: true)
                
            case 1:
                destController = self.storyboard?.instantiateViewControllerWithIdentifier("MyRecordController") as! MyRecordViewController
                self.navigationController?.pushViewController(destController, animated: true)
                
            case 2:
                
                destController = self.storyboard?.instantiateViewControllerWithIdentifier("MyCardController") as! MycardViewController
                self.navigationController?.pushViewController(destController, animated: true)
            default:
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        } else {
            let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
            self.navigationController?.pushViewController(loginController, animated: true)
        }
        
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


}
