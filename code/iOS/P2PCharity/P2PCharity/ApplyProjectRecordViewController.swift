//
//  ApplyProjectRecordViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/4.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class ApplyProjectRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var projectTableView: UITableView!
    
    var projectArray = [Project]()
    var times = 0
    var queryType = 0
    var hasShowNum = 0
    var userId : Int!
    
    var avatar : String!
    
    var nibsRegistered = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.projectTableView.delegate = self
        self.projectTableView.dataSource = self
        
        self.projectTableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshAction:")
        
        self.projectTableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshAction:")
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
                
                Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryMyProject.php", parameters: paras)
                    .responseJSON { _, _, jsonResult, _ in
                        
                        //print(jsonResult)
                        
                        if (jsonResult != nil) {
                            let json = JSON(jsonResult!)
                            
                            let responseCode = json["code"].intValue
                            let responseInfo = json["info"].intValue
                            
                            
                            if responseInfo == 2 && responseCode == 200 {
                                var data : [JSON]? = json["data"].arrayValue
                                
                                if (data != nil && data?.count > 0) {
                                    self.times = 1
                                    self.projectArray.removeAll(keepCapacity: true)
                                    self.hasShowNum = 0
                                    
                                    for index in 0..<data!.count {
                                        let project = Project()
                                        let jsonData = data![index]
                                        
                                        project.id = jsonData["id"].intValue
                                        project.appealAddress = jsonData["appealAddress"].stringValue
                                        project.appealEnmergencyName = jsonData["appealEnmergencyName"].stringValue
                                        project.appealEnmergencyPhone = jsonData["appealEnmergencyPhone"].stringValue
                                        project.appealID = jsonData["appealID"].stringValue
                                        project.appealIncome = jsonData["appealIncome"].intValue
                                        project.appealName = jsonData["appealName"].stringValue
                                        project.appealPhone = jsonData["appealPhone"].stringValue
                                        project.appealSex = jsonData["appealSex"].boolValue
                                        project.priority = jsonData["priority"].doubleValue
                                        project.projectAddress = jsonData["projectAddress"].stringValue
                                        project.projectDonationTime = jsonData["projectDonationTime"].stringValue
                                        project.projectFailMsg = jsonData["projectFailMsg"].stringValue
                                        project.projectLeftMoney = jsonData["projectLeftMoney"].floatValue
                                        project.projectMoney = jsonData["projectMoney"].floatValue
                                        project.projectReason = jsonData["projectReason"].stringValue
                                        project.projectRequestDate = jsonData["projectRequestDate"].stringValue
                                        project.projectStatus = jsonData["projectStatus"].intValue
                                        project.projectTitle = jsonData["projectTitle"].stringValue
                                        project.projectType =  jsonData["projectType"].intValue
                                        project.projectWithdrawMoney = jsonData["projectWithdrawMoney"].floatValue
                                        project.proveMaterial = jsonData["proveMaterial"].stringValue
                                        project.spendDay = jsonData["spendDay"].intValue
                                        project.sponsorId = jsonData["sponsorId"].intValue
                                        
                                        self.projectArray.append(project)
                                        let path = NSIndexPath(forRow: self.hasShowNum, inSection: 0)
                                        self.projectTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                }
                
            }
        }
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
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryMyProject.php", parameters: paras)
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
            
            if (data != nil && data?.count > 0) {
                self.times = 1
                self.projectArray.removeAll(keepCapacity: true)
                self.hasShowNum = 0
                
                for index in 0..<data!.count {
                    let project = Project()
                    let jsonData = data![index]
                    
                    project.id = jsonData["id"].intValue
                    project.appealAddress = jsonData["appealAddress"].stringValue
                    project.appealEnmergencyName = jsonData["appealEnmergencyName"].stringValue
                    project.appealEnmergencyPhone = jsonData["appealEnmergencyPhone"].stringValue
                    project.appealID = jsonData["appealID"].stringValue
                    project.appealIncome = jsonData["appealIncome"].intValue
                    project.appealName = jsonData["appealName"].stringValue
                    project.appealPhone = jsonData["appealPhone"].stringValue
                    project.appealSex = jsonData["appealSex"].boolValue
                    project.priority = jsonData["priority"].doubleValue
                    project.projectAddress = jsonData["projectAddress"].stringValue
                    project.projectDonationTime = jsonData["projectDonationTime"].stringValue
                    project.projectFailMsg = jsonData["projectFailMsg"].stringValue
                    project.projectLeftMoney = jsonData["projectLeftMoney"].floatValue
                    project.projectMoney = jsonData["projectMoney"].floatValue
                    project.projectReason = jsonData["projectReason"].stringValue
                    project.projectRequestDate = jsonData["projectRequestDate"].stringValue
                    project.projectStatus = jsonData["projectStatus"].intValue
                    project.projectTitle = jsonData["projectTitle"].stringValue
                    project.projectType =  jsonData["projectType"].intValue
                    project.projectWithdrawMoney = jsonData["projectWithdrawMoney"].floatValue
                    project.proveMaterial = jsonData["proveMaterial"].stringValue
                    project.spendDay = jsonData["spendDay"].intValue
                    project.sponsorId = jsonData["sponsorId"].intValue
                    
                    self.projectArray.append(project)
                }
                
                //
                
                self.projectTableView.reloadData()
                
            } else {
                
            }
        }
        
        self.projectTableView.header.state = MJRefreshStateIdle
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
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryMyProject.php", parameters: paras)
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
                    let project = Project()
                    let jsonData = data![index]
                    
                    project.id = jsonData["id"].intValue
                    project.appealAddress = jsonData["appealAddress"].stringValue
                    project.appealEnmergencyName = jsonData["appealEnmergencyName"].stringValue
                    project.appealEnmergencyPhone = jsonData["appealEnmergencyPhone"].stringValue
                    project.appealID = jsonData["appealID"].stringValue
                    project.appealIncome = jsonData["appealIncome"].intValue
                    project.appealName = jsonData["appealName"].stringValue
                    project.appealPhone = jsonData["appealPhone"].stringValue
                    project.appealSex = jsonData["appealSex"].boolValue
                    project.priority = jsonData["priority"].doubleValue
                    project.projectAddress = jsonData["projectAddress"].stringValue
                    project.projectDonationTime = jsonData["projectDonationTime"].stringValue
                    project.projectFailMsg = jsonData["projectFailMsg"].stringValue
                    project.projectLeftMoney = jsonData["projectLeftMoney"].floatValue
                    project.projectMoney = jsonData["projectMoney"].floatValue
                    project.projectReason = jsonData["projectReason"].stringValue
                    project.projectRequestDate = jsonData["projectRequestDate"].stringValue
                    project.projectStatus = jsonData["projectStatus"].intValue
                    project.projectTitle = jsonData["projectTitle"].stringValue
                    project.projectType =  jsonData["projectType"].intValue
                    project.projectWithdrawMoney = jsonData["projectWithdrawMoney"].floatValue
                    project.proveMaterial = jsonData["proveMaterial"].stringValue
                    project.spendDay = jsonData["spendDay"].intValue
                    project.sponsorId = jsonData["sponsorId"].intValue
                    project.appealAvatar = jsonData["appealAvatar"].stringValue
                    
                    self.projectArray.append(project)
                    let path = NSIndexPath(forRow: self.hasShowNum, inSection: 0)
                    self.projectTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                self.times++
                
                
            } else {
                
            }
        }
        
        self.projectTableView.footer.state = MJRefreshStateIdle
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !self.nibsRegistered {
            let nib = UINib(nibName: "ApplyProjectRecordTableViewCellTableViewCell", bundle: nil)
            self.projectTableView.registerNib(nib, forCellReuseIdentifier: "applyProjectRecord")
            self.nibsRegistered = true
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("applyProjectRecord", forIndexPath: indexPath) as! ApplyProjectRecordTableViewCellTableViewCell
        
        let project = self.projectArray[self.hasShowNum]
        
        cell.name.text = project.appealName
        cell.sex.text = (project.appealSex == true) ? "男" : "女"
        cell.address.text = project.appealAddress
        cell.status.text = (30 - project.spendDay == 0) ? "已结束" : "进行中"
        
        let progress = Float((project.projectLeftMoney + project.projectWithdrawMoney)) / Float(project.projectMoney!)
        
        let p = String(format: "%.2f", progress)
        
        cell.progresss.progress = (p as NSString).floatValue
        cell.progressLabel.text = "\(cell.progresss.progress * 100)" + "%"
        cell.title.text = project.projectTitle
        
        if project.projectLeftMoney > 0 {
            cell.applyBtn.tag = self.hasShowNum
            cell.applyBtn.addTarget(self, action: "ApplyForMoney:", forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            cell.applyBtn.enabled = false
        }
        
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
        return self.projectArray.count
    }
    
    func ApplyForMoney(sender : UIButton) {
        // 进入提款申请页面
        // 发送通知
        let info = [
            "project" : self.projectArray[sender.tag]
        ]
        
        NSNotificationCenter.defaultCenter().postNotificationName("Notification_Apply_Money", object: nil, userInfo: info)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 159
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
