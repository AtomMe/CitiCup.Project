//
//  NearsProjectViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/30.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class NearsProjectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, CLLocationManagerDelegate {
    @IBOutlet var projectCollectionView: UICollectionView!
    
    var nibsRegistered = false
    
    var times = 0
    var queryType = 0  // 下拉0 上拉1
    
    var hasShowProjectNums = 0
    
    var allProject = [Project]()
    
    var searchFlag = false
    
    var longitude : String!
    var latitude : String!
    
    var first = true
    
    var currLocation : CLLocation!
    //用于定位服务管理类，它能够给我们提供位置信息和高度信息，也可以监控设备进入或离开某个区域，还可以获得设备的运行方向
    let locationManager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchBarTextChanged:", name: "ProjectViewSearchBarTextChanged", object: nil)
        
        self.projectCollectionView.delegate = self
        self.projectCollectionView.dataSource = self
        
        self.projectCollectionView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshAction:")
        self.projectCollectionView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshAction:")
        
        setupCollectionView()
        
        self.registerNibs()
        
        self.locationManager.delegate = self
        //设备使用电池供电时最高的精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        println("定位开始")
        
    }
    
    func headerRefreshAction(sneder : AnyObject) {
        print("正在刷新")
        
        // self.projectTableView.header.state = MJRefreshStateIdle
        
        // 请求重新加载数据
        let paras = [
            "times" : 0,
            "queryType" : 0,
            "longitude" : (self.longitude == nil) ? "0" : self.longitude,
            "latitude" : (self.latitude == nil) ? "0" : self.latitude
        ]
        
        // 发送请求
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryNearsSortedProject.php", parameters: paras as? [String : AnyObject])
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
            "queryType" : 1,
            "longitude" : self.longitude,
            "latitude" : self.latitude
        ]
        
        // 发送请求
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryNearsSortedProject.php", parameters: paras as? [String : AnyObject])
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
    
    // 获取到定位信息
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        
        currLocation = locations.last as! CLLocation
        self.longitude = "\(currLocation.coordinate.longitude)"
        self.latitude = "\(currLocation.coordinate.latitude)"
        print(self.longitude)
        print("\n")
        print(self.latitude)
        
        if self.first {
            self.first = false
            self.loadFirstAppearData()
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // 请求加载数据
        // print("Viewwillappear")
    }
    
    func loadFirstAppearData() {
        
        print("正在加载第一次数据")
        
        if self.times == 0 {
            let paras = [
                "times" : self.times,
                "queryType" : 0,
                "longitude" : self.longitude,
                "latitude" : self.latitude
            ]
            
            // 发送请求
            Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/QueryNearsSortedProject.php", parameters: paras as? [String : AnyObject])
                .responseJSON { _, _, jsonResult, _ in
                    
                    print(jsonResult)
                    
                    if (jsonResult != nil) {
                        
                        
                        
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
        
        let h = 55
        let x = 0
        
        
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
        
        NSNotificationCenter.defaultCenter().postNotificationName("Notification_Nears_Project_TableViewCell_Clicked", object: nil, userInfo: info)
        
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
