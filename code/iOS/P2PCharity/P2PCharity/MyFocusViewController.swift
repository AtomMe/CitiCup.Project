//
//  MyFocusViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/8.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class MyFocusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var myFocusTableView: UITableView!
    
    var nibsRegistered = false
    
    var times = 0
    var queryType = 0  // 下拉0 上拉1
    
    var hasShowProjectNums = 0
    
    var dataArray = [Project]()
    
    var userId : Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.myFocusTableView.delegate = self
        self.myFocusTableView.dataSource = self
        
        self.myFocusTableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshAction:")
        
        self.myFocusTableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshAction:")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/GetMyFocusData.php", parameters: paras)
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
        
        
        if responseInfo == 4 && responseCode == 200 {
            var data : [JSON]? = json["data"].arrayValue
            
            if (data != nil && data?.count > 0) {
                self.times = 1
                self.dataArray.removeAll(keepCapacity: true)
                self.hasShowProjectNums = 0
                
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
                    
                    project.appealAvatar = jsonData["avatar"].stringValue
                    
                    self.dataArray.append(project)
                    // let path = NSIndexPath(forRow: self.hasShowProjectNums, inSection: 0)
                    // self.allProjectTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                //
                
                self.myFocusTableView.reloadData()
                
            } else {
                
            }
        }
        
        self.myFocusTableView.header.state = MJRefreshStateIdle
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
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/GetMyFocusData.php", parameters: paras)
            .responseJSON { _, _, jsonResult, _ in
                // print(jsonResult)
                
                var json = JSON(jsonResult!)
                
                self.handleFooterRefreshResult(json)
        }
        
    }
    
    func handleFooterRefreshResult(json : JSON) {
        
        let responseCode = json["code"].intValue
        let responseInfo = json["info"].intValue
        
        
        if responseInfo == 5 && responseCode == 200 {
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
                    
                    project.appealAvatar = jsonData["avatar"].stringValue
                    
                    self.dataArray.append(project)
                    let path = NSIndexPath(forRow: self.hasShowProjectNums, inSection: 0)
                    self.myFocusTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                self.times++
                
                
            } else {
                
            }
        }
        
        self.myFocusTableView.footer.state = MJRefreshStateIdle
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            self.userId = obj.valueForKey("id") as! Int
        }
        
        if self.times == 0 {
            let paras = [
                "userId" : self.userId,
                "times" : self.times,
                "queryType" : 0
            ]
            
            // 发送请求
            Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/GetMyFocusData.php", parameters: paras)
                .responseJSON { _, _, jsonResult, _ in
                    if (jsonResult != nil) {
                        
                        // print(jsonResult)
                        
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
                    let project = Project()
                    let jsonData = data![index]
                    
                    project.id = jsonData["projectId"].intValue
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
                    
                    project.appealAvatar = jsonData["avatar"].stringValue
                    
                    self.dataArray.append(project)
                    let path = NSIndexPath(forRow: self.hasShowProjectNums, inSection: 0)
                    self.myFocusTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                //
                self.times++
                
                
            } else {
                return
            }
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 153
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if !self.nibsRegistered {
            let nib = UINib(nibName: "ProjectTableViewCell", bundle: nil)
            self.myFocusTableView.registerNib(nib, forCellReuseIdentifier: "project")
            self.nibsRegistered = true
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("project", forIndexPath: indexPath) as! ProjectTableViewCell
        
        // cell.projectProgress.progress = 0.82
        
        let project = self.dataArray[self.hasShowProjectNums]
        
        cell.projectRaiserName.text = project.appealName
        cell.projectRaiserSex.text = (project.appealSex == true) ? "男" : "女"
        cell.projectRaiserAddress.text = project.appealAddress
        cell.projectLeftTime.text = "\(30 - project.spendDay)"
        
        let progress = Float((project.projectLeftMoney + project.projectWithdrawMoney)) / Float(project.projectMoney!)
        
        let p = String(format: "%.2f", progress)
        
        cell.projectProgress.progress = (p as NSString).floatValue
        
        cell.projectProgressLabel.text = "\(cell.projectProgress.progress * 100)" + "%"
        cell.projectReason.text = project.projectTitle
        
        // 设置为圆形头像显示
        cell.projectRaiserAvatar.layer.cornerRadius = CGRectGetHeight(cell.projectRaiserAvatar.bounds) / 2
        cell.projectRaiserAvatar.layer.masksToBounds = true
        
        ImageLoader.sharedLoader.imageForUrl(project.appealAvatar, completionHandler: { (image, url) -> () in
            cell.projectRaiserAvatar.image = image
        })
        
        
        self.hasShowProjectNums++
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            print(indexPath.row)
            
            // 删除对应的数据
            
            self.UpdateFavoriteTable(indexPath.row, projectId: self.dataArray[indexPath.row].id)
            self.dataArray.removeAtIndex(indexPath.row)
            self.myFocusTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func UpdateFavoriteTable(row : Int, projectId : Int) {
        let paras = [
            "userId" : self.userId,
            "projectId" : projectId
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
                        
                    }
                }
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let project = self.dataArray[indexPath.row]
        let detailProjectController: ProjectDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProjectDetail") as! ProjectDetailViewController
        
        detailProjectController.project = project
        
        self.navigationController?.pushViewController(detailProjectController, animated: true)
        
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
