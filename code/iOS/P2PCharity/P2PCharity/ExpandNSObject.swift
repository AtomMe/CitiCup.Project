//
//  ExpandNSObject.swift
//  P2PCharity
//
//  Created by 李冬 on 15/9/9.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import Foundation

extension NSObject
{
    func performSelectorOnMainThread(selector aSelector: Selector,withObject object:AnyObject! ,waitUntilDone wait:Bool)
    {
        if self.respondsToSelector(aSelector)
        {
            var continuego = false
            let group = dispatch_group_create()
            let queue = dispatch_queue_create("com.fsh.dispatch", nil)
            dispatch_group_async(group,queue,{
                dispatch_async(queue ,{
                    //做了个假的
                    NSThread.detachNewThreadSelector(aSelector, toTarget:self, withObject: object)
                    continuego = true
                })
            })
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
            
            if wait
            {
                let ret = NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture() as! NSDate)
                while (!continuego && ret)
                {
                    
                }
            }
        }
    }
}