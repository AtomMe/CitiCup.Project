//
//  LaunchThirdViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/27.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import CoreLocation

class LaunchThirdViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var projectTitleTextField: UITextField!
    @IBOutlet var sexSegmentControl: UISegmentedControl!

    @IBOutlet var failTips: UILabel!
    @IBOutlet var uploadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var salaryTextField: UITextField!
    
    // 从前两个controller传过来的信息
    var projectMoney : Int!
    var projectType : Int!
    var projectReason : String!
    
    var appealName : String!
    var appealID : String!
    var appealPhone : String!
    var appealAddress : String!
    var appealEnmergencyName : String!
    var appealEnmergencyPhone : String!
    
    var currLocation : CLLocation!
    //用于定位服务管理类，它能够给我们提供位置信息和高度信息，也可以监控设备进入或离开某个区域，还可以获得设备的运行方向
    let locationManager : CLLocationManager = CLLocationManager()
    
    var imagePicker : UIImagePickerController? = UIImagePickerController()
    var dataArray = [UIImage]()
    
    var longitudeTxt : String!
    var latitudeTxt : String!
    
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
        
        self.submitBtn.enabled = false
        
        self.dataArray.append(UIImage(named: "icon-add-photo.png")!)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.uploadActivityIndicator.stopAnimating()
        
        self.locationManager.delegate = self
        //设备使用电池供电时最高的精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        locationManager.startUpdatingLocation()
        println("定位开始")
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
        println("定位结束")
    }
    
    // 获取到定位信息
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        currLocation = locations.last as! CLLocation
        self.longitudeTxt = "\(currLocation.coordinate.longitude)"
        self.latitudeTxt = "\(currLocation.coordinate.latitude)"
        
        print(self.longitudeTxt)
        
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
            self.collectionView.deleteItemsAtIndexPaths([path])
            
            // 如果删除完则取消编辑
            if self.dataArray.count == 1 {
                self.cancelWobble()
            }
            // 没有删除完则执行晃动动画
            else {
                self.longPressedAction()
            }
            
            if self.projectTitleTextField.hasText() && self.salaryTextField.hasText() && self.dataArray.count > 1 {
                self.submitBtn.enabled = true
            } else {
                self.submitBtn.enabled = false
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
        let array = self.collectionView.subviews
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
        let array = self.collectionView.subviews
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
            // self.imagePicker!.allowsEditing = true
            
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
            self.collectionView.insertItemsAtIndexPaths([path])
            
            if self.projectTitleTextField.hasText() && self.salaryTextField.hasText() && self.dataArray.count > 1 {
                self.submitBtn.enabled = true
            } else {
                self.submitBtn.enabled = false
            }
            
        }
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
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

    @IBAction func submit(sender: AnyObject) {
        
        self.view.alpha = 0.7
        self.uploadActivityIndicator.startAnimating()
        
        // 首先上传证明材料照片
        self.uploadPhotos()
        
        
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
                        //println(JSON)
                        
                        if (jsonResult != nil) {
                            // 解析json
                            let json = JSON(jsonResult!)
                            let photoAddress = json["data"].stringValue as String
                            print(photoAddress)
                            if photoAddress != "" {
                                // 请求新建Project
                                self.launchNewProject(photoAddress)
                            }
                            
                        }
                        
                    }
                case .Failure(let encodingError):
                    println(encodingError)
                }
            }
        )
        
    }
    
    func launchNewProject(photoAddress : String) {
        
        var sponsorId : Int!
        
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            
            
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            sponsorId = obj.valueForKey("id") as! Int
            
        }
        
        
        print("第一张图片宽度\(self.dataArray[0].size.width)")
        print("\n")
        print("第一张图片高度\(self.dataArray[0].size.height)")
        print("\n")
        
        let paras = [
            "sponsorId" : "\(sponsorId)",
            "projectType" : "\(self.projectType)",
            "projectMoney" : "\(self.projectMoney)",
            "projectReason" : self.projectReason,
            "projectTitle" : self.projectTitleTextField.text,
            "projectAddress" : self.longitudeTxt + ";" + self.latitudeTxt,
            "appealName" : self.appealName,
            "appealID" : self.appealID,
            "appealPhone" : self.appealPhone,
            "appealAddress" : self.appealAddress,
            "appealEnmergencyName" : self.appealEnmergencyName,
            "appealEnmergencyPhone" : self.appealEnmergencyPhone,
            "appealSex" : "\(self.sexSegmentControl.selectedSegmentIndex)",
            "appealIncome" : self.salaryTextField.text,
            "proveMaterial" : photoAddress,
            "imageWidth" : self.dataArray[0].size.width,
            "imageHeight" : self.dataArray[0].size.height
        ]
        
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/LaunchProject.php", parameters: paras as? [String : AnyObject])
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
            self.uploadActivityIndicator.stopAnimating()
            
            self.failTips.hidden = false
            
            
            let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideFailMsg:", userInfo: nil, repeats: false)
            
        }
        
    }
    
    func hideFailMsg(sender : AnyObject) {
        self.failTips.hidden = true
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
    
    @IBAction func sexChanged(sender: AnyObject) {
    }
    func handleSwipeGestureRecong(sender : UISwipeGestureRecognizer) {
        
        self.projectTitleTextField.resignFirstResponder()
        self.salaryTextField.resignFirstResponder()
        
    }
    @IBAction func projectTitle_DidEndOnExit(sender: AnyObject) {
        self.salaryTextField.becomeFirstResponder()
    }

    @IBAction func salary_DidEndOnExit(sender: AnyObject) {
        self.projectTitleTextField.resignFirstResponder()
        self.salaryTextField.resignFirstResponder()
    }
    @IBAction func editChanged(sender: AnyObject) {
        if self.projectTitleTextField.hasText() && self.salaryTextField.hasText() && self.dataArray.count > 1 {
            self.submitBtn.enabled = true
        } else {
            self.submitBtn.enabled = false
        }
    }
}
