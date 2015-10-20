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

    init(value: Double, fieldDescription: NSDictionary) {
        self.displayString = fieldDescription["displayString"] as! String
        self.value = value
        self.type = fieldDescription["type"] as! String
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
    }
    
    class func detailWithArray(dict: NSDictionary) -> [Detail] {
        var details = [Detail]()
        let fieldDescription = dict["fieldDescription"] as! NSDictionary
        let summary = dict["summary"] as! NSDictionary
        for (key, fieldData) in fieldDescription {
            let value = summary[key as! String]
            if (value != nil) {
                details.append(Detail(value: value as! Double, fieldDescription: fieldData as! NSDictionary))
            }
        }
        return details
    }
    
}