//
//  AllProjectViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/31.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AllProjectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    @IBOutlet var projectCollectionView: UICollectionView!
    var nibsRegistered = false
    
    var times = 0
    var queryType = 0  // 下拉0 上拉1
    
    var hasShowProjectNums = 0
    
    var allProject = [Project]()
    
    var searchProject = [Project]()
    
    var searchFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.projectCollectionView.delegate = self
        self.projectCollectionView.dataSource = self
        
        self.projectCollectionView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshAction:")
        self.projectCollectionView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshAction:")
        
        setupCollectionView()
        
        self.registerNibs()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchBarTextChanged:", name: "ProjectViewSearchBarTextChanged", object: nil)
        
    }
    
    func headerRefreshAction(sneder : AnyObject) {
        print("正在下拉刷新")
        // 请求重新加载数据
        let paras = [
            "times" : 0,
            "queryType" : 0
        ]
        
        // 发送请求
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryAllSortedProject.php", parameters: paras)
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
            var avatar : [JSON]? = json["avatar"].arrayValue
            
            if (data != nil && data?.count > 0) {
                self.times = 1
                self.allProject.removeAll(keepCapacity: true)
                self.hasShowProjectNums = 0
                
                for index in 0..<data!.count {
                    let project = Project()
                    let jsonData = data![index]
                    let avatarData = avatar![index]
                    
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
                    
                    project.appealAvatar = avatarData["avatar"].stringValue
                    
                    project.imageWidth = jsonData["imageWidth"].floatValue
                    project.imageHeight = jsonData["imageHeight"].floatValue
                    
                    self.allProject.append(project)
                    // let path = NSIndexPath(forRow: self.hasShowProjectNums, inSection: 0)
                    // self.allProjectTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                //
                
                self.projectCollectionView.reloadData()
                
            } else {
                
            }
        }
        
        self.projectCollectionView.header.state = MJRefreshStateIdle
    }
    
    func footerRefreshAction(sender : AnyObject) {
        print("正在上拉刷新")
        print(self.times)
        
        // 请求重新加载数据
        let paras = [
            "times" : self.times,
            "queryType" : 1
        ]
        
        // 发送请求
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryAllSortedProject.php", parameters: paras)
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
            var avatar : [JSON]? = json["avatar"].arrayValue
            
            if (data != nil && data?.count > 0) {
                
                for index in 0..<data!.count {
                    let project = Project()
                    let jsonData = data![index]
                    let avatarData = avatar![index]
                    
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
                    
                    project.appealAvatar = avatarData["avatar"].stringValue
                    
                    project.imageWidth = jsonData["imageWidth"].floatValue
                    project.imageHeight = jsonData["imageHeight"].floatValue
                    
                    self.allProject.append(project)
                    let path = NSIndexPath(forRow: self.hasShowProjectNums, inSection: 0)
                    self.projectCollectionView.insertItemsAtIndexPaths([path])
                }
                
                self.times++
                
                
            } else {
                
            }
        }
        
        self.projectCollectionView.footer.state = MJRefreshStateIdle
        
    }
    
    func setupCollectionView(){
        
        // Create a waterfall layout
        var layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        // Collection view attributes
        self.projectCollectionView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        self.projectCollectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.projectCollectionView.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNibs(){
        
        // attach the UI nib file for the ImageUICollectionViewCell to the collectionview
        var viewNib = UINib(nibName: "ProjectCollectionViewCellCollectionViewCell", bundle: nil)
        self.projectCollectionView.registerNib(viewNib, forCellWithReuseIdentifier: "projectCell")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        if self.times == 0 {
            let paras = [
                "times" : self.times,
                "queryType" : self.queryType
            ]
            
            // 发送请求
            Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryAllSortedProject.php", parameters: paras)
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
        
        
        if responseInfo == 4 && responseCode == 200 {
            var data : [JSON]? = json["data"].arrayValue
            var avatar : [JSON]? = json["avatar"].arrayValue
            
            if (data != nil && data?.count > 0) {
                
                for index in 0..<data!.count {
                    let project = Project()
                    let jsonData = data![index]
                    let avatarData = avatar![index]
                    
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
                    
                    project.appealAvatar = avatarData["avatar"].stringValue
                    
                    project.imageWidth = jsonData["imageWidth"].floatValue
                    project.imageHeight = jsonData["imageHeight"].floatValue
                    
                    self.allProject.append(project)
                    let path = NSIndexPath(forRow: self.hasShowProjectNums, inSection: 0)
                    // self.allProjectTableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Automatic)
                    // self.projectCollectionView.insertItemsAtIndexPaths([path])
                }
                
                // 
                self.times++
                self.projectCollectionView.reloadData()
                
            } else {
                return
            }
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allProject.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("projectCell", forIndexPath: indexPath) as! ProjectCollectionViewCellCollectionViewCell
        
        let project = self.allProject[indexPath.row]
        var proveMaterial = project.proveMaterial
        if proveMaterial != nil {
            let array = proveMaterial.componentsSeparatedByString(";");
            ImageLoader.sharedLoader.imageForUrl(array[0], completionHandler: { (image, url) -> () in
                cell.projectBackImageView.image = image
            })
        }
        
        
        cell.projectTitleLabel.text = project.projectTitle
        
        self.hasShowProjectNums++
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        // create a cell size from the image size, and return the size
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProjectCollectionViewCellCollectionViewCell
//        let imageSize = cell.projectBackImageView.image?.size
        let project = self.allProject[indexPath.row]
        print("\n")
        print(project.imageWidth)
        print("\n")
        print(project.imageHeight)
        return CGSizeMake(CGFloat(project.imageWidth), CGFloat(project.imageHeight))
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let info = [
            "project" : self.allProject[indexPath.row]
        ]
        
        NSNotificationCenter.defaultCenter().postNotificationName("Notification_All_Project_TableViewCell_Clicked", object: nil, userInfo: info)
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
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
