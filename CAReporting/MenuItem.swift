//
//  MenuItem.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit

class MenuItem {
    let title: String
    let image: UIImage?
    
    init(title:String, image:UIImage) {
        self.title = title
        self.image = image
    }
    
    init(title: String) {
        self.title = title
        self.image = nil
    }
    
    class func allMenuItems() -> Array<MenuItem> {
        return [MenuItem(title: "Ads"),
            MenuItem(title: "SCM"),
            MenuItem(title: "SEO")]
    }
}