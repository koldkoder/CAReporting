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
    var currentValueString: String!
    var differenceVal: Double!
    var differenceValueString: String!
    var differencePercentage: Double!
    var type: String!
    
    init(dictionary: NSDictionary, defaultMetric: String, field: NSDictionary) {
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
        
        self.type = field["type"] as! String
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if(self.type != nil) {
            switch(self.type) {
            case "float":
                self.currentValueString =  formatter.stringFromNumber(self.currentVal)
                if self.differenceVal != nil {
                    if self.differenceVal >= 0 {
                        self.differenceValueString = formatter.stringFromNumber(self.differenceVal)
                    }
                    else {
                        self.differenceValueString = "-" + formatter.stringFromNumber(-1*self.differenceVal)!
                    }
                }
                break
            case "currency":
                self.currentValueString = "$" + formatter.stringFromNumber(self.currentVal)!
                if self.differenceVal != nil {
                    if self.differenceVal >= 0 {
                        self.differenceValueString = "$" + formatter.stringFromNumber(self.differenceVal)!
                    } else {
                        self.differenceValueString = "-$" + formatter.stringFromNumber(-1*self.differenceVal)!
                    }
                }
                break
            case "percent":
                self.currentValueString =  formatter.stringFromNumber(self.currentVal)! + "%"
                if self.differenceVal != nil {
                    if self.differenceVal >= 0 {
                        self.differenceValueString = formatter.stringFromNumber(self.differenceVal)! + "%"
                    } else {
                        self.differenceValueString = "-" + formatter.stringFromNumber(-1*self.differenceVal)! + "%"
                    }
                }
                break
            default:
                self.currentValueString = formatter.stringFromNumber(self.currentVal)
                if self.differenceVal != nil {
                    if self.differenceVal >= 0 {
                        self.differenceValueString = formatter.stringFromNumber(self.differenceVal)
                    } else {
                        self.differenceValueString = "-" + formatter.stringFromNumber(-1*self.differenceVal)!
                    }
                }
                break
            }
        }
        
    }
    
    class func summaryWithArray(dict: NSDictionary) -> [Summary] {
        var summaries = [Summary]()
        let defaultMetric = dict["defaultMetric"] as! String
        let dictArray = dict["data"] as! [NSDictionary]
        let fieldDescription = dict["fieldDescription"] as! NSDictionary
        let field = fieldDescription[defaultMetric] as! NSDictionary
        for dictionary in dictArray {
            summaries.append(Summary(dictionary: dictionary, defaultMetric: defaultMetric, field: field))
        }
        return summaries
    }
    
}