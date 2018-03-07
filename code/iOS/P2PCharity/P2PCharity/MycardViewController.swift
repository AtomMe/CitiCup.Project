//
//  MycardViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/8.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class MycardViewController: UIViewController, SinaWbDelegate, GiftTalkSheetDelegate, FreeGeekDelegate, UIActionSheetDelegate {
    @IBOutlet var allView: UIView!
    @IBOutlet var cardName: UILabel!
    @IBOutlet var cardTimes: UILabel!
    @IBOutlet var cardTotalMoney: UILabel!

    @IBOutlet var cardView: UIView!
    
    var userId : Int!
    var nick : String!
    
    let SinaWBURI = "http://youtui.mobi/weiboResponse"
    
    let titleArray = [
        "微信", "微信朋友圈", "微信收藏", "新浪微博"
    ]
    let imageArray = [
        "wechat", "wechatf", "wechatc", "sina"
    ]
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        YouTuiSDK.connectSinaWithAppKey("605838127")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            self.userId = obj.valueForKey("id") as! Int
            self.nick = obj.valueForKey("nick") as! String
            let paras = [
                "userId" : self.userId
            ]
            
            Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/GetUserCardInfo.php", parameters: paras)
            .responseJSON { _, _, jsonResult, _ in
             
                print(jsonResult)
                if (jsonResult != nil) {
                    var json = JSON(jsonResult!)
                    
                    let responseCode = json["code"].intValue
                    let responseInfo = json["info"].intValue
                    
                    if responseCode == 200 && responseInfo == 1 {
                        
                        self.cardName.text = self.nick
                        self.cardTimes.text = json["data"]["totalTimes"].stringValue
                        let totalMoney = (json["data"]["totalMoney"].stringValue as NSString).floatValue
                        self.cardTotalMoney.text = "\(totalMoney)"
                    }
                }
                
            }
        }
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
    @IBAction func share(sender: AnyObject) {
        
        print("clicked")
        
//        let sheetView = GiftTalkSheetView(titleArray: self.titleArray, imageArray: self.imageArray, pointArray: nil, activityName: nil, delegate: self)
//        sheetView.ShowInView(self.view)
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "微信好友", "微信朋友圈", "微信收藏", "新浪微博")
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackOpaque
        actionSheet.showInView(self.view)
    }
    
    func getImageFromView(view : UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func ShareButtonAction(buttonIndex: UnsafeMutablePointer<Int>) {
        
    }
    
    func GiftTalkShareButtonAction(buttonIndex: Int32) {
        print(buttonIndex)
        switch buttonIndex{
        case 0:
            self.shareToWxContact()
            
        case 1:
            self.shareToWXFriendCircle()
            
            //
        case 2:
            self.shareToWxFavorite()
            
        case 3:
            
            let image = getImageFromView(self.cardView)
            
            YouTuiSDK.SinaWbShareMessage("我的益帮人公益名片", image: image, url: "http://p2pcharity.bmob.cn", redirectURI: self.SinaWBURI, accessToken: self.defaults.stringForKey("token"), publicTime: "2015-1-22 18:30", artTitle: "我的益帮人公益名片", artID: "SINA3")
            
        default:
            return
            
        }
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
            
            let image = getImageFromView(self.cardView)
            
            YouTuiSDK.SinaWbShareMessage("我的益帮人公益名片", image: image, url: "http://p2pcharity.bmob.cn", redirectURI: self.SinaWBURI, accessToken: self.defaults.stringForKey("token"), publicTime: "2015-1-22 18:30", artTitle: "我的益帮人公益名片", artID: "SINA3")
            
        default:
            return
        }
    }
    
    // 分享到微信收藏夹
    func shareToWxFavorite() {
        let image = getImageFromView(self.cardView)
        let message = WXMediaMessage()
        let object = WXImageObject()
        object.imageData = UIImagePNGRepresentation(image)
        message.mediaObject = object
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 2
        
        message.title = "益帮人公益名片分享"
        message.setThumbImage(image)
        
        WXApi.sendReq(req)
    }
    
    // 分享到微信联系人
    func shareToWxContact() {
        let image = getImageFromView(self.cardView)
        let message = WXMediaMessage()
        let object = WXImageObject()
        object.imageData = UIImagePNGRepresentation(image)
        message.mediaObject = object
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 0
        
        message.title = "益帮人公益名片分享"
        message.setThumbImage(image)
        WXApi.sendReq(req)
    }
    
    
     // 分享到微信朋友圈
    func shareToWXFriendCircle() {
        let image = getImageFromView(self.cardView)
        let message = WXMediaMessage()
        let object = WXImageObject()
        object.imageData = UIImagePNGRepresentation(image)
        message.mediaObject = object
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 1
        
        message.title = "益帮人公益名片分享"
        message.setThumbImage(image)
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

}
