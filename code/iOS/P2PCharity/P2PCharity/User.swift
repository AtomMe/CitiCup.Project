//
//  User.swift
//  P2PCharity
//
//  Created by 李冬 on 15/8/21.
//  Copyright (c) 2015年 李冬. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var authenticationFail: NSNumber
    @NSManaged var authenticationFailMsg: String
    @NSManaged var authenticationRequest: NSNumber
    @NSManaged var dateRequest: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var iDPhone: String
    @NSManaged var isActive: NSNumber
    @NSManaged var isAuthentication: NSNumber
    @NSManaged var nick: String
    @NSManaged var password: String
    @NSManaged var phoneNum: String
    @NSManaged var realID: String
    @NSManaged var realName: String
    @NSManaged var username: String
    @NSManaged var avatar: String

}
