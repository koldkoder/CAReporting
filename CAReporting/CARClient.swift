//
//  CARClient.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

class CARClient {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    class var sharedInstance: CARClient {
        struct Static {
            static let instance = CARClient()
        }
        return Static.instance
    }
    
    
    func loginWithCompletion(params: NSDictionary, completion: (user:User?, error: NSError?) -> ()) {
        loginCompletion = completion
        var namesDictionary: Dictionary<String, String> = [:]
        namesDictionary["name"] = "DefaultUser"
        let user = User(dictionary: namesDictionary)
        User.currentUser = user
        self.loginCompletion?(user:user, error:nil)
    }
    
    func getSummary(url: String, completion:(summaries: [Summary]?, error: NSError?) -> ()) {
        AFHTTPRequestOperationManager().GET(url, parameters: nil, success: { (opearation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let summaries = Summary.summaryWithArray(response as! NSDictionary)
            completion(summaries: summaries, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error getting Summary from url", error)
                completion(summaries: nil, error: error)
        })
        
    }
    
}