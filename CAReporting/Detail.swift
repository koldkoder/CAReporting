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
        self.type = fieldDescription["type"] as! String
        self.key = key
        if(self.type != nil) {
            switch(self.type) {
                case "float":
                    self.valueString = String(format: "%.2f", self.value)
                    break
                case "currency":
                    self.valueString = "$" + String(format: "%.2f", self.value)
                    break
                case "percent":
                    self.valueString = String(format: "%.2f", self.value) + "%"
                    break
                default:
                    self.valueString = String(format: "%.0f", self.value)
                    break
            }
        }
        self.data = data
    }
    
    func hasGraph() -> Bool {
        return self.data.count > 1
    }
    
    class func detailWithArray(dict: NSDictionary) -> [Detail] {
        var details = [Detail]()
        let fieldDescription = dict["fieldDescription"] as! NSDictionary
        let summary = dict["summary"] as! NSDictionary
        let data = dict["data"] as! [NSDictionary]
        for (key, fieldData) in fieldDescription {
            let value = summary[key as! String]
            if (value != nil) {
                details.append(Detail(key: key as! String, value: value as! Double, fieldDescription: fieldData as! NSDictionary, data: data))
            }
        }
        return details
    }
    
}