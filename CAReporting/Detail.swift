//
//  Detail.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import Foundation


class Detail: NSObject {
    var key: String!
    var displayString: String!
    var value: Double!
    var type: String!
    var valueString: String!
    var data: [NSDictionary]!

    init(key: String, value: Double, fieldDescription: NSDictionary, data: [NSDictionary]) {
        self.displayString = fieldDescription["displayString"] as! String
        self.value = value
        let type = fieldDescription["type"] as! String
        self.type = type
        self.key = key
        self.data = data
    }
    
    func setValueString() {
        self.valueString = getValueString(self.value)
    }
    
    func hasGraph() -> Bool {
        return self.data.count > 1
    }
    
    func getValueString(value: Double) -> String {
        var string = ""
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        if self.type != nil {
            switch(self.type) {
            case "float":
                string = formatter.stringFromNumber(value)!
                break
            case "currency":
                string = "$" + formatter.stringFromNumber(value)!
                break
            case "percent":
                string =  formatter.stringFromNumber(value)! + "%"
                break
            default:
                string = formatter.stringFromNumber(value)!
                break
            }
        }
        return string

    }
    
    class func detailWithArray(dict: NSDictionary) -> [Detail] {
        var details = [Detail]()
        let fieldDescription = dict["fieldDescription"] as! NSDictionary
        let summary = dict["summary"] as! NSDictionary
        let data = dict["data"] as! [NSDictionary]
        for (key, fieldData) in fieldDescription {
            let value = summary[key as! String]
            if (value != nil) {
                let detail = Detail(key: key as! String, value: value as! Double, fieldDescription: fieldData as! NSDictionary, data: data)
                detail.setValueString()
                details.append(detail)
            }
        }
        return details
    }
    
}