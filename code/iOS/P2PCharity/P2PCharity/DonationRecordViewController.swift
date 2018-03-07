//
//  DonationRecordViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/4.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class DonationRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var donationRecordTableView: UITableView!
    
    var dataArray = [Donation]()
    
    var times = 0
    var queryType = 0
    var hasShowNum = 0
    var userId : Int!
    
    var avatar : String!
    
    var nibsRegistered = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.donationRecordTableView.delegate = self
        self.donationRecordTableView.dataSource = self
        
        
        self.donationRecordTableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshAction:")
        
        self.donationRecordTableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshAction:")
    }
    
    func headerRefreshAction(sneder : AnyObject) {
        // 正在下拉刷新
        print("下拉刷新")
        let paras = [
            "userId" : self.userId,
            "times" : 0,
            "queryType" : 0
        ]
        
        // 发送请求
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryUserDonationRecord.php", parameters: paras)
            .responseJSON { _, _, jsonResult, _ in
                // print(jsonResult)
                
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
            
            var titleArray : [JSON]? = json["title"].arrayValue
            
            if (data != nil && data?.count > 0) {
                self.times = 1
                self.dataArray.removeAll(keepCapacity: true)
                self.hasShowNum = 0
                
                for index in 0..<data!.count {
                    let donation = Donation()
                    let jsonData = data![index]
                    let titleData = titleArray![index]
                    
                    donation.projectId = jsonData["projectId"].intValue
                    donation.id = jsonData["id"].intValue
                    donation.userId = self.userId
                    donation.name = jsonData["name"].stringValue
                    donation.phoneNum = jsonData["phoneNum"].stringValue
                    donation.donationMoney = jsonData["donationMoney"].floatValue
                    donation.status = jsonData["status"].intValue
                    donation.dateDonation = jsonData["dateDonation"].stringValue
                    donation.applicationOfMoney = jsonData["applicationOfMoney"].stringValue
                    donation.tradeNo = jsonData["tradeNo"].stringValue
                    donation.projectTitle = titleData["projectTitle"].stringValue
                    
                    self.dataArray.append(donation)
                }
                
                //
                
                self.donationRecordTableView.reloadData()
                
            } else {
                
            }
        }
        
        self.donationRecordTableView.header.state = MJRefreshStateIdle
    }
    
    func footerRefreshAction(sneder : AnyObject) {
        print("上拉刷新")
        let paras = [
            "userId" : self.userId,
            "times" : self.times,
            "queryType" : 1
        ]
        
        // 发送请求
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryUserDonationRecord.php", parameters: paras)
            .responseJSON { _, _, jsonResult, _ in
                print(jsonResult)
                
                if (jsonResult != nil) {
                    var json = JSON(jsonResult!)
                    
                    self.handleFooterRefreshResult(json)
                }
        }
    }
    
    func handleFooterRefreshResult(json : JSON) {
        
        let responseCode = json["code"].intValue
        let responseInfo = json["info"].intValue
        
        
        if responseInfo == 4 && responseCode == 200 {
            print("有更多的数据")
            var data : [JSON]? = json["data"].arrayValue
            
            var titleArray : [JSON]? = json["title"].arrayValue
            
            if (data != nil && data?.count > 0) {
                
                for index in 0..<data!.count {
                    let donation = Donation()
                    let jsonData = data![index]
                    let titleData = titleArray![index]
                    
                    donation.projectId = jsonData["projectId"].intValue
                    donation.id = jsonData["id"].intValue
                    donation.userId = self.userId
                    donation.name = jsonData["name"].stringValue
                    donation.phoneNum = jsonData["phoneNum"].stringValue
                    donation.donationMoney = jsonData["donationMoney"].floatValue
                    donation.status = jsonData["status"].intValue
                    donation.dateDonation = jsonData["dateDonation"].stringValue
                    donation.applicationOfMoney = jsonData["applicationOfMoney"].stringValue
                    donation.tradeNo = jsonData["tradeNo"].stringValue
                    donation.projectTitle = titleData["projectTitle"].stringValue
                    
                    self.dataArray.append(donation)
                    let path = NSIndexPath(forRow: self.hasShowNum, inSection: 0)
                    self.donationRecordTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                self.times++
                
                
            } else {
                
            }
        }
        
        self.donationRecordTableView.footer.state = MJRefreshStateIdle
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
            
        if self.times == 0 {
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            var context = appDelegate.managedObjectContext
            
            var fetchRequest = NSFetchRequest(entityName: "User")
            var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
            
            if fetchResult?.count > 0 {
                
                let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
                self.userId = obj.valueForKey("id") as! Int
                self.avatar = obj.valueForKey("avatar") as! String
                
                let paras = [
                    "userId" : self.userId,
                    "times" : 0,
                    "queryType" : 0
                ]
                
                Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryUserDonationRecord.php", parameters: paras)
                    .responseJSON { _, _, jsonResult, _ in
                        
                        // print(jsonResult)
                        
                        if (jsonResult != nil) {
                            let json = JSON(jsonResult!)
                            
                            let responseCode = json["code"].intValue
                            let responseInfo = json["info"].intValue
                            
                            
                            if responseInfo == 2 && responseCode == 200 {
                                var data : [JSON]? = json["data"].arrayValue
                                
                                var titleArray : [JSON]? = json["title"].arrayValue
                                
                                if (data != nil && data?.count > 0) {
                                    self.times = 1
                                    self.dataArray.removeAll(keepCapacity: true)
                                    self.hasShowNum = 0
                                    
                                    for index in 0..<data!.count {
                                        let donation = Donation()
                                        let jsonData = data![index]
                                        let titleData = titleArray![index]
                                        
                                        donation.projectId = jsonData["projectId"].intValue
                                        donation.id = jsonData["id"].intValue
                                        donation.userId = self.userId
                                        donation.name = jsonData["name"].stringValue
                                        donation.phoneNum = jsonData["phoneNum"].stringValue
                                        donation.donationMoney = jsonData["donationMoney"].floatValue
                                        donation.status = jsonData["status"].intValue
                                        donation.dateDonation = jsonData["dateDonation"].stringValue
                                        donation.applicationOfMoney = jsonData["applicationOfMoney"].stringValue
                                        donation.tradeNo = jsonData["tradeNo"].stringValue
                                        donation.projectTitle = titleData["projectTitle"].stringValue
                                        self.dataArray.append(donation)
                                        
                                    }
                                    self.donationRecordTableView.reloadData()
                                    self.donationRecordTableView.header.state = MJRefreshStateIdle
                                    
                                    
                                }
                            }
                        }
                }
                
            }
        }
        
    }
    
    // UITableView Delegate Datasourse
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !self.nibsRegistered {
            let nib = UINib(nibName: "DonationRecordTableViewCell", bundle: nil)
            self.donationRecordTableView.registerNib(nib, forCellReuseIdentifier: "donationRecord")
            self.nibsRegistered = true
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("donationRecord", forIndexPath: indexPath) as! DonationRecordTableViewCell
        let donation = self.dataArray[self.hasShowNum]
        cell.projectTitle.text = donation.projectTitle
        cell.donationMoney.text = "\(donation.donationMoney)"
        cell.applicationOfMoney.text = donation.applicationOfMoney
        
        // 设置为圆形头像显示
        cell.avatar.layer.cornerRadius = CGRectGetHeight(cell.avatar.bounds) / 2
        cell.avatar.layer.masksToBounds = true
        
        ImageLoader.sharedLoader.imageForUrl(self.avatar, completionHandler: { (image, url) -> () in
            cell.avatar.image = image
        })
        
        self.hasShowNum++
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(dataArray.count)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 107
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
