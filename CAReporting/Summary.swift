//
//  Summary.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import Foundation


class Summary: NSObject {
    var key: String!
    var displayString: String!
    var currentVal: Double!
    var differenceVal: Double!
    var differencePercentage: Double!
    
    init(dictionary: NSDictionary, defaultMetric: String) {
        key = dictionary["key"] as! String
        displayString = dictionary["displayString"] as! String
        //let data = dictionary["data"] as! NSDictionary
        let current = dictionary["current"] as! NSDictionary
        currentVal = current[defaultMetric] as! Double
        let difference = dictionary["difference"] as? NSDictionary
        if let _ = difference {
            differenceVal = difference![defaultMetric] as! Double
            differencePercentage = differenceVal/currentVal * 100
        }
        
    }
    
    class func summaryWithArray(dict: NSDictionary) -> [Summary] {
        var summaries = [Summary]()
        let defaultMetric = dict["defaultMetric"] as! String
        let dictArray = dict["data"] as! [NSDictionary]
        for dictionary in dictArray {
            summaries.append(Summary(dictionary: dictionary, defaultMetric: defaultMetric))
        }
        return summaries
    }
    
}