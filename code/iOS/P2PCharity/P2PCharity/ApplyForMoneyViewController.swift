//
//  ApplyForMoneyViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/4.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class ApplyForMoneyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var projectTitle: UILabel!
    @IBOutlet var leftMoney: UILabel!
    @IBOutlet var numOfMuney: UITextField!
    @IBOutlet var applicationOfMoney: UITextField!

    @IBOutlet var failMsg: UILabel!
    @IBOutlet var sureBtn: UIButton!
    @IBOutlet var aliPayNo: UITextField!
    @IBOutlet var phoneNum: UITextField!
    @IBOutlet var proveMaterialsCollectionView: UICollectionView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var project : Project!
    
    var numOfPhoto = 0
    
    var imagePicker : UIImagePickerController? = UIImagePickerController()
    var dataArray = [UIImage]()
    var deleteIndex : Int = 1
    var wobble = false
    let Photo = 8
    var photoAddress = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let swipeGestureRecong = UISwipeGestureRecognizer(target: self, action: "handleSwipeGestureRecong:")
        self.view.addGestureRecognizer(swipeGestureRecong)
        swipeGestureRecong.direction = UISwipeGestureRecognizerDirection.Down
        
        self.projectTitle.text = self.project!.projectTitle
        self.leftMoney.text = "\(project!.projectLeftMoney)"
        
        self.sureBtn.enabled = false
        
        self.dataArray.append(UIImage(named: "icon-add-photo.png")!)
        
        self.proveMaterialsCollectionView.delegate = self
        self.proveMaterialsCollectionView.dataSource = self
        
        self.activityIndicator.stopAnimating()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipeGestureRecong(sender : UISwipeGestureRecognizer) {
        
        self.numOfMuney.resignFirstResponder()
        self.applicationOfMoney.resignFirstResponder()
        self.aliPayNo.resignFirstResponder()
        self.phoneNum.resignFirstResponder()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DynamicPhotoCell", forIndexPath: indexPath) as! DynamicPhotoCellCollectionViewCell
        
        cell.tag = indexPath.row
        cell.closeBtn.tag = indexPath.row
        cell.closeBtn.addTarget(self, action: "deletePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.photoImageView.image = self.dataArray[indexPath.row]
        
        if indexPath.row == self.dataArray.count - 1 {
            cell.addBtn.hidden = false
        } else {
            cell.addBtn.hidden = true
        }
        
        cell.addBtn.addTarget(self, action: "addPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressedAction")
        
        cell.contentView.addGestureRecognizer(longPress)
        
        return cell
        
    }
    
    // 删除
    func deletePhoto(sender : UIButton) {
        
        print(sender.tag)
        
        let alert = UIAlertView()
        alert.title = "提示"
        alert.message = "您确认删除吗？"
        alert.delegate = self
        alert.addButtonWithTitle("取消")
        alert.addButtonWithTitle("确认")
        alert.show()
        
        self.deleteIndex = sender.tag
        print(self.deleteIndex)
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            print(self.deleteIndex)
            self.dataArray.removeAtIndex(self.deleteIndex)
            let path = NSIndexPath(forRow: self.deleteIndex, inSection: 0)
            self.proveMaterialsCollectionView.deleteItemsAtIndexPaths([path])
            
            // 如果删除完则取消编辑
            if self.dataArray.count == 1 {
                self.cancelWobble()
            }
                // 没有删除完则执行晃动动画
            else {
                self.longPressedAction()
            }
            
            if self.numOfMuney.hasText() && self.applicationOfMoney.hasText() && self.aliPayNo.hasText() && self.phoneNum.hasText() && self.dataArray.count > 1 {
                self.sureBtn.enabled = true
            } else {
                self.sureBtn.enabled = false
            }
        }
    }
    
    // 添加图片
    func addPhoto(sender : UIButton) {
        // 如果是编辑状态则取消编辑状态
        if self.wobble {
            self.cancelWobble()
        } else {
            if self.dataArray.count > Photo {
                let alertView = UIAlertView()
                alertView.title = "提示"
                alertView.message = "最多只能上传8张图片"
                alertView.addButtonWithTitle("取消")
                alertView.addButtonWithTitle("确定")
                alertView.show()
                
            } else {
                let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "我的相册")
                actionSheet.actionSheetStyle = UIActionSheetStyle.BlackOpaque
                actionSheet.showInView(self.view)
                
                
            }
        }
    }
    
    func cancelWobble() {
        self.wobble = false
        let array = self.proveMaterialsCollectionView.subviews
        for index in 0...dataArray.count - 1 {
            if array[index] is DynamicPhotoCellCollectionViewCell {
                let cell : DynamicPhotoCellCollectionViewCell = array[index] as! DynamicPhotoCellCollectionViewCell
                cell.closeBtn.hidden = true
                if cell.tag == 99999 {
                    cell.photoImageView.image = UIImage(named: "icon-add-photo.png")
                }
                
                // 晃动动画
                self.animationViewCell(cell)
                
            }
        }
    }
    
    func longPressedAction() {
        self.wobble = true
        let array = self.proveMaterialsCollectionView.subviews
        for index in 0...dataArray.count - 1 {
            if array[index] is DynamicPhotoCellCollectionViewCell {
                let cell : DynamicPhotoCellCollectionViewCell = array[index] as! DynamicPhotoCellCollectionViewCell
                
                if cell.addBtn.hidden {
                    cell.closeBtn.hidden = false
                } else {
                    cell.closeBtn.hidden = true
                    cell.photoImageView.image = UIImage(named: "icon-sure.png")
                    cell.tag = 99999
                }
                
                // 晃动动画
                self.animationViewCell(cell)
                
            }
        }
    }
    
    func animationViewCell(cell : DynamicPhotoCellCollectionViewCell) {
        if self.wobble {
            cell.transform = CGAffineTransformMakeRotation(-0.1)
            UIView.animateWithDuration(0.08, delay: 0.0, options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                cell.transform = CGAffineTransformMakeRotation(0.1)
                }, completion: nil)
            
        } else {
            UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                cell.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
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
                theImage = info[UIImagePickerControllerEditedImage] as? UIImage
            } else {
                theImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            
            self.dataArray.insert(theImage!, atIndex: 0)
            let path = NSIndexPath(forRow: 0, inSection: 0)
            self.proveMaterialsCollectionView.insertItemsAtIndexPaths([path])
            
            if self.numOfMuney.hasText() && self.applicationOfMoney.hasText() && self.aliPayNo.hasText() && self.phoneNum.hasText() && self.dataArray.count > 1 {
                self.sureBtn.enabled = true
            } else {
                self.sureBtn.enabled = false
            }
            
        }
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func ApplicationOfMoney_Next(sender: AnyObject) {
        self.aliPayNo.becomeFirstResponder()
    }
    @IBAction func AliPay_Next(sender: AnyObject) {
        self.phoneNum.becomeFirstResponder()
    }
    @IBAction func Edit_End(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    @IBAction func EditChanged(sender: AnyObject) {
        print(self.dataArray.count)
        if self.numOfMuney.hasText() && self.applicationOfMoney.hasText() && self.aliPayNo.hasText() && self.phoneNum.hasText() && self.dataArray.count > 1 {
            self.sureBtn.enabled = true
        } else {
            self.sureBtn.enabled = false
        }
    }
    @IBAction func apply(sender: AnyObject) {
        
        let applyMoney = (self.numOfMuney.text as NSString).floatValue
        if applyMoney > self.project.projectLeftMoney {
            let alert = UIAlertView()
            alert.title = "提示"
            alert.message = "可提款余额不足"
            alert.addButtonWithTitle("确定")
            alert.show()
        } else {
            self.view.alpha = 0.7
            self.activityIndicator.startAnimating()
            
            // 首先上传证明材料照片
            self.uploadPhotos()
        }
        
        
    }
    
    func uploadPhotos() {
        
        var array = self.dataArray
        Alamofire.upload(
            .POST,
            URLString: "http://123.56.91.235/Charity4Client/SaveProveMaterialPhoto.php",
            multipartFormData: { multipartFormData in
                
                for index in 0...self.dataArray.count - 2 {
                    multipartFormData.appendBodyPart(fileURL: self.saveImage(self.dataArray[index] , imageName: self.getCurrentTimeString() + String(index) + ".jpg"), name: "proveMaterials" + String(index))
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { request, response, jsonResult, error in
                        // println(JSON)
                        
                        if (jsonResult != nil) {
                            // 解析json
                            let json = JSON(jsonResult!)
                            let photoAddress = json["data"].stringValue as String
                            
                            if photoAddress != "" {
                                // 请求新建提款记录
                                // self.launchNewProject(photoAddress)
                                self.ApplyMoneyRequest(photoAddress)
                            }
                            
                        }
                        
                    }
                case .Failure(let encodingError):
                    println(encodingError)
                }
            }
        )
        
    }
    
    func ApplyMoneyRequest(photoAddress : String) {
        let paras = [
            "projectId" : self.project.id,
            "userId" : self.project.sponsorId,
            "applyMoney" : self.numOfMuney.text,
            "purpose" : self.applicationOfMoney.text,
            "alipayAccount" : self.aliPayNo.text,
            "phoneNum" : self.phoneNum.text,
            "proveMaterial" : photoAddress,
        ]
        
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/ApplyMoney.php", parameters: paras as? [String : AnyObject])
            .responseJSON { _, _, jsonResult, _ in
                print(jsonResult)
                if (jsonResult != nil) {
                    let json = JSON(jsonResult!)
                    self.handleJsonResult(json)
                }
        }
        
    }
    
    func handleJsonResult(json : JSON) {
        
        let responseCode = json["code"].intValue
        let responseInfo = json["info"].intValue
        
        // 创建成功
        if responseCode == 200 && responseInfo == 1 {
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        } else {
            // 显示失败提示
            self.view.alpha = 1
            self.activityIndicator.stopAnimating()
            
            self.failMsg.hidden = false
            
            
            let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideFailMsg:", userInfo: nil, repeats: false)
            
        }
        
    }
    
    
    func hideFailMsg(sender : AnyObject) {
        self.failMsg.hidden = true
    }
    
    func getPhotoAddress (jsonResult : NSDictionary) -> String {
        var address : String?
        // 解析JSON
        var json = JSON(jsonResult)
        address = "http://123.56.91.235/Charity4Client/" + json["data"].stringValue
        
        return address!
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

}
