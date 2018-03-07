//
//  ApplyMoneyRecordViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/4.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class ApplyMoneyRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var applyMoneyRecordTableView: UITableView!
    
    var dataArray = [Withdraw]()
    
    var times = 0
    var queryType = 0
    var hasShowNum = 0
    
    var avatar : String!
    
    var nibsRegistered = false
    
    var userId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.applyMoneyRecordTableView.delegate = self
        self.applyMoneyRecordTableView.dataSource = self
        
        self.applyMoneyRecordTableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshAction:")
        
        self.applyMoneyRecordTableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshAction:")
    }
    
    func headerRefreshAction(sneder : AnyObject) {
        print("正在下拉刷新")
        
        // 请求重新加载数据
        let paras = [
            "userId" : self.userId,
            "times" : 0,
            "queryType" : 0
        ]
        
        // 发送请求
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/GetWithdrawData.php", parameters: paras)
            .responseJSON { _, _, jsonResult, _ in
                print(jsonResult)
                
                if (jsonResult != nil) {
                    var json = JSON(jsonResult!)
                    
                    self.handleHeaderRefreshResult(json)
                }
        }
        
    }
    
    func handleHeaderRefreshResult(json : JSON) {
        let responseCode = json["code"].intValue
        let responseInfo = json["info"].intValue
        
        
        if responseInfo == 2 && responseCode == 200 {
            var data : [JSON]? = json["data"].arrayValue
            
            if (data != nil && data?.count > 0) {
                self.times = 1
                self.dataArray.removeAll(keepCapacity: true)
                self.hasShowNum = 0
                
                for index in 0..<data!.count {
                    let withdraw = Withdraw()
                    let jsonData = data![index]
                    
                    withdraw.id = jsonData["id"].intValue
                    withdraw.projectId = jsonData["projectId"].intValue
                    withdraw.userId = self.userId
                    withdraw.applyMoney = jsonData["applyMoney"].floatValue
                    withdraw.purpose = jsonData["purpose"].stringValue
                    withdraw.alipayAccount = jsonData["alipayAccount"].stringValue
                    withdraw.phoneNum = jsonData["phoneNum"].stringValue
                    withdraw.proveMaterial = jsonData["proveMaterial"].stringValue
                    withdraw.status = jsonData["status"].intValue
                    withdraw.failMsg = jsonData["failMsg"].stringValue
                    withdraw.dateRequest = jsonData["dateRequest"].stringValue
                    
                    self.dataArray.append(withdraw)

                }
                
                self.applyMoneyRecordTableView.reloadData()
                
            } else {
                
            }
        }
        
        self.applyMoneyRecordTableView.header.state = MJRefreshStateIdle
    }
    
    func footerRefreshAction(sender : AnyObject) {
        print("正在上拉刷新")
        
        print(self.times)
        
        // 请求重新加载数据
        let paras = [
            "userId" : self.userId,
            "times" : self.times,
            "queryType" : 1
        ]
        
        // 发送请求
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/GetWithdrawData.php", parameters: paras)
            .responseJSON { _, _, jsonResult, _ in
                // print(jsonResult)
                
                var json = JSON(jsonResult!)
                
                self.handleFooterRefreshResult(json)
        }
        
    }
    
    func handleFooterRefreshResult(json : JSON) {
        
        let responseCode = json["code"].intValue
        let responseInfo = json["info"].intValue
        
        
        if responseInfo == 4 && responseCode == 200 {
            var data : [JSON]? = json["data"].arrayValue
            
            if (data != nil && data?.count > 0) {
                
                for index in 0..<data!.count {
                    let withdraw = Withdraw()
                    let jsonData = data![index]
                    
                    withdraw.id = jsonData["id"].intValue
                    withdraw.projectId = jsonData["projectId"].intValue
                    withdraw.userId = self.userId
                    withdraw.applyMoney = jsonData["applyMoney"].floatValue
                    withdraw.purpose = jsonData["purpose"].stringValue
                    withdraw.alipayAccount = jsonData["alipayAccount"].stringValue
                    withdraw.phoneNum = jsonData["phoneNum"].stringValue
                    withdraw.proveMaterial = jsonData["proveMaterial"].stringValue
                    withdraw.status = jsonData["status"].intValue
                    withdraw.failMsg = jsonData["failMsg"].stringValue
                    withdraw.dateRequest = jsonData["dateRequest"].stringValue
                    // withdraw.avatar = self.avatar
                    
                    self.dataArray.append(withdraw)
                    let path = NSIndexPath(forRow: self.hasShowNum, inSection: 0)
                    self.applyMoneyRecordTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                self.times++
                
                
            } else {
                
            }
        }
        
        self.applyMoneyRecordTableView.footer.state = MJRefreshStateIdle
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            
            
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            self.userId = obj.valueForKey("id") as! Int
            self.avatar = obj.valueForKey("avatar") as! String
        }
        
        if self.times == 0 {
            let paras = [
                "userId" : self.userId,
                "times" : 0,
                "queryType" : 0
            ]
            
            // 发送请求
            Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/GetWithdrawData.php", parameters: paras)
                .responseJSON { _, _, jsonResult, _ in
                    if (jsonResult != nil) {
                        
                        print(jsonResult)
                        
                        var json = JSON(jsonResult!)
                        self.handleJsonResult(json)
                        
                    }
            }
        }
    }
    
    func handleJsonResult(json : JSON) {
        let responseCode = json["code"].intValue
        let responseInfo = json["info"].intValue
        
        
        if responseInfo == 2 && responseCode == 200 {
            var data : [JSON]? = json["data"].arrayValue
            
            if (data != nil && data?.count > 0) {
                
                for index in 0..<data!.count {
                    let withdraw = Withdraw()
                    let jsonData = data![index]
                    
                    withdraw.id = jsonData["id"].intValue
                    withdraw.projectId = jsonData["projectId"].intValue
                    withdraw.userId = self.userId
                    withdraw.applyMoney = jsonData["applyMoney"].floatValue
                    withdraw.purpose = jsonData["purpose"].stringValue
                    withdraw.alipayAccount = jsonData["alipayAccount"].stringValue
                    withdraw.phoneNum = jsonData["phoneNum"].stringValue
                    withdraw.proveMaterial = jsonData["proveMaterial"].stringValue
                    withdraw.status = jsonData["status"].intValue
                    withdraw.failMsg = jsonData["failMsg"].stringValue
                    withdraw.dateRequest = jsonData["dateRequest"].stringValue
                    
                    self.dataArray.append(withdraw)
                    let path = NSIndexPath(forRow: self.hasShowNum, inSection: 0)
                    self.applyMoneyRecordTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                //
                self.times++
                
                
            } else {
                return
            }
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if !self.nibsRegistered {
            let nib = UINib(nibName: "ApplyMoneyRecordTableViewCell", bundle: nil)
            self.applyMoneyRecordTableView.registerNib(nib, forCellReuseIdentifier: "applyMoneyRecord")
            self.nibsRegistered = true
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("applyMoneyRecord", forIndexPath: indexPath) as! ApplyMoneyRecordTableViewCell
        
        let withdraw = self.dataArray[self.hasShowNum]
        cell.money.text = "\(withdraw.applyMoney)"
        cell.application.text = withdraw.purpose
        
        switch withdraw.status {
        case 0:
            cell.status.text = "正在申请中"
        case 1:
            cell.status.text = "申请成功，已转账"
        case 2:
            cell.status.text = "申请失败"
        default :
            cell.status.text = "未知"
        }
        
        // 设置为圆形头像显示
        cell.avatar.layer.cornerRadius = CGRectGetHeight(cell.avatar.bounds) / 2
        cell.avatar.layer.masksToBounds = true
        
        cell.time.text = withdraw.dateRequest
        ImageLoader.sharedLoader.imageForUrl(self.avatar, completionHandler: { (image, url) -> () in
            cell.avatar.image = image
        })
        
        self.hasShowNum++
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
