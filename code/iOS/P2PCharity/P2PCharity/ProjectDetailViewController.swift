//
//  ProjectDetailViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/24.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class ProjectDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SinaWbDelegate, GiftTalkSheetDelegate, UIActionSheetDelegate {
    @IBOutlet var loveImageView: UIImageView!
    @IBOutlet var loveTips: UILabel!
    @IBOutlet var projectHasGotMoneyLabel: UILabel!
    @IBOutlet var proveMaterialsCollectionView: UICollectionView!
    
    @IBOutlet var helpBtn: UIButton!
    @IBOutlet var projectLeftTime: UILabel!
    @IBOutlet var appealAvatar: UIImageView!
    @IBOutlet var appealName: UILabel!
    @IBOutlet var appealSex: UILabel!
    @IBOutlet var appealAddress: UILabel!
    @IBOutlet var projectReason: UITextView!
    @IBOutlet var projectProgress: UIProgressView!
    
    @IBOutlet var projectProgressLabel: UILabel!
    @IBOutlet var projectMoneyLabel: UILabel!
    
    let SinaWBURI = "http://youtui.mobi/weiboResponse"
    
    var project : Project!
    
    var dataArray = [String]()
    
    var hasShowMaterialNum = 0
    var userId : Int!
    
    let titleArray = [
        "微信", "微信朋友圈", "微信收藏", "新浪微博"
    ]
    let imageArray = [
        "wechat", "wechatf", "wechatc", "sina"
    ]
    
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.contentSize = CGSizeMake(320, 1200)
        
        // self.initProjectDetails()
        
        self.proveMaterialsCollectionView.delegate = self
        self.proveMaterialsCollectionView.dataSource = self
        
        YouTuiSDK.connectSinaWithAppKey("605838127")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "loveTaped:")
        self.loveImageView.addGestureRecognizer(tapGesture)
        
        // 设置为圆形头像显示
        self.appealAvatar.layer.cornerRadius = CGRectGetHeight(self.appealAvatar.bounds) / 2
        self.appealAvatar.layer.masksToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.initProjectDetails()
    }
    
    func loveTaped(sender : UITapGestureRecognizer) {
        // taped
        if (self.userId != nil) {
            if self.loveTips.text == "关注" {
                let paras = [
                    "userId" : self.userId,
                    "projectId" : self.project.id
                ]
                
                Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/AddFavorite.php", parameters: paras)
                .responseJSON { _, _, jsonResult, _ in
                    print(jsonResult)
                    if (jsonResult != nil) {
                        var json = JSON(jsonResult!)
                        
                        let responseCode = json["code"].intValue
                        let responseInfo = json["info"].intValue
                        
                        // 已加入收藏
                        if responseCode == 200 && responseInfo == 1 {
                            self.loveImageView.image = UIImage(named: "icon-love-selected.png")
                            self.loveTips.text = "已关注"
                            self.loveTips.textColor = UIColor.redColor()
                        }
                    }
                }
            } else if self.loveTips.text == "已关注" {  // 取消关注
                let paras = [
                    "userId" : self.userId,
                    "projectId" : self.project.id
                ]
                
                Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/CancleFavorite.php", parameters: paras)
                    .responseJSON { _, _, jsonResult, _ in
                        print(jsonResult)
                        if (jsonResult != nil) {
                            var json = JSON(jsonResult!)
                            
                            let responseCode = json["code"].intValue
                            let responseInfo = json["info"].intValue
                            
                            // 已加入收藏
                            if responseCode == 200 && responseInfo == 1 {
                                self.loveImageView.image = UIImage(named: "icon-love-normal.png")
                                self.loveTips.text = "关注"
                                self.loveTips.textColor = UIColor.whiteColor()
                            }
                        }
                }
            }
        }
        
    }
    
    func initProjectDetails() {
        
        if (project != nil) {
            // self.appealAvatar.image = UIImage(data: NSData(contentsOfURL: NSURL(string: project.appealAvatar)!)!)
            ImageLoader.sharedLoader.imageForUrl(self.project.appealAvatar, completionHandler: { (image, url) -> () in
                self.appealAvatar.image = image
            })
            self.appealName.text = project.appealName
            
            self.appealSex.text = (project.appealSex == true) ? "男" : "女"
            self.appealAddress.text = project.appealAddress
            self.projectReason.text = project.projectReason
            self.projectMoneyLabel.text = "\(self.project.projectMoney)"
            self.projectHasGotMoneyLabel.text = "\(self.project.projectLeftMoney + self.project.projectWithdrawMoney)"
            self.projectLeftTime.text = "\(30 - self.project.spendDay)"
            
            let progress = Float((self.project.projectLeftMoney + self.project.projectWithdrawMoney)) / Float(self.project.projectMoney!)
            
            let p = String(format: "%.2f", progress)
            
            self.projectProgress.progress = (p as NSString).floatValue
            
            self.projectProgressLabel.text = "\(Float((self.project.projectLeftMoney + self.project.projectWithdrawMoney)) / Float(self.project.projectMoney!) * 100)" + "%"
            var proveMaterial = self.project.proveMaterial
            var materialArray = proveMaterial.componentsSeparatedByString(";")
            // print(materialArray.count)
            materialArray.removeLast()
            self.dataArray += materialArray
            
            // 判断用户是否收藏了此项目
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            var context = appDelegate.managedObjectContext
            
            var fetchRequest = NSFetchRequest(entityName: "User")
            var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
            
            if fetchResult?.count > 0 {
                
                
                let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
                self.userId = obj.valueForKey("id") as! Int
                
                let paras = [
                    "userId" : self.userId,
                    "projectId" : self.project.id
                ]
                
                Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/IsUserFavorite.php", parameters: paras)
                .responseJSON { _, _, jsonResult, _ in
                 
                    print(jsonResult)
                    if (jsonResult != nil) {
                        var json = JSON(jsonResult!)
                        
                        let responseCode = json["code"].intValue
                        let responseInfo = json["info"].intValue
                        
                        // 已收藏
                        if responseCode == 200 && responseInfo == 1 {
                            self.loveImageView.image = UIImage(named: "icon-love-selected.png")
                            self.loveTips.text = "已关注"
                            self.loveTips.textColor = UIColor.redColor()
                        }
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProveMaterialCollectionViewCell
        SJAvatarBrowser.showImage(cell.photoImageView)
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProveMaterialCell", forIndexPath: indexPath) as! ProveMaterialCollectionViewCell
        
        // cell.photoImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.dataArray[hasShowMaterialNum])!)!)
        
        ImageLoader.sharedLoader.imageForUrl(self.dataArray[hasShowMaterialNum], completionHandler: { (image, url) -> () in
            cell.photoImageView.image = image
        })
        
        self.hasShowMaterialNum++
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let donationInfoController = segue.destinationViewController as! DonationInfoViewController
        donationInfoController.projectTitleStr = project.projectTitle
        donationInfoController.projectId = project.id
    }
    
    @IBAction func share(sender: AnyObject) {
        
//        let sheetView = GiftTalkSheetView(titleArray: self.titleArray, imageArray: self.imageArray, pointArray: nil, activityName: nil, delegate: self)
//        sheetView.ShowInView(self.view)

        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "微信好友", "微信朋友圈", "微信收藏", "新浪微博")
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackOpaque
        actionSheet.showInView(self.view)
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
        switch buttonIndex {
        case 1:
            self.shareToWxContact()
            
        case 2:
            self.shareToWXFriendCircle()
            
            //
        case 3:
            self.shareToWxFavorite()
            
        case 4:
            
            let cell = self.proveMaterialsCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProveMaterialCollectionViewCell
            let image = cell.photoImageView.image
            
            YouTuiSDK.SinaWbShareMessage(self.projectReason.text, image: image, url: "http://p2pcharity.bmob.cn", redirectURI: self.SinaWBURI, accessToken: self.defaults.stringForKey("token"), publicTime: "2015-1-22 18:30", artTitle: self.project.projectTitle, artID: "SINA3")
            
        default:
            return
        }
    }
    
    func GiftTalkShareButtonAction(buttonIndex: Int32) {
        print(buttonIndex)
        switch buttonIndex{
            case 0:
                self.shareToWxContact()
            
            case 1:
                self.shareToWXFriendCircle()
            
            
            case 2:
                self.shareToWxFavorite()
        
            case 3:
        
                let cell = self.proveMaterialsCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProveMaterialCollectionViewCell
                let image = cell.photoImageView.image
    
                YouTuiSDK.SinaWbShareMessage(self.projectReason.text, image: image, url: "http://p2pcharity.bmob.cn", redirectURI: self.SinaWBURI, accessToken: self.defaults.stringForKey("token"), publicTime: "2015-1-22 18:30", artTitle: self.project.projectTitle, artID: "SINA3")
                    
            default:
                return
                    
        }
    }

    // 分享到微信收藏夹
    func shareToWxFavorite() {
        let cell = self.proveMaterialsCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProveMaterialCollectionViewCell
        let image = cell.photoImageView.image
        let message = WXMediaMessage()
        let object = WXImageObject()
        object.imageData = UIImagePNGRepresentation(image)
        message.mediaObject = object
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 2
        
        message.title = "益帮人求助项目分享"
        message.description = "益帮人求助项目分享"
        //message.setThumbImage(image)
        WXApi.sendReq(req)
    }
    
    // 分享到微信联系人
    func shareToWxContact() {
        let cell = self.proveMaterialsCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProveMaterialCollectionViewCell
        let image = cell.photoImageView.image
        let message = WXMediaMessage()
        let object = WXImageObject()
        object.imageData = UIImagePNGRepresentation(image)
        message.mediaObject = object
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 0
        
        message.title = "益帮人求助项目分享"
        message.description = "益帮人求助项目分享"
        //message.setThumbImage(image)
        WXApi.sendReq(req)
    }
    
    
    // 分享到微信朋友圈
    func shareToWXFriendCircle() {
        let cell = self.proveMaterialsCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProveMaterialCollectionViewCell
        let image = cell.photoImageView.image
        let message = WXMediaMessage()
        let object = WXImageObject()
        object.imageData = UIImagePNGRepresentation(image)
        message.mediaObject = object
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 1
        
        message.title = "益帮人求助项目分享"
        message.description = "益帮人求助项目分享"
        //message.setThumbImage(image)
        WXApi.sendReq(req)
        
    }
    
    // Sina分享的回调
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        // 收到回调
        
        print("收到回调")
        
        if response is WBSendMessageToWeiboResponse {
            //        response.statusCode    响应状态码
            //         0 :  成功
            //        -1 :  用户取消发送
            //        -2 :  发送失败
            //        -3 :  授权失败
            //        -4 :  用户取消安装微博客户端
            //        -99:  不支持的请求
            //    response.userInfo         用户信息
            //    response.requestUserInfo  用户详细信息
            
            if response.statusCode == WeiboSDKResponseStatusCode.Success {
                let alert = UIAlertView()
                alert.title = "分享结果"
                alert.message = "分享成功"
                alert.addButtonWithTitle("确定")
                alert.show()
            } else {
                let alert = UIAlertView()
                alert.title = "分享结果"
                alert.message = "分享失败"
                alert.addButtonWithTitle("确定")
                alert.show()
            }
            
        }
        
    }
    
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        //
    }
    
    //QQ分享的回调方法
    func onResp(resp: BaseResp!) {
        
    }
    
    func onReq(req: BaseReq!) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func tencentDidLogin() {
        
    }
    
    func tencentDidNotLogin(cancelled: Bool) {
        
    }
    
    func tencentDidLogout() {
        
    }
    
    func getUserInfoResponse(response: APIResponse!) {
        
    }

    @IBAction func applyDonation(sender: AnyObject) {
        // 检查当前用户是否已经登陆
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            
            let donationInfoController = self.storyboard?.instantiateViewControllerWithIdentifier("donationInfo") as! DonationInfoViewController
            self.navigationController?.pushViewController(donationInfoController, animated: true)
            
        } else {
            let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
            self.navigationController?.pushViewController(loginController, animated: true)
        }
    }
}
