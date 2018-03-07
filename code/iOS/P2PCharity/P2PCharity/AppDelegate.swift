//
//  AppDelegate.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/16.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate, WXApiDelegate {

    var window: UIWindow?
    
    var username : String?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        BmobPaySDK.registerWithAppKey("13e3124ccb4b3dd820abd9886337ed27")
        
        WXApi.registerApp("wx91ab3e743811fe3b")
        
        YouTuiSDK.connectYouTuiSDKWithAppId("148392", appSecret: "a6e8249cc8dba1b", inviteCode: nil, appUserId: "deeplee1136")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            var context = appDelegate.managedObjectContext
            
            var fetchRequest = NSFetchRequest(entityName: "User")
            var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
            
            if fetchResult?.count > 0 {
                
                
                let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
                
                self.username = obj.valueForKey("username") as? String
                
                let paras = [
                    "username" : self.username!
                ]
                
                Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/GetUserInfo.php", parameters: paras)
                    .responseJSON { _, _, jsonResult, _ in
                        // 解析JSON
                        if jsonResult == nil {
                            return
                        }
                        
                        var json = JSON(jsonResult!)
                        
                        let responseCode = json["code"].intValue
                        let responseInfo = json["info"].intValue
                        
                        if responseCode == 200 && responseInfo == 2 {
                            
                            self.saveUserDataToLocalDataBase(json)
                            
                            var fetchRequest2 = NSFetchRequest(entityName: "User")
                            var fetchResult2 = context?.executeFetchRequest(fetchRequest2, error: nil)
                            
                            if fetchResult2?.count > 0 {
                                
                                
                                let obj2: NSManagedObject = fetchResult2![0] as! NSManagedObject
                                
                                let isAuthentication = obj2.valueForKey("isAuthentication") as! Bool
                                
                                if !isAuthentication {
                                    
                                    
                                    let authenticationFail = obj2.valueForKey("authenticationFail") as! Bool
                                    
                                    if !authenticationFail {
                                        
                                        if let authenticationFailMsg = obj2.valueForKey("authenticationFailMsg") as? String {
                                            // 回到主线程
                                            dispatch_async(dispatch_get_main_queue()) {
                                                
                                                
                                                let alert = UIAlertView()
                                                alert.title = "提示"
                                                alert.message = "认证失败！\n" + authenticationFailMsg
                                                alert.addButtonWithTitle("确认")
                                                alert.show()
                                                
                                                
                                            }
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                }
                
            }
            
        }
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        
        return true
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        // 更新用户信息
        
        let paras = [
            "username" : self.username!
        ]
        
        Alamofire.request(.GET, "http://123.56.91.235/Charity4Client/AuthenticationRestartNeed.php", parameters: paras)
            .responseJSON { _, _, jsonResult, _ in
            
                // 解析JSON
                var json = JSON(jsonResult!)
                
                let responseCode = json["code"].intValue
                let responseInfo = json["info"].intValue
                
                if responseCode == 200 && responseInfo == 1 {
                    
                    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    var context = appDelegate.managedObjectContext
                    
                    var fetchRequest = NSFetchRequest(entityName: "User")
                    var fetchResult = context?.executeFetchRequest(fetchRequest, error: nil)
                    
                    if fetchResult?.count > 0 {
                        
                        
                        let obj: NSManagedObject = fetchResult![0] as! NSManagedObject
                        obj.setValue(false, forKey: "isAuthentication")
                        obj.setValue(false, forKey: "authenticationRequest")
                        
                        var error : NSError?
                        if (appDelegate.managedObjectContext?.save(&error) != nil) {
                            
                        }
                        
                    }
                }
                
        }
    }
    
    
    func saveUserDataToLocalDataBase(userInfo : JSON) {
        // 将用户信息存到本地数据库
        if (userInfo != nil) {
            
            deleteLocalData()
            
            
            var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //获取appdel
            var context = appDelegate.managedObjectContext //获取存储的上下文
            
            var entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context!)
            var user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)// 这里如果做了转型的话其实也可以直接类似类的属性进行赋值一样
            
            user.setValue(userInfo["data"]["id"].intValue, forKey: "id")
            
            user.setValue(userInfo["data"]["isActive"].boolValue, forKey: "isActive")
            user.setValue(userInfo["data"]["isAuthentication"].boolValue, forKey: "isAuthentication")
            user.setValue(userInfo["data"]["nick"].stringValue, forKey: "nick")
            user.setValue(userInfo["data"]["password"].stringValue, forKey: "password")
            user.setValue(userInfo["data"]["username"].stringValue, forKey: "username")
            user.setValue(userInfo["data"]["realName"].stringValue, forKey: "realName")
            
            user.setValue(userInfo["data"]["realID"].stringValue, forKey: "realID")
            user.setValue(userInfo["data"]["phoneNum"].stringValue, forKey: "phoneNum")
            user.setValue(userInfo["data"]["authenticationRequest"].boolValue, forKey: "authenticationRequest")
            
            
            user.setValue(userInfo["data"]["authenticationFail"].boolValue, forKey: "authenticationFail")
            user.setValue(userInfo["data"]["authenticationFailMsg"].stringValue, forKey: "authenticationFailMsg")
            user.setValue(userInfo["data"]["avatar"].stringValue, forKey: "avatar")
            
            
            var error : NSError?
            if (appDelegate.managedObjectContext?.save(&error) != nil) {
                
            }
        }
    }
    
    func deleteLocalData() {
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //获取appdel
        var context = appDelegate.managedObjectContext //获取存储的上下文
        
        let description = NSEntityDescription.entityForName("User", inManagedObjectContext: context!)
        
        let request = NSFetchRequest()
        
        request.includesPropertyValues = false
        request.entity = description
        
        var error : NSError?
        
        let data = context?.executeFetchRequest(request, error: &error)
        
        if let result = data {
            
            for obj in result {
                context?.deleteObject(obj as! NSManagedObject)
                
                if (context?.save(&error) != nil) {
                    
                }
            }
            
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.deep.lee.P2PCharity" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("P2PCharity", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("P2PCharity.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDic) -> Void in
                
            })
        }
        
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    

}

