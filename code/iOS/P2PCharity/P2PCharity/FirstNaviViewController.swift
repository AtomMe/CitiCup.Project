//
//  FirstNaviViewController.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/9.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import UIKit

class FirstNaviViewController: UIViewController {
    
    var defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("这是一个测试")
        
        let flag  : Bool? = defaults.valueForKey("flag") as? Bool
        
        if let first = flag {
            // 不为空
            print("\n")
            print("不为空")
            if flag! {
                
            } else {
                print("\n")
                print("false")
                let timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "presentViewController:", userInfo: nil, repeats: false)
                //NSThread.performSelector("presentViewController:", onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: false)
            }
        } else {
            print("\n")
            print("为空")
            let item1 = RMParallaxItem(image: UIImage(named: "icon-navi-1")!, text: "VIEW NEARBY ASSISTANCE PROJECT")
            let item2 = RMParallaxItem(image: UIImage(named: "icon-navi-2")!, text: "SHARE PROJECT FOR HELP")
            let item3 = RMParallaxItem(image: UIImage(named: "icon-navi-3")!, text: "CHECK THE APPLICATION OF FUNDS FOR DONATION")
            let item4 = RMParallaxItem(image: UIImage(named: "icon-navi-4")!, text: "ALIPAY TO ENSURE THE SAFETY OF FUNDS")
            
            let rmParallaxViewController = RMParallax(items: [item1, item2, item3, item4], motion: false)
            rmParallaxViewController.completionHandler = {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    // rmParallaxViewController.view.alpha = 0.0
                    
                    print("\n")
                    print("clicked")
                    
                    self.defaults.setBool(false, forKey: "flag")
                    
                    let controller: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! UIViewController
                    
                    self.presentViewController(controller, animated: true, completion: { () -> Void in
                        
                    })
                })
            }
            
            // Adding parallax view controller.
            self.addChildViewController(rmParallaxViewController)
            self.view.addSubview(rmParallaxViewController.view)
            rmParallaxViewController.didMoveToParentViewController(self)
        }
        
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func presentViewController(sender : AnyObject) {
        print("\n")
        print("调用了")
        
        let controller: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! UIViewController
        
        self.presentViewController(controller, animated: true, completion: { () -> Void in
            
        })
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

}
