//
//  DetailCell.swift
//  CAReporting
//
//  Created by Kushal Bhatt on 10/18/15.
//  Copyright © 2015 Kushal Bhatt. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var fieldValue: UILabel!
    @IBOutlet weak var fieldName: UILabel!
    
    var detail: Detail! {
        didSet {
            fieldName.text = detail.displayString
            fieldValue.text = detail.valueString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
