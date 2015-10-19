//
//  User.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import Foundation
import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var dictionary: NSDictionary?
    //var profileImageUrl: String?


    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String
        self.dictionary = dictionary
    }

    
    func logout() {
        User.currentUser = nil
    }
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if let data = data {
        let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
        _currentUser = User(dictionary: dictionary!)
        }
        }
        return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                let data =  try! NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: [])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
        }
    }
}