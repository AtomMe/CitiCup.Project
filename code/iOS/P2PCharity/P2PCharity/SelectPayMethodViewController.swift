//
//  SelectPayMethodViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/3.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class SelectPayMethodViewController: UIViewController, BmobPayDelegate, UIAlertViewDelegate {
    
    var donationMoney : Float!
    var projectTitleStr : String!
    var projectId : Int!
    var donationPersonName : String!
    var donationPersonPhone : String!
    var userId : Int!
    
    var pay = BmobPay()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pay.delegate = self
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

    @IBAction func aliPay(sender: AnyObject) {
        
        pay.price = self.donationMoney
        pay.productName = self.projectTitleStr
        pay.body = "益帮人捐款救助"
        pay.appScheme = "P2PCharity"
        pay.payInBackground()
    }
    
    // BmobPayDelegate回调
    func paySuccess() {
        
        var userId : Int!
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            userId = obj.valueForKey("id") as! Int
            
        }
        
        // 支付成功后需要创建支付订
        let paras = [
            "projectId" : self.projectId,
            "userId" : userId!,
            "name" : self.donationPersonName,
            "phoneNum" : self.donationPersonPhone,
            "donationMoney" : self.donationMoney,
            "tradeNo" : pay.tradeNo
        ]
        
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/CreateDonationOrder.php", parameters: paras as? [String : AnyObject])
        .responseJSON { _, _, jsonResult, _ in
            if (jsonResult != nil) {
                var json = JSON(jsonResult!)
                self.handleResult(json)
            }
        }
    }
    
    func handleResult(json : JSON) {
        let responseCode = json["code"].intValue
        let responseInfo = json["info"].intValue
        
        if responseCode == 200 && responseInfo == 1 {

            let alert = UIAlertView()
            alert.title = "提示"
            alert.message = "您已支付成功，谢谢您的捐款，祝您生活愉快。"
            alert.addButtonWithTitle("确定")
            alert.show()
            
            
        } else {
            // 创建记录失败
            let alert = UIAlertView()
            alert.title = "提示"
            alert.message = "您已支付成功，但创建订单记录失败，请检查网络连接重试或申请退款。"
            alert.addButtonWithTitle("重试")
            alert.addButtonWithTitle("申请退款")
            alert.delegate = self
            alert.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        // 重试
        if buttonIndex == 0 {
            self.paySuccess()
        } else if buttonIndex == 1 {
            // 申请退款
            // 此处暂不实现
        }
    }
    
    func payFailWithErrorCode(errorCode: Int32) {
        switch errorCode {
        case 6001:
            let alert = UIAlertView()
            alert.title = "支付结果"
            alert.message = "用户中途取消"
            alert.addButtonWithTitle("关闭")
            alert.show()
            
        case 6002:
            let alert = UIAlertView()
            alert.title = "支付结果"
            alert.message = "网络连接出错"
            alert.addButtonWithTitle("关闭")
            alert.show()
            
        case 4000:
            let alert = UIAlertView()
            alert.title = "支付结果"
            alert.message = "订单支付失败"
            alert.addButtonWithTitle("关闭")
            alert.show()
            
        default:
            return
            
        }
    }
}
