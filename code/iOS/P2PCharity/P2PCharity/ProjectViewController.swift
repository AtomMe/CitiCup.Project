//
//  ProjectViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/12.
//  Copyright © 2015年 李冬. All rights reserved.
//

import UIKit
import CoreData

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate {

    @IBOutlet var raiseProject: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!
    
    var selectedBtn : UIButton!
    
    var scrollView : UIScrollView!
    
    let KScreenHeight = UIScreen.mainScreen().bounds.size.height
    let KScreenWidth = UIScreen.mainScreen().bounds.size.width
    
    
//    @IBOutlet var projectTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("屏幕宽度：\(KScreenWidth)")
        print("\n屏幕高度：\(KScreenHeight)")
        
        let searchOrigin = searchBar.frame.origin
        let searchSize = searchBar.frame.size
        
        for obj in self.searchBar.subviews[0].subviews {
            if obj is UIButton {
                let btn = obj as! UIButton
                btn.addTarget(self, action: "searchBarCancleClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        
        self.searchBar.delegate = self
        
        let nameArray = ["附近", "全部"]
        
        let backgroundView = UIImageView(frame: CGRectMake(0, searchOrigin.y + searchSize.height, KScreenWidth, 40))
        backgroundView.image = UIImage(named: "table-mid.png")
        self.view.addSubview(backgroundView)
        
        for index in 0...(nameArray.count - 1) {
            
            var btn = UIButton(frame: CGRectMake(CGFloat(0 + index*(Int(KScreenWidth)/(nameArray.count))), searchOrigin.y + searchSize.height, CGFloat(Int(KScreenWidth)/(nameArray.count)), CGFloat(40)))
            
            btn.setTitle(nameArray[index], forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
            
            btn.setBackgroundImage(UIImage(named: "red_line_and_shadow.png"), forState: UIControlState.Selected)
            
            btn.tag = 200 + index
            
            if index == 0 {
                btn.selected = true
                self.selectedBtn = btn
            }
            
            btn.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(btn)
            
        }
        
        scrollView = UIScrollView(frame: CGRectMake(0, searchOrigin.y + searchSize.height + 40, KScreenWidth, KScreenHeight - 20 - searchOrigin.y - searchSize.height - 40))
        scrollView.contentSize = CGSizeMake(CGFloat(Int(KScreenWidth) * nameArray.count), KScreenHeight - 20 - searchOrigin.y - searchSize.height - 40)
        
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        self.view.addSubview(scrollView)
        
        let nearsController = NearsProjectViewController(nibName: "NearsProjectViewController", bundle: nil)
        
        nearsController.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 20 - searchOrigin.y - searchSize.height - 40)

        
        let allProjectController = AllProjectViewController(nibName: "AllProjectViewController", bundle: nil)
        allProjectController.view.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight - 20 - searchOrigin.y - searchSize.height - 40)
        
        self.addChildViewController(nearsController)
        self.addChildViewController(allProjectController)
        
        scrollView.addSubview(nearsController.view)
        self.scrollView.addSubview(allProjectController.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "allProjectTableViewCellClicked:", name: "Notification_All_Project_TableViewCell_Clicked", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "nearsProjectTableViewCellClicked:", name: "Notification_Nears_Project_TableViewCell_Clicked", object: nil)
    }
    
    // UISearchBar的取消按钮点击事件
    func searchBarCancleClicked(sender : UIButton) {
        self.searchBar.resignFirstResponder()
    }
    
    func allProjectTableViewCellClicked(aNotification : NSNotification) {
        print("收到了消息")
        
        // 解析参数，执行跳转
        let info = aNotification.userInfo
        // print(info!["project" as NSObject])
        
        let project : Project = info!["project"] as! Project
        
        let detailProjectController: ProjectDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProjectDetail") as! ProjectDetailViewController
        
        detailProjectController.project = project
        
        self.navigationController?.pushViewController(detailProjectController, animated: true)
    }
    
    func nearsProjectTableViewCellClicked(aNotification : NSNotification) {
        // 解析参数，执行跳转
        let info = aNotification.userInfo
        // print(info!["project" as NSObject])
        
        let project : Project = info!["project"] as! Project
        
        let detailProjectController: ProjectDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProjectDetail") as! ProjectDetailViewController
        
        detailProjectController.project = project
        
        self.navigationController?.pushViewController(detailProjectController, animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let tag = scrollView.contentOffset.x / KScreenWidth
        let btn = self.view.viewWithTag( Int(200 + tag) ) as! UIButton

        self.btnAction(btn)
        
    }
    
    func btnAction (sender: AnyObject) {
        if (self.selectedBtn != nil) {
            self.selectedBtn.selected = false
        }
        
        (sender as! UIButton).selected = true
        self.selectedBtn = sender as! UIButton
        
        scrollView.contentOffset = CGPointMake(CGFloat((sender.tag - 200) * Int(KScreenWidth)), CGFloat(0))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("project", forIndexPath: indexPath) as! ProjectTableViewCell
        
        cell.projectProgress.progress = 0.82
        
        return cell
    }
    
    // UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        var hasText : Bool!
        if searchText.isEmpty {
            hasText = false
        } else {
            hasText = true
        }
        
        let info = [
            "hasText" : hasText,
            "searchText" : (searchText.isEmpty) ? "Empty" : searchText
        ]
        
        NSNotificationCenter.defaultCenter().postNotificationName("ProjectViewSearchBarTextChanged", object: nil, userInfo: info as [NSObject : AnyObject])
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func launchProject(sender: AnyObject) {
        // 检查当前用户是否已经登陆
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchResult?.count > 0 {
            let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
            
            let isAuthentication = obj.valueForKey("isAuthentication") as! Bool
            // 已经认证
            if isAuthentication {
                let launchBasicController = self.storyboard?.instantiateViewControllerWithIdentifier("launchProject") as! LaunchProjectViewController
                self.navigationController?.pushViewController(launchBasicController, animated: true)
            } else {
                let alert = UIAlertView()
                alert.title = "提示"
                alert.message = "您还没有进行实名认证，无法发起项目"
                alert.addButtonWithTitle("确定")
                alert.show()
            }
            
        } else {
            let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
            self.navigationController?.pushViewController(loginController, animated: true)
        }
    }
    

}
